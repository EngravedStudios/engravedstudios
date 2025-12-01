import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Application configuration loaded from environment variables
class AppConfig {
  // Appwrite configuration
  static String get appwriteEndpoint => 
      dotenv.env['APPWRITE_ENDPOINT'] ?? 'https://fra.cloud.appwrite.io/v1';
  
  static String get appwriteProjectId => 
      dotenv.env['APPWRITE_PROJECT_ID'] ?? '';
  
  static String get databaseId => 
      dotenv.env['APPWRITE_DATABASE_ID'] ?? 'noted';
  
  static String get collectionIdBlogPosts => 
      dotenv.env['APPWRITE_COLLECTION_POSTS'] ?? 'noted_posts';
  
  static String get collectionIdTags => 
      dotenv.env['APPWRITE_COLLECTION_TAGS'] ?? 'noted_tags';
  
  static String get collectionIdPostTags => 
      dotenv.env['APPWRITE_COLLECTION_POST_TAGS'] ?? 'noted_post-tags';

  static String get collectionIdPostCheers =>
      dotenv.env['APPWRITE_COLLECTION_POST_CHEERS'] ?? 'noted_post-cheers';

  static String get collectionIdUserData =>
      dotenv.env['APPWRITE_COLLECTION_USER_DATA'] ?? 'noted_user-data';

  static String get collectionIdMedia => 
      dotenv.env['APPWRITE_COLLECTION_MEDIA'] ?? 'noted_media';

  static String get bucketIdMedia => 
      dotenv.env['APPWRITE_BUCKET_MEDIA'] ?? 'noted_media-storage';

  /// Initialize the configuration by loading the .env file
  static Future<void> initialize() async {
    await dotenv.load(fileName: ".env");
  }
}
