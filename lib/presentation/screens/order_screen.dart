import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/app_theme.dart';
import '../../domain/models/category.dart';
import '../../domain/models/item.dart';
import '../../domain/models/table_model.dart';
import '../../domain/models/kot_model.dart';
import '../../services/menu_service.dart';
import '../../services/kot_service.dart';

// --- State Providers ---
final menuServiceProvider = Provider((ref) => MenuService());

final categoriesProvider = StreamProvider<List<Category>>((ref) {
  return ref.watch(menuServiceProvider).watchCategories();
});

// Load the entire menu into memory so global search is instant (Zero Latency)
final allItemsProvider = StreamProvider<List<Item>>((ref) {
  return ref.watch(menuServiceProvider).watchAvailableItems();
});

// Holds the current Search Text state globally for the UI
final searchQueryProvider = StateProvider<String>((ref) => '');

// --- Cart Logic ---
class CartItem {
  final Item item;
  int quantity;
  String note;
  CartItem({required this.item, required this.quantity, this.note = ''});
}

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void addItem(Item item) {
    var index = state.indexWhere((i) => i.item.itemId == item.itemId);
    if (index != -1) {
      state[index] = CartItem(item: item, quantity: state[index].quantity + 1, note: state[index].note);
      state = [...state];
    } else {
      state = [...state, CartItem(item: item, quantity: 1)];
    }
  }

  void updateQuantity(String id, int delta) {
    state = state.map((i) {
      if (i.item.itemId == id) {
        int nq = i.quantity + delta;
        return CartItem(item: i.item, quantity: nq, note: i.note);
      }
      return i;
    }).where((i) => i.quantity > 0).toList();
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
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pushing KOT to Server...')),
    );
    
    try {
      final kotService = KOTService();
      await kotService.createKOT(
        tableId: widget.table.tableId,
        items: cart.map((i) => KOTItem(
          itemId: i.item.itemId, 
          name: i.item.name, 
          category: i.item.categoryId, 
          qty: i.quantity, 
          price: i.item.price, 
          note: i.note
        )).toList(),
        userId: 'admin', // Future scope: dynamically link logged-in waiter ID
      );
      
      ref.read(cartProvider.notifier).clear();
      
      if(mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(
             content: Text('✅ KOT Successfully Sent to Kitchen!'), 
             backgroundColor: AppTheme.brandGreen,
             duration: Duration(seconds: 2),
           )
         );
         Navigator.pop(context); // Automatically leave Order Screen so they can serve other tables
      }
    } catch (e) {
       if(mounted) {
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('❌ Error: $e'), backgroundColor: Colors.red));
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
               placeholder: 'Search any item...',
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
                onTap: () {
                  ref.read(cartProvider.notifier).addItem(item);
                  if(isMobile) {
                     ScaffoldMessenger.of(context).clearSnackBars(); // Prevent spam stack
                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${item.name} added!'), duration: const Duration(milliseconds: 500)));
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(item.name, textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      if (catName.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(catName.toUpperCase(), textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey, fontSize: 11, letterSpacing: 0.5)),
                      ],
                      const SizedBox(height: 8),
                      Text('₹${item.price.toStringAsFixed(0)}', style: const TextStyle(color: AppTheme.brandGreen, fontWeight: FontWeight.bold, fontSize: 18)),
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
                         selectedColor: AppTheme.billingBlue.withOpacity(0.3),
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
                Text('₹${total.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: AppTheme.primaryRed)),
              ],
            ),
            ElevatedButton.icon(
              onPressed: _showMobileCartSheet,
              icon: const Icon(Icons.shopping_cart),
              label: const Text('SEE CART'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.billingBlue, 
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
                     return Text('₹${ref.watch(cartProvider.notifier).total.toStringAsFixed(0)}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppTheme.primaryRed));
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
                       backgroundColor: AppTheme.availableGreen, 
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
                       color: isSelected ? AppTheme.billingBlue.withOpacity(0.1) : null,
                       child: Text(
                         cat.name,
                         textAlign: TextAlign.center,
                         style: TextStyle(
                           fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                           color: isSelected ? AppTheme.billingBlue : null,
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
                        Text('₹${ref.read(cartProvider.notifier).total.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 26, color: AppTheme.primaryRed)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: ElevatedButton(
                        onPressed: ref.watch(cartProvider).isEmpty ? null : _sendToKitchen,
                        style: ElevatedButton.styleFrom(backgroundColor: AppTheme.availableGreen, foregroundColor: Colors.white),
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

  // --- SHARED COMPONENT: CART LIST VIEW ---
  // Works flawlessly for both the massive Desktop Right-Panel and Mobile Bottom Sheet
  Widget _buildCartList() {
    return Consumer(
      builder: (context, ref, child) {
        final cart = ref.watch(cartProvider);
        if(cart.isEmpty) return const Center(child: Text('Add items from the menu.', style: TextStyle(color: Colors.grey, fontSize: 18)));

        return ListView.builder(
          itemCount: cart.length,
          itemBuilder: (context, index) {
            final i = cart[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: ListTile(
                title: Text(i.item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                subtitle: Text('₹${(i.item.price * i.quantity).toStringAsFixed(0)}', style: const TextStyle(color: AppTheme.brandGreen, fontSize: 15)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        icon: const Icon(Icons.remove_circle_outline, size: 28), 
                        onPressed: () => ref.read(cartProvider.notifier).updateQuantity(i.item.itemId, -1)
                    ),
                    Container(
                        alignment: Alignment.center,
                        width: 32,
                        child: Text('${i.quantity}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
                    ),
                    IconButton(
                        icon: const Icon(Icons.add_circle, size: 28), 
                        color: AppTheme.primaryRed, 
                        onPressed: () => ref.read(cartProvider.notifier).updateQuantity(i.item.itemId, 1)
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
}
