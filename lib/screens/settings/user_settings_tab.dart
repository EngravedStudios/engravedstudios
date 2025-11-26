import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/auth_provider.dart';
import '../../models/user_model.dart';

class UserSettingsTab extends ConsumerStatefulWidget {
  const UserSettingsTab({super.key});

  @override
  ConsumerState<UserSettingsTab> createState() => _UserSettingsTabState();
}

class _UserSettingsTabState extends ConsumerState<UserSettingsTab> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  
  bool _isEditingName = false;
  bool _isEditingEmail = false;
  bool _isChangingPassword = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authStateProvider).valueOrNull;
    if (user != null) {
      _nameController.text = user.name;
      _emailController.text = user.email;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  Future<void> _updateName() async {
    setState(() => _isLoading = true);
    try {
      await ref.read(authRepositoryProvider).updateName(_nameController.text);
      ref.invalidate(authStateProvider); // Refresh user data
      setState(() => _isEditingName = false);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Name updated')));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _updateEmail() async {
    // Requires password confirmation usually
    if (_passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password required to change email')));
      return;
    }
    setState(() => _isLoading = true);
    try {
      await ref.read(authRepositoryProvider).updateEmail(email: _emailController.text, password: _passwordController.text);
      ref.invalidate(authStateProvider);
      setState(() => _isEditingEmail = false);
      _passwordController.clear();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Email updated')));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _updatePassword() async {
    if (_newPasswordController.text.isEmpty) return;
    setState(() => _isLoading = true);
    try {
      await ref.read(authRepositoryProvider).updatePassword(
        newPassword: _newPasswordController.text,
        oldPassword: _oldPasswordController.text.isNotEmpty ? _oldPasswordController.text : null,
      );
      setState(() => _isChangingPassword = false);
      _oldPasswordController.clear();
      _newPasswordController.clear();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password updated')));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _sendVerification() async {
    setState(() => _isLoading = true);
    try {
      // Replace with your actual verification page URL
      await ref.read(authRepositoryProvider).createVerification(url: 'http://localhost:57866/verify'); 
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Verification email sent')));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteAccount() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account?'),
        content: const Text('This action is irreversible. Are you sure?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isLoading = true);
      try {
        await ref.read(authRepositoryProvider).deleteAccount();
        // If successful, logout and redirect
        await ref.read(authStateProvider.notifier).logout();
        if (mounted) {
          Navigator.pop(context); // Close settings
          // Navigate to home or login
        }
      } catch (e) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final user = ref.watch(authStateProvider).valueOrNull;

    if (user == null) return const Center(child: Text('Please log in to manage settings'));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Profile Section
        _buildSectionHeader('Profile', colorScheme),
        const SizedBox(height: 16),
        _buildCard(
          colorScheme,
          children: [
            // Name
            ListTile(
              title: const Text('Name'),
              subtitle: _isEditingName
                  ? TextField(controller: _nameController, decoration: const InputDecoration(hintText: 'Enter name'))
                  : Text(user.name),
              trailing: IconButton(
                icon: Icon(_isEditingName ? Icons.check : Icons.edit),
                onPressed: _isLoading ? null : () {
                  if (_isEditingName) {
                    _updateName();
                  } else {
                    setState(() => _isEditingName = true);
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Security Section
        _buildSectionHeader('Security', colorScheme),
        const SizedBox(height: 16),
        _buildCard(
          colorScheme,
          children: [
            // Email
            ListTile(
              title: const Text('Email'),
              subtitle: _isEditingEmail
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(controller: _emailController, decoration: const InputDecoration(hintText: 'New Email')),
                        const SizedBox(height: 8),
                        TextField(controller: _passwordController, obscureText: true, decoration: const InputDecoration(hintText: 'Confirm Password')),
                      ],
                    )
                  : Text(user.email),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Verify Button
                  TextButton(
                    onPressed: _isLoading ? null : _sendVerification,
                    child: const Text('Verify'),
                  ),
                  IconButton(
                    icon: Icon(_isEditingEmail ? Icons.check : Icons.edit),
                    onPressed: _isLoading ? null : () {
                      if (_isEditingEmail) {
                        _updateEmail();
                      } else {
                        setState(() => _isEditingEmail = true);
                      }
                    },
                  ),
                ],
              ),
            ),
            const Divider(),
            // Password
            ExpansionTile(
              title: const Text('Change Password'),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _oldPasswordController,
                        obscureText: true,
                        decoration: const InputDecoration(labelText: 'Old Password'),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _newPasswordController,
                        obscureText: true,
                        decoration: const InputDecoration(labelText: 'New Password'),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _isLoading ? null : _updatePassword,
                        child: const Text('Update Password'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Danger Zone
        _buildSectionHeader('Danger Zone', colorScheme, isDanger: true),
        const SizedBox(height: 16),
        _buildCard(
          colorScheme,
          borderColor: colorScheme.error,
          children: [
            ListTile(
              title: Text('Delete Account', style: TextStyle(color: colorScheme.error)),
              subtitle: const Text('Permanently delete your account and all data.'),
              trailing: IconButton(
                icon: Icon(Icons.delete_forever, color: colorScheme.error),
                onPressed: _isLoading ? null : _deleteAccount,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, ColorScheme colorScheme, {bool isDanger = false}) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: isDanger ? colorScheme.error : colorScheme.primary,
        letterSpacing: 1.0,
      ),
    );
  }

  Widget _buildCard(ColorScheme colorScheme, {required List<Widget> children, Color? borderColor}) {
    return Card(
      elevation: 0,
      color: colorScheme.surfaceVariant.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: borderColor ?? colorScheme.outlineVariant),
      ),
      child: Column(children: children),
    );
  }
}
