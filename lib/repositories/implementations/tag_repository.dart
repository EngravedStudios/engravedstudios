import 'package:appwrite/appwrite.dart';

import '../../core/config/app_config.dart';
import '../../core/logging/app_logger.dart';
import '../../domain/entities/tag.dart';
import '../../data/datasources/remote/appwrite_datasource.dart';
import '../../domain/repositories/tag_repository_interface.dart';

class TagRepository implements ITagRepository {
  final IAppwriteDatasource _datasource;
  final AppLogger _logger;

  TagRepository(this._datasource, this._logger);

  @override
  Future<List<Tag>> getTags() async {
    try {
      final result = await _datasource.listDocuments(
        collectionId: AppConfig.collectionIdTags,
        queries: [
          Query.orderAsc('tagName'),
        ],
      );

      return result.documents.map((doc) => Tag.fromMap(doc.data)).toList();
    } catch (e, stackTrace) {
      _logger.error('Failed to fetch tags', e, stackTrace);
      return [];
    }
  }

  @override
  Future<Tag?> getTagByName(String tagName) async {
    try {
      final result = await _datasource.listDocuments(
        collectionId: AppConfig.collectionIdTags,
        queries: [
          Query.equal('tagName', tagName),
        ],
      );

      if (result.documents.isNotEmpty) {
        return Tag.fromMap(result.documents.first.data);
      }
      return null;
    } catch (e, stackTrace) {
      _logger.error('Failed to fetch tag by name', e, stackTrace);
      return null;
    }
  }

  @override
  Future<void> createTag(Tag tag) async {
    try {
      await _datasource.createDocument(
        collectionId: AppConfig.collectionIdTags,
        documentId: ID.unique(),
        data: tag.toMap(),
      );
    } catch (e, stackTrace) {
      _logger.error('Failed to create tag', e, stackTrace);
      throw Exception('Error creating tag: $e');
    }
  }

  @override
  Future<void> deleteTag(String documentId) async {
    try {
      await _datasource.deleteDocument(
        collectionId: AppConfig.collectionIdTags,
        documentId: documentId,
      );
    } catch (e, stackTrace) {
      _logger.error('Failed to delete tag', e, stackTrace);
      throw Exception('Error deleting tag: $e');
    }
  }
}
