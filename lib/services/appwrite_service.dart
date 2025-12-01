import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/config/app_config.dart';

/// Service for managing Appwrite client and services
class AppwriteService {
  final Client client;
  final Account account;
  final Databases databases;
  final Storage storage;

  AppwriteService._({
    required this.client,
    required this.account,
    required this.databases,
    required this.storage,
  });

  /// Factory constructor to initialize Appwrite services
  factory AppwriteService.initialize() {
    final client = Client()
        .setEndpoint(AppConfig.appwriteEndpoint)
        .setProject(AppConfig.appwriteProjectId);
    
    return AppwriteService._(
      client: client,
      account: Account(client),
      databases: Databases(client),
      storage: Storage(client),
    );
  }
}

final appwriteServiceProvider = Provider<AppwriteService>((ref) {
  return AppwriteService.initialize();
});
