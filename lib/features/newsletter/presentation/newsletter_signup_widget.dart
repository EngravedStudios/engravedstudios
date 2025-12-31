import 'package:engravedstudios/core/theme/design_system.dart';
import 'package:engravedstudios/features/newsletter/data/newsletter_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewsletterSignupWidget extends ConsumerStatefulWidget {
  const NewsletterSignupWidget({super.key});

  @override
  ConsumerState<NewsletterSignupWidget> createState() => _NewsletterSignupWidgetState();
}

class _NewsletterSignupWidgetState extends ConsumerState<NewsletterSignupWidget> {
  final _emailController = TextEditingController();
  bool _isLoading = false;
  String? _message;
  bool _isError = false;

  Future<void> _subscribe() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) return;

    setState(() {
      _isLoading = true;
      _message = null;
      _isError = false;
    });

    try {
      await ref.read(newsletterRepositoryProvider).subscribe(email);
      if (mounted) {
        setState(() {
          _message = "Subscribed successfully!";
          _isError = false;
          _emailController.clear();
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _message = e.toString().replaceAll('Exception: ', '');
          _isError = true;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
          width: GameHUDLayout.borderWidth,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'STAY UPDATED',
            style: GameHUDTextStyles.titleLarge.copyWith(
              fontSize: 24,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Join our mailing list for exclusive updates and playtest invites.',
            style: GameHUDTextStyles.body.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _emailController,
                  style: GameHUDTextStyles.terminalText.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  decoration: InputDecoration(
                    hintText: 'ENTER EMAIL_ADDRESS',
                    hintStyle: GameHUDTextStyles.terminalText.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2,
                      ),
                    ),
                  ),
                  onSubmitted: (_) => _subscribe(),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 52, // Match TextField height approx
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _subscribe,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    shape: const RoundedRectangleBorder(),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                  ),
                  child: _isLoading 
                    ? SizedBox(
                        width: 20, 
                        height: 20, 
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      )
                    : Text(
                        'SUBMIT',
                        style: GameHUDTextStyles.buttonText,
                      ),
                ),
              ),
            ],
          ),
          if (_message != null) ...[
            const SizedBox(height: 12),
            Text(
              _message!,
              style: GameHUDTextStyles.codeText.copyWith(
                color: _isError 
                    ? Theme.of(context).colorScheme.error 
                    : Theme.of(context).colorScheme.primary, // Use primary or another success color
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
