import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'contact_provider.g.dart';

enum ContactStatus { idle, sending, success, error }

class ContactState {
  final ContactStatus status;
  final double progress; // 0.0 to 1.0

  const ContactState({this.status = ContactStatus.idle, this.progress = 0.0});
}

@riverpod
class ContactNotifier extends _$ContactNotifier {
  @override
  ContactState build() => const ContactState();

  Future<void> submitForm() async {
    state = const ContactState(status: ContactStatus.sending, progress: 0.1);

    // Simulate upload chunks
    for (int i = 1; i <= 10; i++) {
        await Future.delayed(const Duration(milliseconds: 200));
        if (state.status != ContactStatus.sending) return; // Cancelled?
        state = ContactState(status: ContactStatus.sending, progress: i / 10);
    }

    state = const ContactState(status: ContactStatus.success, progress: 1.0);
    
    // Reset after a few seconds? Or leave strict success?
    // User requirement: "Handshake Confirmed message".
  }
}
