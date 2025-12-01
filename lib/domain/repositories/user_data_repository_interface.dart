import '../entities/user_data.dart';

abstract class IUserDataRepository {
  /// Get user data for a specific user.
  /// If data doesn't exist, it should return an empty/default UserData or create one.
  Future<UserData> getUserData(String userId);

  /// Save a post for the user.
  Future<void> savePost(String userId, String postId);

  /// Unsave a post for the user.
  Future<void> unsavePost(String userId, String postId);

  /// Get list of saved post IDs.
  Future<List<String>> getSavedPostIds(String userId);
}
