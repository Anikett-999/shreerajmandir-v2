import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:shreerajmandir_pos/services/kot_service.dart';
import 'package:shreerajmandir_pos/domain/models/kot_model.dart';
import 'package:shreerajmandir_pos/core/app_theme.dart';

final kotServiceProvider = Provider<KOTService>((ref) => KOTService());

final liveKOTsProvider = StreamProvider<List<KOTModel>>((ref) {
  return ref.watch(kotServiceProvider).watchLiveKOTs();
});

class KOTScreen extends ConsumerWidget {
  const KOTScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final liveKOTs = ref.watch(liveKOTsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('KOT MONITOR'),
        centerTitle: true,
      ),
      body: liveKOTs.when(
        data: (kots) {
          if (kots.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No Active KOTs', style: TextStyle(fontSize: 20, color: Colors.grey, fontWeight: FontWeight.bold)),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 400,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              mainAxisExtent: 450,
            ),
            itemCount: kots.length,
            itemBuilder: (context, index) {
              return _KOTCard(kot: kots[index]);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _KOTCard extends ConsumerWidget {
  final KOTModel kot;
  const _KOTCard({required this.kot});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timeStr = timeago.format(kot.createdAt, locale: 'en_short');
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppTheme.maroon,
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Table ${kot.tableId}', 
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                    Text('KOT #${kot.kotNumber}', 
                      style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(timeStr, 
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                ),
              ],
            ),
          ),
          
          // Items List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: kot.items.length,
              itemBuilder: (context, idx) {
                final item = kot.items[idx];
                final isServed = item.status == 'served';

                return ListTile(
                  dense: true,
                  leading: Text('${item.qty}x', 
                    style: TextStyle(
                      fontWeight: FontWeight.bold, 
                      fontSize: 16,
                      color: isServed ? Colors.grey : AppTheme.maroon,
                    )),
                  title: Text(item.name, 
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      decoration: isServed ? TextDecoration.lineThrough : null,
                      color: isServed ? Colors.grey : Colors.black87,
                    )),
                  subtitle: item.variant.isNotEmpty || item.note.isNotEmpty 
                    ? Text('${item.variant}${item.note.isNotEmpty ? " • ${item.note}" : ""}',
                        style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic))
                    : null,
                  trailing: isServed 
                    ? const Icon(Icons.check_circle, color: AppTheme.deepGreen)
                    : OutlinedButton(
                        onPressed: () {
                          ref.read(kotServiceProvider).updateItemStatus(
                            kotId: kot.kotId,
                            itemUniqueId: item.uniqueId,
                            status: 'served',
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppTheme.deepGreen),
                          foregroundColor: AppTheme.deepGreen,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          minimumSize: const Size(0, 32),
                        ),
                        child: const Text('SERVE'),
                      ),
                );
              },
            ),
          ),
          
          // Footer
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('By: ${kot.createdBy}', 
                  style: const TextStyle(color: Colors.grey, fontSize: 11)),
                if (kot.items.every((i) => i.status == 'served'))
                  const Text('FULLY SERVED', 
                    style: TextStyle(color: AppTheme.deepGreen, fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
