import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/user.dart';
import '../../../providers/auth_provider.dart';
import '../../../features/admin/presentation/screens/admin_dashboard_screen.dart';

/// Widget that wraps admin-only screens to enforce admin access
class AdminGuard extends ConsumerWidget {
  final Widget child;

  const AdminGuard({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user == null) {
          // Not logged in
          return _buildUnauthorized(context, 'Please log in to access this page');
        }

        if (user.role != UserRole.admin) {
          // Not an admin
          return _buildUnauthorized(context, 'Admin access required');
        }

        // User is admin, show the child
        return child;
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => _buildUnauthorized(context, 'Authentication error: $error'),
    );
  }

  Widget _buildUnauthorized(BuildContext context, String message) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Unauthorized'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.lock_outline,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 24),
            Text(
              message,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Helper function to navigate to admin dashboard with guard
void navigateToAdminDashboard(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => const AdminGuard(
        child: AdminDashboardScreen(),
      ),
    ),
  );
}
