import '../../models/tag_model.dart';

abstract class ITagRepository {
  Future<List<Tag>> getTags();
  Future<Tag?> getTagByName(String tagName);
  Future<void> createTag(Tag tag);
  Future<void> deleteTag(String documentId); // Appwrite uses document ID for deletion
}
