import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewsletterRepository {
  Future<void> subscribe(String email) async {
    // Mock API call simulation
    await Future.delayed(const Duration(seconds: 1));
    
    // Basic validation simulation
    if (!email.contains('@')) {
       throw Exception('Invalid email address');
    }
    
    if (email.contains('error')) {
      throw Exception('Failed to subscribe. Please try again.');
    }
    
    // Success - in real app, POST to API here
  }
}

final newsletterRepositoryProvider = Provider<NewsletterRepository>((ref) {
  return NewsletterRepository();
});
