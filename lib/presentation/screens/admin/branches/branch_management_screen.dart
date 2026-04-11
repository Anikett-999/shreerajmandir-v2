import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/app_theme.dart';
import '../../../../domain/models/branch_model.dart';
import '../../../../services/branch_service.dart';
import '../../../providers/branch_provider.dart';
import '../../../widgets/global/base_widgets.dart';

class BranchManagementScreen extends ConsumerWidget {
  const BranchManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final branchesAsync = ref.watch(allBranchesProvider);

    return Scaffold(
      backgroundColor: AppTheme.cream,
      appBar: AppBar(
        title: const Text('MY BRANCHES', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.2, color: AppTheme.maroon)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.black.withOpacity(0.1),
        scrolledUnderElevation: 4,
        iconTheme: const IconThemeData(color: AppTheme.maroon),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_business),
            onPressed: () => _addBranch(context, ref),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: branchesAsync.when(
        data: (branches) {
          if (branches.isEmpty) {
            return EmptyStateWidget(
              title: 'No Branches Configured',
              message: 'Database initialization might be incomplete.',
              icon: Icons.store_mall_directory_outlined,
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: branches.length,
            itemBuilder: (context, index) {
              final branch = branches[index];
              return _BranchListItem(branch: branch);
            },
          );
        },
        loading: () => LoadingIndicator(message: 'Loading branches...'),
        error: (err, _) => ErrorStateWidget(error: err.toString()),
      ),
    );
  }
  void _addBranch(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final locationController = TextEditingController();
    final addressController = TextEditingController();
    final phoneController = TextEditingController();

    // Auto-generate branch ID based on existing branches
    String newBranchId = 'branch_001';
    final branches = ref.read(allBranchesProvider).valueOrNull ?? [];
    if (branches.isNotEmpty) {
      int maxId = 0;
      for (final b in branches) {
        final idStr = b.branchId.replaceAll(RegExp(r'[^0-9]'), '');
        if (idStr.isNotEmpty) {
          final idNum = int.tryParse(idStr) ?? 0;
          if (idNum > maxId) {
            maxId = idNum;
          }
        }
      }
      newBranchId = 'branch_${(maxId + 1).toString().padLeft(3, '0')}';
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('ADD NEW BRANCH', style: TextStyle(fontWeight: FontWeight.w900, color: AppTheme.maroon)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Branch Name', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: locationController,
                decoration: InputDecoration(labelText: 'Short Location', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: addressController,
                maxLines: 2,
                decoration: InputDecoration(labelText: 'Full Address', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(labelText: 'Phone', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.maroon, foregroundColor: Colors.white),
            onPressed: () async {
              if (nameController.text.trim().isEmpty) return;
              
              final newBranch = BranchModel(
                branchId: newBranchId,
                branchName: nameController.text.trim(),
                location: locationController.text.trim(),
                address: addressController.text.trim(),
                phone: phoneController.text.trim(),
                isActive: true,
              );

              try {
                await ref.read(branchServiceProvider).createBranch(newBranch);
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Branch added successfully'), backgroundColor: AppTheme.successGreen),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
                  );
                }
              }
            },
            child: const Text('ADD BRANCH'),
          ),
        ],
      ),
    );
  }
}

class _BranchListItem extends ConsumerWidget {
  final BranchModel branch;
  const _BranchListItem({required this.branch});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.maroon.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.storefront_rounded, color: AppTheme.maroon),
        ),
        title: Text(
          branch.branchName,
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
        ),
        subtitle: Text(
          'ID: ${branch.branchId} • ${branch.location}',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w600),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Column(
              children: [
                const Divider(),
                const SizedBox(height: 16),
                _infoRow(Icons.location_on_outlined, 'Address', branch.address),
                const SizedBox(height: 12),
                _infoRow(Icons.phone_outlined, 'Contact', branch.phone),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppTheme.maroon),
                      foregroundColor: AppTheme.maroon,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () => _editBranch(context, ref),
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    label: const Text('EDIT DETAILS', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.1)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade400),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 10, color: Colors.grey.shade500, fontWeight: FontWeight.bold)),
              Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }

  void _editBranch(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController(text: branch.branchName);
    final locationController = TextEditingController(text: branch.location);
    final addressController = TextEditingController(text: branch.address);
    final phoneController = TextEditingController(text: branch.phone);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('EDIT BRANCH INFO', style: TextStyle(fontWeight: FontWeight.w900)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Branch Name', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: locationController,
                decoration: const InputDecoration(labelText: 'Location', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: addressController,
                maxLines: 2,
                decoration: const InputDecoration(labelText: 'Address', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Phone', border: OutlineInputBorder()),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.maroon, foregroundColor: Colors.white),
            onPressed: () async {
              final updatedBranch = branch.copyWith(
                branchName: nameController.text,
                location: locationController.text,
                address: addressController.text,
                phone: phoneController.text,
              );

              try {
                await ref.read(branchServiceProvider).updateBranchDetails(updatedBranch);
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Branch updated successfully'), backgroundColor: AppTheme.successGreen),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
                  );
                }
              }
            },
            child: const Text('SAVE CHANGES'),
          ),
        ],
      ),
    );
  }
}
