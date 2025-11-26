import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import '../../constants/appwrite_constants.dart';
import '../../models/tag_model.dart';
import '../../services/appwrite_service.dart';
import '../interfaces/tag_repository_interface.dart';

class TagRepository implements ITagRepository {
  final AppwriteService _appwriteService;

  TagRepository(this._appwriteService);

  @override
  Future<List<Tag>> getTags() async {
    try {
      final databases = _appwriteService.databases;
      if (databases == null) return [];

      final result = await databases.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.collectionIdTags,
        queries: [
          Query.orderAsc('tagName'),
        ],
      );

      return result.documents.map((doc) => Tag.fromMap(doc.data)).toList();
    } catch (e) {
      print('Error fetching tags: $e');
      print('Error fetching tags: $e');
      return [];
    }
  }

  @override
  Future<Tag?> getTagByName(String tagName) async {
    try {
      final databases = _appwriteService.databases;
      if (databases == null) return null;

      final result = await databases.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.collectionIdTags,
        queries: [
          Query.equal('tagName', tagName),
        ],
      );

      if (result.documents.isNotEmpty) {
        return Tag.fromMap(result.documents.first.data);
      }
      return null;
    } catch (e) {
      print('Error fetching tag by name: $e');
      return null;
    }
  }

  @override
  Future<void> createTag(Tag tag) async {
    try {
      final databases = _appwriteService.databases;
      if (databases == null) throw Exception('Database not initialized');

      await databases.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.collectionIdTags,
        documentId: ID.unique(),
        data: tag.toMap(),
      );
    } catch (e) {
      print('Error creating tag: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteTag(String documentId) async {
    try {
      final databases = _appwriteService.databases;
      if (databases == null) throw Exception('Database not initialized');

      await databases.deleteDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.collectionIdTags,
        documentId: documentId,
      );
    } catch (e) {
      print('Error deleting tag: $e');
      rethrow;
    }
  }
}
