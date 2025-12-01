import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/blog_post.dart';

import '../../providers/auth_provider.dart';
import '../../providers/blog_provider.dart';
import '../../providers/tag_provider.dart';

import '../../providers/editor/editor_state.dart';
import '../../widgets/editor/block_editor_view.dart';
import '../../domain/entities/blocks/text_block.dart';
import '../../domain/entities/blocks/image_block.dart';
import '../../domain/entities/blocks/video_block.dart';

class CreatePostScreen extends ConsumerStatefulWidget {
  final BlogPost? postToEdit;

  const CreatePostScreen({super.key, this.postToEdit});

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _subtitleController;
  final List<int> _selectedTags = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.postToEdit?.title ?? '');
    _subtitleController = TextEditingController(text: widget.postToEdit?.subtitle ?? '');
    
    // Initialize editor content
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.postToEdit != null) {
        ref.read(editorNotifierProvider.notifier).loadFromJson(widget.postToEdit!.content);
      } else {
        ref.read(editorNotifierProvider.notifier).clear();
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    super.dispose();
  }

  Future<void> _submitPost() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedTags.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one tag')),
      );
      return;
    }

    // Show publish dialog to ask about visibility
    final publishChoice = await showDialog<bool?>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Publish Post'),
        content: const Text('How would you like to publish this post?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Save as Draft'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Publish Publicly'),
          ),
        ],
      ),
    );

    // If user cancelled, don't proceed
    if (publishChoice == null) return;

    setState(() => _isLoading = true);

    try {
      final user = ref.read(authStateProvider).valueOrNull;
      if (user == null) throw Exception('User not logged in');

      // Get content from editor
      final contentJson = ref.read(editorNotifierProvider.notifier).toJsonString();
      
      // Calculate read time based on text blocks (200 words/min)
      final editorState = ref.read(editorNotifierProvider);
      final textContent = editorState.blocks
          .whereType<TextBlock>()
          .map((b) => b.content)
          .join(' ');
      final wordCount = textContent.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
      final textReadTime = (wordCount / 200).ceil();
      
      // Add 1 minute for each media block (image or video)
      final mediaCount = editorState.blocks.where((b) => 
          b is ImageBlock || b is VideoBlock
      ).length;
      
      // Base read time + 1 minute for page load/navigation
      final readTime = textReadTime + mediaCount + 1;
      final finalReadTime = readTime > 0 ? readTime : 1; // Minimum 1 minute

      if (widget.postToEdit != null) {
        // Update existing post
        final updatedPost = widget.postToEdit!.copyWith(
          title: _titleController.text,
          subtitle: _subtitleController.text,
          content: contentJson,
          readTimeMinutes: finalReadTime,
          isPublished: publishChoice, // Update visibility
        );

        await ref.read(blogRepositoryProvider).updateBlogPost(updatedPost);
        await ref.read(blogRepositoryProvider).updateTagsForPost(
          updatedPost.postId, 
          _selectedTags,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(publishChoice ? 'Post published successfully!' : 'Post saved as draft!'))
          );
        }
      } else {
        // Create new post
        final postId = DateTime.now().millisecondsSinceEpoch;
        final newPost = BlogPost(
          postId: postId, // Generate unique ID
          id: '', // Will be assigned by Appwrite
          title: _titleController.text,
          subtitle: _subtitleController.text,
          content: contentJson,
          authorName: user.name,
          authorId: user.id,
          authorAvatarUrl: '',
          publishDate: DateTime.now(),
          readTimeMinutes: finalReadTime,
          tags: [], // Tags handled separately via updateTagsForPost
          imageUrl: 'https://picsum.photos/800/400', // Placeholder
          isPublished: publishChoice, // Set based on user choice
        );

        await ref.read(blogRepositoryProvider).createBlogPost(newPost);
        
        // Add tags
        if (_selectedTags.isNotEmpty) {
          await ref.read(blogRepositoryProvider).updateTagsForPost(postId, _selectedTags);
        }
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(publishChoice ? 'Post published successfully!' : 'Post saved as draft!'))
          );
        }
      }
      
      // Refresh the list
      ref.invalidate(blogListProvider);
      // Also invalidate specific post provider if editing
      if (widget.postToEdit != null) {
         ref.invalidate(blogPostProvider(widget.postToEdit!.id));
      }
      
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving post: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final tagsAsync = ref.watch(tagListProvider);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        title: Text(
          widget.postToEdit != null ? 'Edit Post' : 'New Post',
          style: GoogleFonts.spaceMono(fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: FilledButton.icon(
              onPressed: _isLoading ? null : _submitPost,
              icon: _isLoading 
                  ? const SizedBox(
                      width: 16, 
                      height: 16, 
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)
                    )
                  : const Icon(Icons.save),
              label: Text(_isLoading ? 'Saving...' : 'Save'),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Main Editor Area
                  Expanded(
                    flex: 3,
                    child: Container(
                      color: colorScheme.surface,
                      child: Column(
                        children: [
                          // Title Input
                          Padding(
                            padding: const EdgeInsets.fromLTRB(32, 32, 32, 0),
                            child: TextFormField(
                              controller: _titleController,
                              style: GoogleFonts.merriweather(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                              ),
                              decoration: const InputDecoration(
                                hintText: 'Post Title',
                                border: InputBorder.none,
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a title';
                                }
                                return null;
                              },
                            ),
                          ),

                          // Subtitle Input
                          Padding(
                            padding: const EdgeInsets.fromLTRB(32, 0, 32, 16),
                            child: TextFormField(
                              controller: _subtitleController,
                              style: GoogleFonts.merriweather(
                                fontSize: 20,
                                color: colorScheme.onSurface.withValues(alpha: 0.7),
                                fontStyle: FontStyle.italic,
                              ),
                              decoration: const InputDecoration(
                                hintText: 'Add a subtitle...',
                                border: InputBorder.none,
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                          
                          // Block Editor
                          const Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 32),
                              child: BlockEditorView(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Sidebar (Tags & Settings)
                  Container(
                    width: 300,
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(color: colorScheme.outlineVariant),
                      ),
                      color: colorScheme.surfaceContainerLow,
                    ),
                    child: ListView(
                      padding: const EdgeInsets.all(24),
                      children: [
                        Text(
                          'Tags',
                          style: GoogleFonts.spaceMono(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 16),
                        tagsAsync.when(
                          data: (tags) => Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: tags.map((tag) {
                              final isSelected = _selectedTags.contains(tag.tagId);
                              
                              // If editing, check if this tag is in the post's tags
                              if (widget.postToEdit != null && 
                                  !_selectedTags.contains(tag.tagId) && 
                                  widget.postToEdit!.tags.contains(tag.tagName)) {
                                // Note: This logic is imperfect as it relies on build cycle
                                // Ideally we'd do this in initState but we need tag IDs
                              }

                              return FilterChip(
                                label: Text(tag.tagName),
                                selected: isSelected,
                                onSelected: (selected) {
                                  setState(() {
                                    if (selected) {
                                      _selectedTags.add(tag.tagId);
                                    } else {
                                      _selectedTags.remove(tag.tagId);
                                    }
                                  });
                                },
                              );
                            }).toList(),
                          ),
                          loading: () => const CircularProgressIndicator(),
                          error: (err, stack) => Text('Error loading tags: $err'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
