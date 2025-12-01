import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/user.dart';
import '../../providers/auth_provider.dart';
import '../../providers/blog_provider.dart';
import '../../providers/cheer_provider.dart';
import '../../providers/user_data_provider.dart';
import 'create_post_screen.dart';

import '../../widgets/reader/block_reader.dart';

class ArticleScreen extends ConsumerStatefulWidget {
  final String postId;

  const ArticleScreen({super.key, required this.postId});

  @override
  ConsumerState<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends ConsumerState<ArticleScreen> {
  bool _isBookmarked = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final postAsync = ref.watch(blogPostProvider(widget.postId));

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Noted - Engraved Studios',
          style: GoogleFonts.spaceMono(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
        actions: [
          // Edit Button (only if author)
          if (postAsync.valueOrNull != null) ...[
            Consumer(
              builder: (context, ref, child) {
                final user = ref.watch(authStateProvider).valueOrNull;
                final post = postAsync.value!;
                
                // Allow editing if:
                // 1. User is admin (can edit any post)
                // 2. User is the author (authorId matches user ID)
                final canEdit = user != null && (
                  user.role == UserRole.admin ||
                  (post.authorId.isNotEmpty && user.id == post.authorId)
                );
                
                if (canEdit) {
                  return IconButton(
                    icon: Icon(Icons.edit, color: colorScheme.onSurface),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreatePostScreen(postToEdit: post),
                        ),
                      );
                    },
                  );
                }
                
                return const SizedBox.shrink();
              },
            ),
            // Delete Button (only if author or admin)
            Consumer(
              builder: (context, ref, child) {
                final user = ref.watch(authStateProvider).valueOrNull;
                final post = postAsync.value!;
                
                // Same permission logic as edit
                final canDelete = user != null && (
                  user.role == UserRole.admin ||
                  (post.authorId.isNotEmpty && user.id == post.authorId)
                );
                
                if (canDelete) {
                  return IconButton(
                    icon: Icon(Icons.delete_outline, color: colorScheme.error),
                    onPressed: () async {
                      // Show confirmation dialog
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Delete Post'),
                          content: const Text('Are you sure you want to delete this post? This action cannot be undone.'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              style: TextButton.styleFrom(
                                foregroundColor: colorScheme.error,
                              ),
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      );

                      if (confirmed == true && context.mounted) {
                        try {
                          // Delete the post
                          await ref.read(blogRepositoryProvider).deleteBlogPost(post.id);
                          
                          // Invalidate the blog list to refresh
                          ref.invalidate(blogListProvider);
                          
                          if (context.mounted) {
                            // Show success message
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Post deleted successfully')),
                            );
                            // Navigate back to home
                            Navigator.pop(context);
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error deleting post: $e')),
                            );
                          }
                        }
                      }
                    },
                  );
                }
                
                return const SizedBox.shrink();
              },
            ),
            // Visibility Toggle Button (only if author or admin)
            Consumer(
              builder: (context, ref, child) {
                final user = ref.watch(authStateProvider).valueOrNull;
                final post = postAsync.value!;
                
                // Same permission logic as edit/delete
                final canToggleVisibility = user != null && (
                  user.role == UserRole.admin ||
                  (post.authorId.isNotEmpty && user.id == post.authorId)
                );
                
                if (canToggleVisibility) {
                  return IconButton(
                    icon: Icon(
                      post.isPublished ? Icons.visibility : Icons.visibility_off,
                      color: post.isPublished ? colorScheme.primary : colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                    tooltip: post.isPublished ? 'Published' : 'Draft',
                    onPressed: () async {
                      // Show confirmation dialog
                      final newStatus = !post.isPublished;
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(newStatus ? 'Publish Post' : 'Unpublish Post'),
                          content: Text(
                            newStatus
                                ? 'Make this post visible to everyone?'
                                : 'Hide this post from public view? Only you will be able to see it.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancel'),
                            ),
                            FilledButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: Text(newStatus ? 'Publish' : 'Unpublish'),
                            ),
                          ],
                        ),
                      );

                      if (confirmed == true && context.mounted) {
                        try {
                          // Update publish status
                          await ref.read(blogRepositoryProvider).updatePublishStatus(post.id, newStatus);
                          
                          // Invalidate providers to refresh
                          ref.invalidate(blogListProvider);
                          ref.invalidate(blogPostProvider(widget.postId));
                          
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(newStatus ? 'Post published!' : 'Post saved as draft'),
                              ),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error updating visibility: $e')),
                            );
                          }
                        }
                      }
                    },
                  );
                }
                
                return const SizedBox.shrink();
              },
            ),
          ],
          IconButton(
            icon: Icon(Icons.share_outlined, color: colorScheme.onSurface),
            onPressed: () {},
          ),
          // Bookmark Button
          Consumer(
            builder: (context, ref, child) {
              final user = ref.watch(authStateProvider).valueOrNull;
              final isSavedAsync = ref.watch(isPostSavedProvider(widget.postId));
              
              return IconButton(
                icon: isSavedAsync.when(
                  data: (isSaved) => Icon(
                    isSaved ? Icons.bookmark : Icons.bookmark_border,
                    color: isSaved ? colorScheme.primary : colorScheme.onSurface,
                  ),
                  loading: () => const SizedBox(
                    width: 24, 
                    height: 24, 
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  error: (_, __) => Icon(Icons.error, color: colorScheme.error),
                ),
                onPressed: () async {
                  if (user == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please log in to save posts!')),
                    );
                    return;
                  }

                  try {
                    final isSaved = await ref.read(isPostSavedProvider(widget.postId).future);
                    final repository = ref.read(userDataRepositoryProvider);
                    
                    if (isSaved) {
                      await repository.unsavePost(user.id, widget.postId);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Post removed from saved!')),
                      );
                    } else {
                      await repository.savePost(user.id, widget.postId);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Post saved!')),
                      );
                    }
                    
                    // Refresh the provider
                    ref.invalidate(savedPostIdsProvider);
                    ref.invalidate(isPostSavedProvider(widget.postId));
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
                    }
                  }
                },
              );
            },
          ),
          const SizedBox(width: 16),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: colorScheme.onSurface,
            height: 1.0,
          ),
        ),
      ),
      body: postAsync.when(
        data: (post) {
          // Watch cheer-related providers
          final cheerCountAsync = ref.watch(cheerCountProvider(post.postId));
          final hasUserCheeredAsync = ref.watch(hasUserCheeredProvider(post.postId));
          final user = ref.watch(authStateProvider).valueOrNull;
          final isLoggedIn = user != null;

          return SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Section
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          border: Border.all(color: colorScheme.onSurface),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                if (post.tags.isEmpty)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: colorScheme.onSurface,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      'Article',
                                      style: GoogleFonts.spaceMono(
                                        fontSize: 12,
                                        color: colorScheme.surface,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                else ...[
                                  ...post.tags.take(2).map((tag) => Padding(
                                        padding: const EdgeInsets.only(right: 8.0),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: colorScheme.onSurface,
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            tag,
                                            style: GoogleFonts.spaceMono(
                                              fontSize: 12,
                                              color: colorScheme.surface,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      )),
                                  if (post.tags.length > 2)
                                    Text(
                                      '+',
                                      style: GoogleFonts.spaceMono(
                                        fontSize: 14,
                                        color: colorScheme.onSurface,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                ],
                                const Spacer(),
                                Text(
                                  _formatDate(post.publishDate),
                                  style: GoogleFonts.spaceMono(
                                    fontSize: 12,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Text(
                              post.title,
                              style: GoogleFonts.merriweather(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              post.subtitle,
                              style: GoogleFonts.merriweather(
                                fontSize: 20,
                                color: colorScheme.onSurface.withValues(alpha: 0.8),
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 32),
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: colorScheme.onSurface,
                                  child: Text(
                                    post.authorName[0],
                                    style: GoogleFonts.spaceMono(
                                      color: colorScheme.surface,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      post.authorName,
                                      style: GoogleFonts.spaceMono(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: colorScheme.onSurface,
                                      ),
                                    ),
                                    Text(
                                      '${post.readTimeMinutes} min read',
                                      style: GoogleFonts.spaceMono(
                                        fontSize: 12,
                                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 48),
                      
                      // Content
                      BlockReader(contentJson: post.content),
                      
                      const SizedBox(height: 64),
                      const SizedBox(height: 48),

                      // All Tags
                      if (post.tags.isNotEmpty) ...[
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: post.tags.map((tag) => Chip(
                            label: Text(
                              tag,
                              style: GoogleFonts.spaceMono(
                                fontSize: 12,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            backgroundColor: colorScheme.surface,
                            shape: StadiumBorder(side: BorderSide(color: colorScheme.onSurface)),
                          )).toList(),
                        ),
                        const SizedBox(height: 32),
                      ],

                      Divider(color: colorScheme.onSurface),
                      const SizedBox(height: 32),
                      
                      // Footer / Cheers
                      cheerCountAsync.when(
                        data: (cheerCount) => hasUserCheeredAsync.when(
                          data: (hasCheered) => Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: isLoggedIn ? () async {
                                  try {
                                    final repository = ref.read(cheerRepositoryProvider);
                                    if (hasCheered) {
                                      await repository.removeCheer(post.postId, user.id);
                                    } else {
                                      await repository.addCheer(post.postId, user.id);
                                    }
                                    // Refresh providers
                                    ref.invalidate(cheerCountProvider(post.postId));
                                    ref.invalidate(hasUserCheeredProvider(post.postId));
                                  } catch (e) {
                                    if (mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Error: $e')),
                                      );
                                    }
                                  }
                                } : () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Please log in to cheer!')),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: hasCheered && isLoggedIn
                                          ? colorScheme.primary
                                          : colorScheme.onSurface,
                                    ),
                                    borderRadius: BorderRadius.circular(30),
                                    color: hasCheered && isLoggedIn
                                        ? colorScheme.primary.withValues(alpha: 0.1)
                                        : Colors.transparent,
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        hasCheered && isLoggedIn
                                            ? Icons.celebration
                                            : Icons.celebration_outlined,
                                        color: hasCheered && isLoggedIn
                                            ? colorScheme.primary
                                            : colorScheme.onSurface.withValues(alpha: isLoggedIn ? 1.0 : 0.5),
                                        size: 24,
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        '$cheerCount Cheers',
                                        style: GoogleFonts.spaceMono(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: hasCheered && isLoggedIn
                                              ? colorScheme.primary
                                              : colorScheme.onSurface.withValues(alpha: isLoggedIn ? 1.0 : 0.5),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          loading: () => const CircularProgressIndicator(),
                          error: (_, _) => const SizedBox(),
                        ),
                        loading: () => const CircularProgressIndicator(),
                        error: (_, _) => const SizedBox(),
                      ),
                      const SizedBox(height: 64),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
