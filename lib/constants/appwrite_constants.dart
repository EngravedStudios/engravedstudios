import '../core/config/app_config.dart';

/// @deprecated Use AppConfig instead
/// Maintained for backwards compatibility during refactoring
class AppwriteConstants {
  static String get endpoint => AppConfig.appwriteEndpoint;
  static String get projectId => AppConfig.appwriteProjectId;
  static String get databaseId => AppConfig.databaseId;
  static String get collectionIdBlogPosts => AppConfig.collectionIdBlogPosts;
  static String get collectionIdTags => AppConfig.collectionIdTags;
  static String get collectionIdPostTags => AppConfig.collectionIdPostTags;
}