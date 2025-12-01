import 'package:appwrite/appwrite.dart';
import '../../core/config/app_config.dart';
import '../../data/datasources/remote/appwrite_datasource.dart';
import '../../domain/repositories/cheer_repository_interface.dart';

class CheerRepository implements ICheerRepository {
  final IAppwriteDatasource _datasource;

  CheerRepository(this._datasource);

  @override
  Future<bool> hasUserCheered(int postId, String userId) async {
    try {
      final results = await _datasource.listDocuments(
        collectionId: AppConfig.collectionIdPostCheers,
        queries: [
          Query.equal('postId', postId),
          Query.equal('userId', userId),
        ],
      );
      return results.documents.isNotEmpty;
    } catch (e) {
      print('Error checking if user cheered: $e');
      return false;
    }
  }

  @override
  Future<void> addCheer(int postId, String userId) async {
    try {
      await _datasource.createDocument(
        collectionId: AppConfig.collectionIdPostCheers,
        documentId: 'unique()',
        data: {
          'postId': postId,
          'userId': userId,
        },
      );
    } catch (e) {
      print('Error adding cheer: $e');
      rethrow;
    }
  }

  @override
  Future<void> removeCheer(int postId, String userId) async {
    try {
      // Find the cheer document
      final results = await _datasource.listDocuments(
        collectionId: AppConfig.collectionIdPostCheers,
        queries: [
          Query.equal('postId', postId),
          Query.equal('userId', userId),
        ],
      );

      if (results.documents.isNotEmpty) {
        final documentId = results.documents.first.data['\$id'];
        await _datasource.deleteDocument(
          collectionId: AppConfig.collectionIdPostCheers,
          documentId: documentId,
        );
      }
    } catch (e) {
      print('Error removing cheer: $e');
      rethrow;
    }
  }

  @override
  Future<int> getCheerCount(int postId) async {
    try {
      final results = await _datasource.listDocuments(
        collectionId: AppConfig.collectionIdPostCheers,
        queries: [
          Query.equal('postId', postId),
        ],
      );
      return results.total;
    } catch (e) {
      print('Error getting cheer count: $e');
      return 0;
    }
  }
}
