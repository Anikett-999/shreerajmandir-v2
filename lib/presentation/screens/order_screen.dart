import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shreerajmandir_pos/core/app_theme.dart';
import 'package:shreerajmandir_pos/domain/models/category.dart';
import 'package:shreerajmandir_pos/domain/models/item.dart';
import 'package:shreerajmandir_pos/domain/models/table_model.dart';
import 'package:shreerajmandir_pos/domain/models/kot_model.dart';
import 'package:shreerajmandir_pos/services/menu_service.dart';
import 'package:shreerajmandir_pos/services/kot_service.dart';
import 'package:shreerajmandir_pos/services/print_service.dart';
import 'package:shreerajmandir_pos/presentation/providers/auth_provider.dart';
import 'package:shreerajmandir_pos/presentation/providers/printer_provider.dart';
import 'package:uuid/uuid.dart';

// --- State Providers ---
final menuServiceProvider = Provider((ref) => MenuService());
final kotServiceProvider = Provider((ref) => KOTService());

final categoriesProvider = StreamProvider<List<Category>>((ref) {
  return ref.watch(menuServiceProvider).watchCategories();
});

// Load the entire menu into memory so global search is instant (Zero Latency)
final allItemsProvider = StreamProvider<List<Item>>((ref) {
  return ref.watch(menuServiceProvider).watchAvailableItems();
});

// Holds the current Search Text state globally for the UI
final searchQueryProvider = StateProvider<String>((ref) => '');

class CartItem {
  final String cartId;
  final Item item;
  final String categoryName;
  final int quantity;
  final String? variant;
  final String note;

  CartItem({
    required this.cartId,
    required this.item,
    required this.categoryName,
    required this.quantity,
    this.variant,
    this.note = '',
  });

  CartItem copyWith({int? quantity, String? note}) {
    return CartItem(
      cartId: cartId,
      item: item,
      categoryName: categoryName,
      quantity: quantity ?? this.quantity,
      variant: variant,
      note: note ?? this.note,
    );
  }
}

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void addItem(Item item, String categoryName, {String? variant}) {
    final index = state.indexWhere((i) => i.item.itemId == item.itemId && i.variant == variant);
    if (index != -1) {
      state = [
        for (int i = 0; i < state.length; i++)
          if (i == index) state[i].copyWith(quantity: state[i].quantity + 1) else state[i]
      ];
    } else {
      state = [
        ...state,
        CartItem(
          cartId: const Uuid().v4(),
          item: item,
          categoryName: categoryName,
          quantity: 1,
          variant: variant,
        ),
      ];
    }
  }

  void updateQuantity(String cartId, int delta) {
    state = state
        .map((i) => i.cartId == cartId ? i.copyWith(quantity: i.quantity + delta) : i)
        .where((i) => i.quantity > 0)
        .toList();
  }

  void updateNote(String cartId, String note) {
    state = [
      for (final i in state)
        if (i.cartId == cartId) i.copyWith(note: note) else i
    ];
  }

  void clear() => state = [];

  double get total => state.fold(0, (sum, i) => sum + (i.item.price * i.quantity));
}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) => CartNotifier());

// --- Core Screen ---
class OrderScreen extends ConsumerStatefulWidget {
  final TableModel table;
  const OrderScreen({super.key, required this.table});

  @override
  ConsumerState<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends ConsumerState<OrderScreen> {
  String? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    // Wipe any lingering search state when navigating to a new table
    Future.microtask(() => ref.read(searchQueryProvider.notifier).state = '');
  }

  Future<void> _sendToKitchen() async {
    final cart = ref.read(cartProvider);
    if (cart.isEmpty) return;

    final kotService = ref.read(kotServiceProvider);
    final authUser = ref.read(authStateProvider).value;
    String userName = 'Staff';
    if (authUser?.displayName != null && authUser!.displayName!.isNotEmpty) {
      userName = authUser.displayName!;
    } else if (authUser?.email != null) {
      userName = authUser!.email!.split('@')[0];
    }

    final categories = ref.read(categoriesProvider).value ?? [];

    try {
      final kot = await kotService.createKOT(
        tableId: widget.table.tableId,
        tableName: widget.table.name,
        items: cart.map((i) {
          final matchedCat = categories.where((c) => c.categoryId == i.item.categoryId);
          final catName = matchedCat.isNotEmpty ? matchedCat.first.name : 'General';

          return KOTItem(
              uniqueId: i.cartId,
              itemId: i.item.itemId,
              name: i.item.name,
              category: catName,
              qty: i.quantity,
              price: i.item.price,
              variant: i.variant ?? '',
              note: i.note);
        }).toList(),
        userId: authUser?.uid ?? 'unknown',
        userName: userName,
      );

      final config = ref.read(printerConfigProvider);
      bool printSuccess = true;
      String? printError;

      if (config.autoPrintKOT) {
        try {
          final printService = ref.read(printServiceProvider);
          final bytes = await printService.generateKOTBytes(kot, config.paperSize);
          await printService.printReceipt(bytes, config);
        } catch (e) {
          printSuccess = false;
          printError = e.toString();
        }
      }

      if (!printSuccess && mounted) {
        final proceed = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.print_disabled, color: Colors.orange),
                SizedBox(width: 8),
                Text('Print Failed'),
              ],
            ),
            content: Text(
                'KOT was saved to system, but printing failed.\n\nError: $printError\n\nDo you want to retry printing or finish order?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('RETRY PRINT'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.maroon, foregroundColor: Colors.white),
                child: const Text('FINISH ANYWAY'),
              ),
            ],
          ),
        );

        if (proceed != true) {
          // If they chose retry (returned false), we trigger printing loop again
          return _sendToKitchen();
        }
      }

      ref.read(cartProvider.notifier).clear();

      if (mounted) {
        final message = config.autoPrintKOT 
            ? '✅ KOT Sent and Printed!' 
            : '✅ KOT Sent to Kitchen (Auto-Print OFF)';
        
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message),
          backgroundColor: AppTheme.deepGreen,
        ));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('❌ Error: $e'),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine screen layout boundaries (900px is the crossover point)
    final isDesktop = MediaQuery.of(context).size.width > 900;
    final tableName = widget.table.name.replaceAll('Table ', '');

    return Scaffold(
      appBar: AppBar(
        title: Text('Table $tableName'),
        centerTitle: false,
        actions: [
           // Universal Global Search Input across all modes
           Container(
             width: isDesktop ? 300 : MediaQuery.of(context).size.width * 0.45,
             margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
             child: CupertinoSearchTextField(
               placeholder: 'Search item',
               placeholderStyle: const TextStyle(color: Colors.black54),
               backgroundColor: isDesktop ? null : Colors.white,
               style: TextStyle(color: isDesktop ? Colors.white : Colors.black),
               onChanged: (val) => ref.read(searchQueryProvider.notifier).state = val,
             ),
           ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 900) {
            return _buildDesktopLayout();
          } else {
            return _buildMobileLayout();
          }
        },
      ),
      // Only attach Bottom App Bar for Mobile instances
      bottomNavigationBar: isDesktop ? null : _buildMobileCartBottomBar(),
    );
  }

  // --- COMPONENT: SHARED ITEM GRID ---
  Widget _buildItemGrid(bool isMobile) {
    final query = ref.watch(searchQueryProvider).toLowerCase();
    final allItemsAsync = ref.watch(allItemsProvider);
    final categoriesAsync = ref.watch(categoriesProvider);

    return allItemsAsync.when(
      data: (items) {
        // Zero-Latency Filtering Logic natively in memory
        List<Item> displayItems = items;
        
        if (query.isNotEmpty) {
          // Ignore category selections if typing to search everything
          displayItems = items.where((i) => i.name.toLowerCase().contains(query)).toList();
        } else if (_selectedCategoryId != null) {
          displayItems = items.where((i) => i.categoryId == _selectedCategoryId).toList();
        } else {
          displayItems = [];
        }

        if (displayItems.isEmpty) return Center(child: Text(query.isNotEmpty ? 'No items matched "$query"' : 'No items found.'));

        return GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: isMobile ? 180 : 200, // Optimize sizing for phone real-estate
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: isMobile ? 0.9 : 1.2,
          ),
          itemCount: displayItems.length,
          itemBuilder: (context, index) {
            final item = displayItems[index];
            
            // Map category id to real name
            String catName = '';
            if (categoriesAsync.hasValue) {
               final matched = categoriesAsync.value!.where((c) => c.categoryId == item.categoryId);
               if (matched.isNotEmpty) {
                  catName = matched.first.name;
               }
            }

            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  if (item.variants.isNotEmpty) {
                    _showVariantDialog(item, catName);
                  } else {
                    ref.read(cartProvider.notifier).addItem(item, catName);
                    if (isMobile) {
                      _showItemAddedFeedback(item.name);
                    }
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(item.name,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      if (catName.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(catName.toUpperCase(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.grey, fontSize: 11, letterSpacing: 0.5)),
                      ],
                      const SizedBox(height: 8),
                      Text('₹${item.price.toStringAsFixed(0)}',
                          style: const TextStyle(color: AppTheme.deepGreen, fontWeight: FontWeight.bold, fontSize: 18)),
                      if (item.variants.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        const Text('Has Variants', style: TextStyle(color: Colors.grey, fontSize: 10)),
                      ],
                    ],
                  ),
                ),
              ),
            );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, s) => Center(child: Text('Error: $e')),
        );
      }

      void _showItemAddedFeedback(String itemName) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$itemName added!'),
            duration: const Duration(milliseconds: 500),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }

      void _showVariantDialog(Item item, String catName) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Select Variant for ${item.name}'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: item.variants
                  .map((v) => ListTile(
                        title: Text(v),
                        onTap: () {
                          ref.read(cartProvider.notifier).addItem(item, catName, variant: v);
                          Navigator.pop(context);
                          _showItemAddedFeedback('${item.name} ($v)');
                        },
                      ))
                  .toList(),
            ),
          ),
        );
      }

  // --- MOBILE LAYOUT: PORTRAIT MODES ---
  Widget _buildMobileLayout() {
    final categoriesAsync = ref.watch(categoriesProvider);
    final isSearching = ref.watch(searchQueryProvider).isNotEmpty;

    return Column(
      children: [
        // Hide horizontal categories when global search is actively engaged
        if (!isSearching)
           SizedBox(
             height: 60,
             child: categoriesAsync.maybeWhen(
               data: (categories) {
                 if (_selectedCategoryId == null && categories.isNotEmpty) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                       if(mounted) setState(() => _selectedCategoryId = categories.first.categoryId);
                    });
                 }
                 return ListView.builder(
                   scrollDirection: Axis.horizontal,
                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                   itemCount: categories.length,
                   itemBuilder: (context, index) {
                     final cat = categories[index];
                     final selected = _selectedCategoryId == cat.categoryId;
                     return Padding(
                       padding: const EdgeInsets.only(right: 8),
                       child: ChoiceChip(
                         label: Text(cat.name, style: TextStyle(fontWeight: selected ? FontWeight.bold : FontWeight.normal)),
                         selected: selected,
                         selectedColor: AppTheme.maroon.withOpacity(0.1),
                         onSelected: (val) {
                           if(val) setState(() => _selectedCategoryId = cat.categoryId);
                         },
                       ),
                     );
                   },
                 );
               },
               orElse: () => const SizedBox(),
             ),
           ),
        // Item Display Canvas    
        Expanded(child: _buildItemGrid(true)),
      ],
    );
  }

  Widget _buildMobileCartBottomBar() {
    final cart = ref.watch(cartProvider);
    final total = ref.read(cartProvider.notifier).total;
    if (cart.isEmpty) return const SizedBox.shrink();

    int totalItems = cart.fold(0, (sum, i) => sum + i.quantity);

    return SafeArea(
      child: Container(
        height: 75,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, -4))],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('$totalItems Items', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                Text('₹${total.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: AppTheme.maroon)),
              ],
            ),
            ElevatedButton.icon(
              onPressed: _showMobileCartSheet,
              icon: const Icon(Icons.shopping_cart),
              label: const Text('SEE CART'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.maroon, 
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMobileCartSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8, // Take up 80% of screen giving breathing room
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text('REVIEW KOT', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const Divider(thickness: 2, height: 30),
              Expanded(child: _buildCartList()), 
              const Divider(thickness: 2, height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   const Text('GRAND TOTAL', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                   Consumer(builder: (c, ref, _) {
                      return Text('₹${ref.watch(cartProvider.notifier).total.toStringAsFixed(0)}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppTheme.maroon));
                   }),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: Consumer(builder: (c, ref, _) {
                   final cart = ref.watch(cartProvider);
                   return ElevatedButton(
                     onPressed: cart.isEmpty ? null : () {
                       Navigator.pop(ctx);
                       _sendToKitchen();
                     },
                     style: ElevatedButton.styleFrom(
                       backgroundColor: AppTheme.deepGreen, 
                       foregroundColor: Colors.white,
                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                     ),
                     child: const Text('SEND TO KITCHEN', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                   );
                }),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      }
    );
  }

  // --- DESKTOP LAYOUT: IPAD LANDSCAPE & PC ---
  Widget _buildDesktopLayout() {
    final categoriesAsync = ref.watch(categoriesProvider);
    final isSearching = ref.watch(searchQueryProvider).isNotEmpty;

    return Row(
      children: [
        // 1. Categories Left Panel
        SizedBox(
          width: 140,
          child: categoriesAsync.when(
             data: (categories) {
               if (_selectedCategoryId == null && categories.isNotEmpty) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                       if(mounted) setState(() => _selectedCategoryId = categories.first.categoryId);
                    });
               }
               return ListView.builder(
                 itemCount: categories.length,
                 itemBuilder: (context, index) {
                   final cat = categories[index];
                   final isSelected = _selectedCategoryId == cat.categoryId && !isSearching;
                   return InkWell(
                     onTap: () {
                         ref.read(searchQueryProvider.notifier).state = ''; // Clear search when clicking category naturally
                         setState(() => _selectedCategoryId = cat.categoryId);
                     },
                     child: Container(
                       padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
                        color: isSelected ? AppTheme.maroon.withOpacity(0.1) : null,
                       child: Text(
                         cat.name,
                         textAlign: TextAlign.center,
                         style: TextStyle(
                           fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? AppTheme.maroon : null,
                         ),
                       ),
                     ),
                   );
                 },
               );
             },
             loading: () => const Center(child: CircularProgressIndicator()),
             error: (e,s) => const Center(child: Icon(Icons.error)),
          ),
        ),
        const VerticalDivider(width: 1),
        
        // 2. Items Center Panel
        Expanded(flex: 3, child: _buildItemGrid(false)),
        const VerticalDivider(width: 1),

        // 3. Cart Right Panel (Persistent)
        SizedBox(
          width: 350,
          child: Column(
            children: [
              const Padding(padding: EdgeInsets.all(16.0), child: Text('CURRENT KOT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
              Expanded(child: _buildCartList()),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  border: const Border(top: BorderSide(color: Colors.grey, width: 0.5)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('TOTAL', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                        Text('₹${ref.read(cartProvider.notifier).total.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 26, color: AppTheme.maroon)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: ElevatedButton(
                        onPressed: ref.watch(cartProvider).isEmpty ? null : _sendToKitchen,
                        style: ElevatedButton.styleFrom(backgroundColor: AppTheme.deepGreen, foregroundColor: Colors.white),
                        child: const Text('SEND TO KITCHEN', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCartList() {
    return Consumer(
      builder: (context, ref, child) {
        final cart = ref.watch(cartProvider);
        if(cart.isEmpty) return const Center(child: Text('Add items from the menu.', style: TextStyle(color: Colors.grey, fontSize: 18)));

        return ListView.separated(
          itemCount: cart.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final i = cart[index];
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                title: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(i.item.name, 
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 2),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(i.categoryName.toUpperCase(), 
                              style: TextStyle(color: Colors.grey[700], fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                          ),
                        ],
                      ),
                    ),
                    if (i.variant != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.maroon.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(i.variant!, 
                            style: const TextStyle(color: AppTheme.maroon, fontSize: 11, fontWeight: FontWeight.w600)),
                        ),
                      ),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('₹${(i.item.price * i.quantity).toStringAsFixed(0)}', 
                      style: const TextStyle(color: AppTheme.deepGreen, fontSize: 15, fontWeight: FontWeight.w600)),
                    if (i.note.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text('Note: ${i.note}', 
                          style: const TextStyle(color: Colors.orange, fontSize: 13, fontStyle: FontStyle.italic)),
                      ),
                    TextButton.icon(
                      onPressed: () => _showNoteDialog(i.cartId, i.note),
                      icon: const Icon(Icons.edit_note, size: 20),
                      label: Text(i.note.isEmpty ? 'Add Note' : 'Edit Note', style: const TextStyle(fontSize: 12)),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        foregroundColor: AppTheme.maroon,
                      ),
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        icon: const Icon(Icons.remove_circle_outline, size: 24), 
                        onPressed: () => ref.read(cartProvider.notifier).updateQuantity(i.cartId, -1)
                    ),
                    Container(
                        alignment: Alignment.center,
                        width: 32,
                        child: Text('${i.quantity}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
                    ),
                    IconButton(
                        icon: const Icon(Icons.add_circle, size: 24), 
                        color: AppTheme.maroon, 
                        onPressed: () => ref.read(cartProvider.notifier).updateQuantity(i.cartId, 1)
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
    );
  }

  void _showNoteDialog(String cartId, String currentNote) {
    final controller = TextEditingController(text: currentNote);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Special Instructions'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'e.g. Less spicy, No onion'),
          maxLines: 2,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL')),
          ElevatedButton(
            onPressed: () {
              ref.read(cartProvider.notifier).updateNote(cartId, controller.text);
              Navigator.pop(context);
            },
            child: const Text('SAVE'),
          ),
        ],
      ),
    );
  }
}
