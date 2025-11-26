import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/tag_model.dart';
import '../repositories/interfaces/tag_repository_interface.dart';
import '../repositories/implementations/tag_repository.dart';
import '../providers/auth_provider.dart';

part 'tag_provider.g.dart';

@riverpod
ITagRepository tagRepository(TagRepositoryRef ref) {
  final appwriteService = ref.watch(appwriteServiceProvider);
  return TagRepository(appwriteService);
}

@riverpod
class TagList extends _$TagList {
  @override
  Future<List<Tag>> build() async {
    return ref.watch(tagRepositoryProvider).getTags();
  }

  Future<void> addTag(Tag tag) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(tagRepositoryProvider);
      final existingTag = await repository.getTagByName(tag.tagName);
      
      if (existingTag != null) {
        throw Exception('Tag with this name already exists');
      }

      await repository.createTag(tag);
      return repository.getTags();
    });
  }

  Future<void> deleteTag(String documentId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(tagRepositoryProvider).deleteTag(documentId);
      return ref.read(tagRepositoryProvider).getTags();
    });
  }
}
