import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/user_search_bar.dart';
import '../widgets/users_data_table.dart';
import '../providers/admin_providers.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(filteredUsersProvider);
    final searchQuery = ref.watch(userSearchQueryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(adminUsersProvider),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'User Management',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Manage user roles, permissions, and accounts',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 24),

            // Search bar
            const UserSearchBar(),
            const SizedBox(height: 16),

            // Stats row
            usersAsync.when(
              data: (users) => Row(
                children: [
                  _buildStatCard(
                    context,
                    'Total Users',
                    users.length.toString(),
                    Icons.people,
                    Colors.blue,
                  ),
                  const SizedBox(width: 16),
                  _buildStatCard(
                    context,
                    'Admins',
                    users
                        .where((u) => u.getPrimaryRole() == 'admin')
                        .length
                        .toString(),
                    Icons.admin_panel_settings,
                    Colors.purple,
                  ),
                  const SizedBox(width: 16),
                  _buildStatCard(
                    context,
                    'Writers',
                    users
                        .where((u) => u.getPrimaryRole() == 'writer')
                        .length
                        .toString(),
                    Icons.edit,
                    Colors.green,
                  ),
                ],
              ),
              loading: () => const SizedBox(),
              error: (_, __) => const SizedBox(),
            ),
            const SizedBox(height: 24),

            // Results info
            if (searchQuery.isNotEmpty)
              usersAsync.when(
                data: (users) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    'Found ${users.length} result(s) for "$searchQuery"',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                loading: () => const SizedBox(),
                error: (_, __) => const SizedBox(),
              ),

            // Users table
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: const UsersDataTable(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
