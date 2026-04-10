import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../providers/theme_provider.dart';
import '../../providers/branch_provider.dart';
import '../../../core/app_theme.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'support@ldma.in',
      query: 'subject=Support Request - Shree Rajmandir POS v2.0',
    );

    try {
      if (await canLaunchUrl(emailLaunchUri)) {
        await launchUrl(emailLaunchUri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch email client';
      }
    } catch (e) {
      // Fallback or error logging
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final branchAsync = ref.watch(branchProvider);

    return Scaffold(
      backgroundColor: AppTheme.cream,
      appBar: AppBar(
        title: const Text('APP SETTINGS', 
          style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.2)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: AppTheme.maroon,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        physics: const BouncingScrollPhysics(),
        children: [
          _buildSectionHeader('APPEARANCE'),
          _buildAestheticCard([
             _buildToggleRow(
              context,
              title: 'Dark Mode',
              subtitle: 'Sleek dark theme for night shifts',
              value: themeMode == ThemeMode.dark,
              icon: Icons.dark_mode_rounded,
              onChanged: (val) => ref.read(themeProvider.notifier).toggleTheme(val),
              isLast: true,
            ),
          ]),
          
          _buildSectionHeader('BRANCH INFORMATION'),
          branchAsync.when(
            data: (branch) => _buildAestheticCard([
              _buildSimpleTile(Icons.storefront_rounded, 'Branch Name', branch.branchName),
              _buildSimpleTile(Icons.location_on_rounded, 'Location', branch.location),
              _buildSimpleTile(Icons.map_rounded, 'Address', branch.address, isLast: true),
            ]),
            loading: () => const Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator(color: AppTheme.maroon))),
            error: (e, s) => Center(child: Text('Failed to load branch data: $e', style: const TextStyle(color: Colors.red))),
          ),
          
          _buildSectionHeader('SUPPORT & HELP'),
          _buildAestheticCard([
            _buildActionTile(
              context,
              icon: Icons.help_center_rounded,
              title: 'Contact Support',
              subtitle: 'support@ldma.in',
              onTap: _launchEmail,
            ),
            _buildActionTile(
              context,
              icon: Icons.info_rounded,
              title: 'App Version',
              subtitle: '2.0.0 (Build 2024.10.01)',
              onTap: () {}, // Added missing onTap
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.successGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('STABLE', style: TextStyle(color: AppTheme.successGreen, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
              isLast: true,
            ),
          ]),
          const SizedBox(height: 60),
          Center(
            child: Opacity(
              opacity: 0.5,
              child: Column(
                children: [
                  Image.asset('assets/branding/splash_logo.png', height: 40),
                  const SizedBox(height: 8),
                  const Text('Shree Rajmandir POS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  const Text('Powered by LDMA Technologies', style: TextStyle(fontSize: 10)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 32, 4, 12),
      child: Text(
        title,
        style: const TextStyle(
          color: AppTheme.maroon,
          fontWeight: FontWeight.w900,
          fontSize: 12,
          letterSpacing: 2.0,
        ),
      ),
    );
  }

  Widget _buildAestheticCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 5)),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildToggleRow(
    BuildContext context, {
    required String title,
    required String subtitle,
    required bool value,
    required IconData icon,
    required Function(bool) onChanged,
    bool isLast = false,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.maroon.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: AppTheme.maroon, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(subtitle, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                  ],
                ),
              ),
              Switch.adaptive(
                value: value,
                activeColor: AppTheme.maroon,
                activeTrackColor: AppTheme.maroon.withOpacity(0.3),
                onChanged: onChanged,
              ),
            ],
          ),
        ),
        if (!isLast) Divider(height: 1, indent: 72, color: Colors.grey.shade100),
      ],
    );
  }

  Widget _buildSimpleTile(IconData icon, String label, String value, {bool isLast = false}) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          leading: Icon(icon, size: 22, color: AppTheme.maroon.withOpacity(0.7)),
          title: Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
          subtitle: Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 15)),
        ),
        if (!isLast) Divider(height: 1, indent: 72, color: Colors.grey.shade100),
      ],
    );
  }

  Widget _buildActionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Widget? trailing,
    bool isLast = false,
  }) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.maroon.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppTheme.maroon, size: 20),
          ),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
          trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          onTap: onTap,
        ),
        if (!isLast) Divider(height: 1, indent: 72, color: Colors.grey.shade100),
      ],
    );
  }
}
