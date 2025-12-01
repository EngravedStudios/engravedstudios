import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/admin_user.dart';
import '../providers/admin_providers.dart';
import 'role_editor_dialog.dart';
import 'delete_user_dialog.dart';

class UsersDataTable extends ConsumerWidget {
  const UsersDataTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(filteredUsersProvider);

    return usersAsync.when(
      data: (users) => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: MaterialStateProperty.all(
            Theme.of(context).colorScheme.surfaceVariant,
          ),
          columns: const [
            DataColumn(
                label: Text('ID',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Name',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Email',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Role',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Created',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Actions',
                    style: TextStyle(fontWeight: FontWeight.bold))),
          ],
          rows: users.map((user) => DataRow(
                cells: [
                  DataCell(SelectableText(
                    user.userId.substring(0, 8),
                    style: const TextStyle(fontFamily: 'monospace'),
                  )),
                  DataCell(Text(user.name)),
                  DataCell(Text(user.email)),
                  DataCell(_buildRoleBadge(context, user.getPrimaryRole())),
                  DataCell(Text(_formatDate(user.createdAt))),
                  DataCell(Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.visibility),
                        tooltip: 'View Details',
                        onPressed: () => _viewDetails(context, ref, user),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        tooltip: 'Edit Roles',
                        onPressed: () => _editRoles(context, ref, user),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        tooltip: 'Delete User',
                        onPressed: () => _confirmDelete(context, ref, user),
                      ),
                    ],
                  )),
                ],
              )).toList(),
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text('Error: $error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.invalidate(adminUsersProvider),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleBadge(BuildContext context, String role) {
    final colors = {
      'admin': Colors.purple,
      'writer': Colors.blue,
      'vip': Colors.orange,
      'viewer': Colors.grey,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colors[role]?.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors[role] ?? Colors.grey),
      ),
      child: Text(
        role.toUpperCase(),
        style: TextStyle(
          color: colors[role],
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  String _formatDate(String isoDate) {
    final date = DateTime.parse(isoDate);
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  void _viewDetails(BuildContext context, WidgetRef ref, AdminUser user) {
    ref.read(selectedUserProvider.notifier).state = user;
    // Show a bottom sheet or navigate to details page
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'User Details',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 24),
                _buildDetailRow('ID', user.userId),
                _buildDetailRow('Name', user.name),
                _buildDetailRow('Email', user.email),
                _buildDetailRow('Email Verified',
                    user.emailVerified ? 'Yes' : 'No'),
                if (user.phone != null)
                  _buildDetailRow('Phone', user.phone!),
                _buildDetailRow('Role', user.getPrimaryRole()),
                _buildDetailRow('Created', user.createdAt),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: SelectableText(value),
          ),
        ],
      ),
    );
  }

  void _editRoles(BuildContext context, WidgetRef ref, AdminUser user) {
    showDialog(
      context: context,
      builder: (context) => RoleEditorDialog(user: user),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, AdminUser user) {
    showDialog(
      context: context,
      builder: (context) => DeleteUserDialog(user: user),
    );
  }
}
