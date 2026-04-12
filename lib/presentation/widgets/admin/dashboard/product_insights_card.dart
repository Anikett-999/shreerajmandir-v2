import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/app_theme.dart';
import '../../../providers/dashboard_provider.dart';
import '../../../../domain/models/product_insights.dart';
import '../../../screens/admin/dashboard/product_insights_screen.dart';

class ProductInsightsCard extends ConsumerWidget {
  const ProductInsightsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insightsAsync = ref.watch(productInsightsProvider);

    return insightsAsync.when(
      data: (insights) => _buildCard(context, insights),
      loading: () => const _LoadingCard(),
      error: (err, stack) => _ErrorCard(error: err.toString()),
    );
  }

  Widget _buildCard(BuildContext context, ProductInsights insights) {
    final topItems = insights.topItems.take(3).toList();
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.08),
            offset: const Offset(0, 12),
            blurRadius: 24,
            spreadRadius: -4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.insights_rounded, color: Colors.orange, size: 20),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'PRODUCT INSIGHTS',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  '30D',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (topItems.isEmpty)
            const Expanded(
              child: Center(
                child: Text('No sales data for past 30 days', 
                  style: TextStyle(color: Colors.grey, fontSize: 12)),
              ),
            )
          else ...[
            const Text(
              'TOP PERFORMERS',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            ...topItems.map((item) => _buildItemRow(item, topItems.first.quantity)),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProductInsightsScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF8F9FA),
                  foregroundColor: AppTheme.maroon,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('FULL ANALYSIS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800)),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_forward_rounded, size: 14),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildItemRow(dynamic item, int maxQty) {
    final progress = item.quantity / maxQty;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item.name,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87),
              ),
              Text(
                '${item.quantity} sold',
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black54),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[100],
              color: Colors.orange.withOpacity(0.6),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final String error;
  const _ErrorCard({required this.error});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Center(child: Text('Error: $error', style: const TextStyle(fontSize: 10))),
    );
  }
}
