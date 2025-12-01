import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/admin_user.dart';
import '../../domain/entities/admin_models.dart';
import '../providers/admin_providers.dart';

class RoleEditorDialog extends ConsumerStatefulWidget {
  final AdminUser user;

  const RoleEditorDialog({Key? key, required this.user}) : super(key: key);

  @override
  ConsumerState<RoleEditorDialog> createState() => _RoleEditorDialogState();
}

class _RoleEditorDialogState extends ConsumerState<RoleEditorDialog> {
  late Set<String> selectedTeams;

  final Map<String, String> roleTeamMap = {
    'admin': '692ca7080009958e8ca4',
    'writer': '692ca6f90025a66aa7ab',
    'vip': '692ca6e6003c8b692771',
    'viewer': '692ca6d1001b3450cceb',
  };

  @override
  void initState() {
    super.initState();
    selectedTeams = Set.from(widget.user.teams);
  }

  @override
  Widget build(BuildContext context) {
    final updateState = ref.watch(updateUserRolesActionProvider);

    return AlertDialog(
      title: Text('Edit Roles for ${widget.user.name}'),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select roles for this user:',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ...roleTeamMap.entries.map((entry) {
              final role = entry.key;
              final teamId = entry.value;
              final isSelected = selectedTeams.contains(teamId);

              return CheckboxListTile(
                title: Text(role.toUpperCase()),
                value: isSelected,
                onChanged: (value) {
                  setState(() {
                    if (value == true) {
                      selectedTeams.add(teamId);
                    } else {
                      selectedTeams.remove(teamId);
                    }
                  });
                },
              );
            }).toList(),
            if (updateState.isLoading)
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: LinearProgressIndicator(),
              ),
            if (updateState.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  'Error: ${updateState.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: updateState.isLoading
              ? null
              : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: updateState.isLoading ? null : _saveRoles,
          child: const Text('Save'),
        ),
      ],
    );
  }

  void _saveRoles() async {
    final currentTeams = Set<String>.from(widget.user.teams);
    final addTeams = selectedTeams.difference(currentTeams).toList();
    final removeTeams = currentTeams.difference(selectedTeams).toList();

    if (addTeams.isEmpty && removeTeams.isEmpty) {
      Navigator.of(context).pop();
      return;
    }

    await ref.read(updateUserRolesActionProvider.notifier).updateRoles(
          UpdateUserRolesParams(
            userId: widget.user.userId,
            addTeams: addTeams,
            removeTeams: removeTeams,
          ),
        );

    final state = ref.read(updateUserRolesActionProvider);
    if (!state.hasError && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User roles updated successfully')),
      );
      Navigator.of(context).pop();
    }
  }
}
