import 'package:appwrite/appwrite.dart';
import '../../core/config/app_config.dart';
import '../../data/datasources/remote/appwrite_datasource.dart';
import '../../domain/entities/user_data.dart';
import '../../domain/repositories/user_data_repository_interface.dart';

class UserDataRepository implements IUserDataRepository {
  final IAppwriteDatasource _datasource;

  UserDataRepository(this._datasource);

  @override
  Future<UserData> getUserData(String userId) async {
    try {
      final results = await _datasource.listDocuments(
        collectionId: AppConfig.collectionIdUserData,
        queries: [
          Query.equal('userId', userId),
        ],
      );

      if (results.documents.isNotEmpty) {
        return UserData.fromJson(results.documents.first.data);
      } else {
        // Create default user data if it doesn't exist
        final newUserData = UserData(
          userId: userId,
          savedPosts: [],
          favouriteTags: [],
        );
        
        await _datasource.createDocument(
          collectionId: AppConfig.collectionIdUserData,
          documentId: 'unique()',
          data: newUserData.toJson(),
        );
        
        return newUserData;
      }
    } catch (e) {
      print('Error getting user data: $e');
      // Return empty user data on error to avoid blocking UI
      return UserData(userId: userId, savedPosts: [], favouriteTags: []);
    }
  }

  @override
  Future<void> savePost(String userId, String postId) async {
    try {
      final userData = await getUserData(userId);
      if (!userData.savedPosts.contains(postId)) {
        final updatedPosts = [...userData.savedPosts, postId];
        await _updateUserData(userId, {'savedPosts': updatedPosts});
      }
    } catch (e) {
      print('Error saving post: $e');
      rethrow;
    }
  }

  @override
  Future<void> unsavePost(String userId, String postId) async {
    try {
      final userData = await getUserData(userId);
      if (userData.savedPosts.contains(postId)) {
        final updatedPosts = userData.savedPosts.where((id) => id != postId).toList();
        await _updateUserData(userId, {'savedPosts': updatedPosts});
      }
    } catch (e) {
      print('Error unsaving post: $e');
      rethrow;
    }
  }

  @override
  Future<List<String>> getSavedPostIds(String userId) async {
    final userData = await getUserData(userId);
    return userData.savedPosts;
  }

  Future<void> _updateUserData(String userId, Map<String, dynamic> data) async {
    final results = await _datasource.listDocuments(
      collectionId: AppConfig.collectionIdUserData,
      queries: [
        Query.equal('userId', userId),
      ],
    );

    if (results.documents.isNotEmpty) {
      final documentId = results.documents.first.data['\$id'];
      await _datasource.updateDocument(
        collectionId: AppConfig.collectionIdUserData,
        documentId: documentId,
        data: data,
      );
    }
  }
}
