import 'package:flutter/material.dart';

class OfflineIndicator extends StatelessWidget {
  final bool isOffline;
  
  const OfflineIndicator({
    super.key, 
    required this.isOffline,
  });

  @override
  Widget build(BuildContext context) {
    if (!isOffline) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      color: Colors.redAccent,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.signal_wifi_off, color: Colors.white, size: 14),
          const SizedBox(width: 8),
          Text(
            'Offline Mode - Changes will sync when online',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
