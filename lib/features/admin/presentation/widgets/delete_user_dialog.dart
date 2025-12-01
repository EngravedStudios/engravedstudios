import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/admin_user.dart';
import '../providers/admin_providers.dart';

class DeleteUserDialog extends ConsumerWidget {
  final AdminUser user;

  const DeleteUserDialog({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deleteState = ref.watch(deleteUserActionProvider);

    return AlertDialog(
      title: const Text('Delete User'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Are you sure you want to delete this user?',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text('Name: ${user.name}'),
          Text('Email: ${user.email}'),
          const SizedBox(height: 16),
          const Text(
            'This action cannot be undone!',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
          if (deleteState.isLoading)
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: LinearProgressIndicator(),
            ),
          if (deleteState.hasError)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                'Error: ${deleteState.error}',
                style: const TextStyle(color: Colors.red),
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed:
              deleteState.isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: deleteState.isLoading
              ? null
              : () => _confirmDelete(context, ref),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          child: const Text('Delete'),
        ),
      ],
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) async {
    await ref.read(deleteUserActionProvider.notifier).deleteUser(user.userId);

    final state = ref.read(deleteUserActionProvider);
    if (!state.hasError && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User ${user.name} deleted successfully')),
      );
      Navigator.of(context).pop();
    }
  }
}
