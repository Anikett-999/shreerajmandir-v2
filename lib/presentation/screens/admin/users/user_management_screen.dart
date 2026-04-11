import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/app_theme.dart';
import '../../../../domain/models/user_model.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/branch_provider.dart';
import '../../../widgets/global/base_widgets.dart';

class UserManagementScreen extends ConsumerWidget {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(allUsersProvider);

    return Scaffold(
      backgroundColor: AppTheme.cream,
      appBar: AppBar(
        title: const Text('USER MANAGEMENT', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.2, color: AppTheme.maroon)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.black.withOpacity(0.1),
        scrolledUnderElevation: 4,
        iconTheme: const IconThemeData(color: AppTheme.maroon),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt_1),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => const _AddUserBottomSheet(),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: usersAsync.when(
        data: (users) {
          if (users.isEmpty) {
            return const EmptyStateWidget(
              title: 'No Users Found',
              message: 'There are no registered users in the system.',
              icon: Icons.people_outline,
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 16),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return _UserListItem(user: user);
            },
          );
        },
        loading: () => const LoadingIndicator(message: 'Loading users...'),
        error: (err, _) => ErrorStateWidget(error: err.toString()),
      ),
    );
  }
}

class _UserListItem extends ConsumerWidget {
  final UserModel user;
  const _UserListItem({required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = ref.watch(authServiceProvider);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: _getRoleColor(user.role).withOpacity(0.12),
              child: Text(
                user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                style: TextStyle(color: _getRoleColor(user.role), fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    user.email,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      // Role badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: _getRoleColor(user.role).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          user.role.toUpperCase(),
                          style: TextStyle(fontSize: 10, color: _getRoleColor(user.role), fontWeight: FontWeight.bold),
                        ),
                      ),
                      // Branch count badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${user.branchIds.length} branch${user.branchIds.length == 1 ? '' : 'es'}',
                          style: TextStyle(fontSize: 10, color: Colors.grey.shade600, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  user.isActive ? 'ACTIVE' : 'DISABLED',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: user.isActive ? AppTheme.successGreen : Colors.red,
                  ),
                ),
                Transform.scale(
                  scale: 0.8,
                  child: Switch(
                    value: user.isActive,
                    activeColor: AppTheme.successGreen,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    onChanged: (value) async {
                      try {
                        await authService.toggleUserActiveStatus(user.userId, user.isActive);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Account ${value ? 'enabled' : 'disabled'} for ${user.name}'),
                              backgroundColor: value ? AppTheme.successGreen : Colors.orange,
                            ),
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
                  ),
                ),
              ],
            ),
            const SizedBox(width: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.info_outline, color: Colors.grey, size: 22),
                  onPressed: () => _showUserDetails(context, user),
                ),
                const SizedBox(width: 8),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.edit_outlined, color: AppTheme.maroon, size: 22),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => _EditUserBottomSheet(user: user),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showUserDetails(BuildContext context, UserModel user) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: _getRoleColor(user.role).withOpacity(0.12),
                  child: Text(user.name[0].toUpperCase(), style: TextStyle(fontSize: 24, color: _getRoleColor(user.role), fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Text(user.userId, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _detailRow('Email', user.email),
            _detailRow('Role', user.role.toUpperCase()),
            _detailRow('Status', user.isActive ? 'Active' : 'Disabled'),
            _detailRow('Last Login', user.lastLogin?.toString().split('.').first ?? 'Never'),
            const SizedBox(height: 16),
            const Text('ASSIGNED BRANCHES', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppTheme.maroon)),
            const SizedBox(height: 8),
            if (user.branchIds.isEmpty)
              const Text('No branches assigned', style: TextStyle(color: Colors.grey))
            else
              ...user.branchIds.map((b) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text('• $b', style: const TextStyle(fontSize: 14)),
              )),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.maroon,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('CLOSE'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.maroon,
                  side: const BorderSide(color: AppTheme.maroon),
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => _EditUserBottomSheet(user: user),
                  );
                },
                child: const Text('EDIT USER'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'admin': return Colors.purple;
      case 'cashier': return Colors.green;
      case 'waiter': return Colors.blue;
      default: return Colors.grey;
    }
  }
}

// ─── Add User ───────────────────────────────────────────────────────────────

class _AddUserBottomSheet extends ConsumerStatefulWidget {
  const _AddUserBottomSheet();

  @override
  ConsumerState<_AddUserBottomSheet> createState() => _AddUserBottomSheetState();
}

class _AddUserBottomSheetState extends ConsumerState<_AddUserBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  String _selectedRole = 'cashier';
  List<String> _selectedBranchIds = [];
  bool _isLoading = false;

  final List<String> _availableRoles = ['admin', 'cashier', 'waiter'];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedBranchIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please assign at least one branch'), backgroundColor: Colors.orange),
      );
      return;
    }
    setState(() => _isLoading = true);
    
    try {
      final authService = ref.read(authServiceProvider);
      await authService.registerUser(
        _emailCtrl.text.trim(),
        _passCtrl.text,
        _nameCtrl.text.trim(),
        _selectedRole,
        _selectedBranchIds,
      );
      
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User added successfully!'), backgroundColor: AppTheme.successGreen),
        );
      }
    } catch (e) {
       if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
          );
       }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _UserFormSheet(
      formKey: _formKey,
      title: 'Add New User',
      nameCtrl: _nameCtrl,
      emailCtrl: _emailCtrl,
      passCtrl: _passCtrl,
      selectedRole: _selectedRole,
      selectedBranchIds: _selectedBranchIds,
      availableRoles: _availableRoles,
      isLoading: _isLoading,
      isNew: true,
      onRoleChanged: (v) => setState(() => _selectedRole = v),
      onBranchToggled: (branchId) {
        setState(() {
          if (_selectedBranchIds.contains(branchId)) {
            _selectedBranchIds.remove(branchId);
          } else {
            _selectedBranchIds.add(branchId);
          }
        });
      },
      onSubmit: _submit,
    );
  }
}

// ─── Edit User ───────────────────────────────────────────────────────────────

class _EditUserBottomSheet extends ConsumerStatefulWidget {
  final UserModel user;
  const _EditUserBottomSheet({required this.user});

  @override
  ConsumerState<_EditUserBottomSheet> createState() => _EditUserBottomSheetState();
}

class _EditUserBottomSheetState extends ConsumerState<_EditUserBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  late String _selectedRole;
  late List<String> _selectedBranchIds;
  bool _isLoading = false;

  final List<String> _availableRoles = ['admin', 'cashier', 'waiter'];

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.user.name);
    _emailCtrl = TextEditingController(text: widget.user.email);
    _selectedRole = widget.user.role;
    _selectedBranchIds = List<String>.from(widget.user.branchIds);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedBranchIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please assign at least one branch'), backgroundColor: Colors.orange),
      );
      return;
    }
    setState(() => _isLoading = true);

    try {
      final authService = ref.read(authServiceProvider);
      await authService.updateUserData(widget.user.userId, {
        'name': _nameCtrl.text.trim(),
        'role': _selectedRole,
        'branchIds': _selectedBranchIds,
      });
      
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User updated successfully!'), backgroundColor: AppTheme.successGreen),
        );
      }
    } catch (e) {
       if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
          );
       }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _UserFormSheet(
      formKey: _formKey,
      title: 'Edit User',
      nameCtrl: _nameCtrl,
      emailCtrl: _emailCtrl,
      selectedRole: _selectedRole,
      selectedBranchIds: _selectedBranchIds,
      availableRoles: _availableRoles,
      isLoading: _isLoading,
      isNew: false,
      onRoleChanged: (v) => setState(() => _selectedRole = v),
      onBranchToggled: (branchId) {
        setState(() {
          if (_selectedBranchIds.contains(branchId)) {
            _selectedBranchIds.remove(branchId);
          } else {
            _selectedBranchIds.add(branchId);
          }
        });
      },
      onSubmit: _submit,
    );
  }
}

// ─── Shared Form Sheet ───────────────────────────────────────────────────────

class _UserFormSheet extends ConsumerWidget {
  final GlobalKey<FormState>? formKey;
  final String title;
  final TextEditingController nameCtrl;
  final TextEditingController emailCtrl;
  final TextEditingController? passCtrl;
  final String selectedRole;
  final List<String> selectedBranchIds;
  final List<String> availableRoles;
  final bool isLoading;
  final bool isNew;
  final ValueChanged<String> onRoleChanged;
  final ValueChanged<String> onBranchToggled;
  final VoidCallback onSubmit;

  const _UserFormSheet({
    this.formKey,
    required this.title,
    required this.nameCtrl,
    required this.emailCtrl,
    this.passCtrl,
    required this.selectedRole,
    required this.selectedBranchIds,
    required this.availableRoles,
    required this.isLoading,
    required this.isNew,
    required this.onRoleChanged,
    required this.onBranchToggled,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allBranchesAsync = ref.watch(allBranchesProvider);

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 24, left: 24, right: 24,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: SafeArea(
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.maroon)),
                const SizedBox(height: 16),
                TextFormField(
                  controller: nameCtrl,
                  decoration: InputDecoration(
                    labelText: 'Full Name', 
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))
                  ),
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: emailCtrl,
                  decoration: InputDecoration(
                    labelText: 'Email Address', 
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: !isNew,
                    fillColor: isNew ? null : Colors.grey.shade100,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  enabled: isNew,
                  validator: isNew ? (v) => !v!.contains('@') ? 'Invalid email' : null : null,
                ),
                if (isNew && passCtrl != null) ...[
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: passCtrl,
                    decoration: InputDecoration(
                      labelText: 'Temporary Password', 
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))
                    ),
                    obscureText: true,
                    validator: (v) => v!.length < 6 ? 'Min 6 chars' : null,
                  ),
                ],
                const SizedBox(height: 12),
                // Role dropdown — single role for all branches
                DropdownButtonFormField<String>(
                  value: selectedRole,
                  decoration: InputDecoration(
                    labelText: 'Role (same across all branches)',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))
                  ),
                  items: availableRoles.map((r) => DropdownMenuItem(value: r, child: Text(r.toUpperCase()))).toList(),
                  onChanged: (v) => onRoleChanged(v!),
                ),
                const SizedBox(height: 16),
                const Text('ASSIGN BRANCHES', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.maroon, letterSpacing: 1)),
                const SizedBox(height: 8),
                allBranchesAsync.when(
                  data: (branches) {
                    if (branches.isEmpty) {
                      return const Text('No branches available', style: TextStyle(color: Colors.red));
                    }
                    return Column(
                      children: branches.map((b) {
                        final isSelected = selectedBranchIds.contains(b.branchId);
                        return CheckboxListTile(
                          value: isSelected,
                          onChanged: (_) => onBranchToggled(b.branchId),
                          title: Text(b.branchName, style: const TextStyle(fontWeight: FontWeight.w600)),
                          subtitle: Text(b.branchId, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                          activeColor: AppTheme.maroon,
                          contentPadding: EdgeInsets.zero,
                          controlAffinity: ListTileControlAffinity.leading,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        );
                      }).toList(),
                    );
                  },
                  loading: () => const LinearProgressIndicator(),
                  error: (e, _) => Text('Error loading branches: $e'),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.maroon,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: isLoading ? null : onSubmit,
                  child: isLoading 
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Text(isNew ? 'CREATE USER' : 'SAVE CHANGES', style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
