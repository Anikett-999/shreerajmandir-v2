import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Settings'),
        elevation: 0,
      ),
      body: ListView(
        children: [
          _buildSectionHeader(context, 'Appearance'),
          SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: const Text('Use a dark theme for eye comfort'),
            value: Theme.of(context).brightness == Brightness.dark,
            onChanged: (val) {
              // Internal theme state should be updated here
            },
            secondary: const Icon(Icons.dark_mode_outlined),
          ),
          const Divider(),
          _buildSectionHeader(context, 'Branch Information'),
          ListTile(
            leading: const Icon(Icons.storefront),
            title: const Text('Current Branch'),
            subtitle: const Text('Rajmandir - Main Branch'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.location_on_outlined),
            title: const Text('Branch Location'),
            subtitle: const Text('Pune, Maharashtra'),
          ),
          const Divider(),
          _buildSectionHeader(context, 'Support'),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Help Center'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('App Version'),
            subtitle: const Text('1.0.0 (Build 240409)'),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Colors.blueAccent,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
      ),
    );
  }
}
