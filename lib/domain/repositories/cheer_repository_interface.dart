/// Repository interface for post cheer (like) operations
abstract class ICheerRepository {
  /// Check if a user has cheered a post
  Future<bool> hasUserCheered(int postId, String userId);

  /// Add a cheer from a user to a post
  Future<void> addCheer(int postId, String userId);

  /// Remove a cheer from a user to a post
  Future<void> removeCheer(int postId, String userId);

  /// Get total cheer count for a post
  Future<int> getCheerCount(int postId);
}
