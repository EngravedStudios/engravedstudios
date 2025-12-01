import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/entities/tag.dart';
import '../domain/repositories/tag_repository_interface.dart';
import '../repositories/implementations/tag_repository.dart';
import '../data/datasources/remote/appwrite_datasource.dart';
import '../core/logging/logger_provider.dart';


part 'tag_provider.g.dart';

@riverpod
ITagRepository tagRepository(Ref ref) {
  final datasource = ref.watch(appwriteDatasourceProvider);
  final logger = ref.watch(appLoggerProvider);
  return TagRepository(datasource, logger);
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
