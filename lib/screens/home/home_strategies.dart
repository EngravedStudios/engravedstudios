import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../responsive/responsive_layout_strategy.dart';
import '../../providers/blog_provider.dart';
import '../../models/blog_post.dart';
import '../settings/settings_screen.dart';
import '../blog/article_screen.dart';
import '../auth/login_screen.dart';
import '../../providers/auth_provider.dart';
import '../../models/user_model.dart';
import 'tag_sidebar.dart';
import '../blog/create_post_screen.dart';

// --- Shared Components (Extracted for reuse) ---

class _BlogPostCard extends StatefulWidget {
  final BlogPost post;
  final bool isCompact; // For mobile

  const _BlogPostCard({required this.post, this.isCompact = false});

  @override
  State<_BlogPostCard> createState() => _BlogPostCardState();
}

class _BlogPostCardState extends State<_BlogPostCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ArticleScreen(postId: widget.post.id),
            ),
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.all(widget.isCompact ? 16 : 24),
          decoration: BoxDecoration(
            border: Border.all(color: colorScheme.onSurface, width: 1.5),
            borderRadius: BorderRadius.circular(0),
            color: colorScheme.surface,
            boxShadow: _isHovered && !widget.isCompact
                ? [
                    BoxShadow(
                      color: colorScheme.onSurface,
                      offset: const Offset(8, 8),
                      blurRadius: 0,
                    )
                  ]
                : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: colorScheme.onSurface),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget.post.tags.isNotEmpty ? widget.post.tags.first : 'Article',
                      style: GoogleFonts.spaceMono(
                        fontSize: 10,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                  Text(
                    _formatDate(widget.post.publishDate),
                    style: GoogleFonts.spaceMono(
                      fontSize: 10,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: widget.isCompact ? 16 : 24),
                        Text(
                          widget.post.title,
                          style: GoogleFonts.merriweather(
                            fontSize: widget.isCompact ? 20 : 28,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          widget.post.subtitle,
                          style: GoogleFonts.merriweather(
                            fontSize: widget.isCompact ? 14 : 16,
                            color: colorScheme.onSurface.withOpacity(0.7),
                            height: 1.5,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: widget.isCompact ? 16 : 24),
                        Row(
                          children: [
                            Text(
                              'Read More',
                              style: GoogleFonts.spaceMono(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(Icons.arrow_forward, size: 14, color: colorScheme.onSurface),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (widget.post.imageUrl != null && !widget.isCompact) ...[
                    const SizedBox(width: 32),
                    SizedBox(
                      width: 160,
                      height: 160,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Stack(
                          children: [
                            Container(
                              margin: const EdgeInsets.all(10),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: colorScheme.surface,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: colorScheme.onSurface),
                                boxShadow: [
                                  BoxShadow(
                                    color: colorScheme.onSurface,
                                    offset: const Offset(4, 4),
                                    blurRadius: 0,
                                  )
                                ],
                              ),
                              child: SizedBox(
                                width: 120,
                                height: 120,
                                child: Image.network(
                                  widget.post.imageUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Center(
                                      child: Icon(Icons.image_not_supported, color: colorScheme.onSurface.withOpacity(0.5)),
                                    );
                                  },
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Transform.rotate(
                                angle: (15 * pi) / 180,
                                child: Container(
                                  height: 30,
                                  width: 30,
                                  color: colorScheme.primary.withOpacity(0.8),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

// --- Strategies ---

class MobileHomeStrategy implements ResponsiveLayoutStrategy {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final blogListAsync = ref.watch(filteredBlogListProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        title: Text(
          'Noted',
          style: GoogleFonts.merriweather(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: colorScheme.onSurface),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: colorScheme.surface,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: colorScheme.onSurface),
              child: Center(
                child: Text(
                  'Noted Menu',
                  style: GoogleFonts.merriweather(
                    color: colorScheme.surface,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home, color: colorScheme.onSurface),
              title: Text('Home', style: GoogleFonts.spaceMono(color: colorScheme.onSurface)),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.info, color: colorScheme.onSurface),
              title: Text('About', style: GoogleFonts.spaceMono(color: colorScheme.onSurface)),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.work, color: colorScheme.onSurface),
              title: Text('Career', style: GoogleFonts.spaceMono(color: colorScheme.onSurface)),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.code, color: colorScheme.onSurface),
              title: Text('Projects', style: GoogleFonts.spaceMono(color: colorScheme.onSurface)),
              onTap: () {},
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.settings, color: colorScheme.onSurface),
              title: Text('Settings', style: GoogleFonts.spaceMono(color: colorScheme.onSurface)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: Container(
        color: colorScheme.onSurface,
        child: Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: blogListAsync.when(
            data: (posts) => ListView.separated(
              padding: const EdgeInsets.all(16.0),
              itemCount: posts.length,
              separatorBuilder: (context, index) => const SizedBox(height: 24),
              itemBuilder: (context, index) {
                final post = posts[index];
                return _BlogPostCard(post: post, isCompact: true);
              },
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error: $err')),
          ),
        ),
      ),
    );
  }
}

class DesktopHomeStrategy implements ResponsiveLayoutStrategy {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final blogListAsync = ref.watch(filteredBlogListProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              floating: true,
              snap: true,
              backgroundColor: colorScheme.surface,
              surfaceTintColor: Colors.transparent,
              toolbarHeight: 80,
              titleSpacing: 0,
              title: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  children: [
                    Text(
                      'Noted',
                      style: GoogleFonts.merriweather(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(width: 48),
                    
                    // Custom Search Bar
                    SizedBox(
                      width: 400,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 32.0),
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(color: colorScheme.onSurface),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search...',
                              hintStyle: GoogleFonts.spaceMono(
                                color: colorScheme.onSurface.withOpacity(0.5),
                                fontSize: 14,
                              ),
                              prefixIcon: Icon(Icons.search, size: 18, color: colorScheme.onSurface),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(vertical: 10),
                              isDense: true,
                            ),
                            style: GoogleFonts.spaceMono(
                              color: colorScheme.onSurface,
                              fontSize: 14,
                            ),
                            cursorColor: colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ),
                    
                    // Filter Buttons
                    Row(
                      children: [
                        _buildFilterButton(context, 'For You', true),
                        const SizedBox(width: 12),
                        _buildFilterButton(context, 'Featured', false),
                      ],
                    ),
                    
                    const Spacer(),

                    // Write Button (Only for Writers)
                    Consumer(
                      builder: (context, ref, child) {
                        final authState = ref.watch(authStateProvider);
                        return authState.maybeWhen(
                          data: (user) {
                            if (user != null && user.role == UserRole.writer) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 24.0),
                                child: TextButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const CreatePostScreen(),
                                      ),
                                    );
                                  },
                                  icon: Icon(Icons.edit_note, color: colorScheme.onSurface),
                                  label: Text(
                                    'Write',
                                    style: GoogleFonts.spaceMono(
                                      color: colorScheme.onSurface,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                          orElse: () => const SizedBox.shrink(),
                        );
                      },
                    ),
                    
                    // Auth Button
                    Consumer(
                      builder: (context, ref, child) {
                        final authState = ref.watch(authStateProvider);
                        return authState.when(
                          data: (user) {
                            if (user == null) {
                              return TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                                  );
                                },
                                child: Text(
                                  'Login',
                                  style: GoogleFonts.spaceMono(
                                    color: colorScheme.onSurface,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            } else {
                              return Row(
                                children: [
                                  Text(
                                    user.name,
                                    style: GoogleFonts.spaceMono(
                                      color: colorScheme.onSurface,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    icon: Icon(Icons.logout, color: colorScheme.onSurface),
                                    onPressed: () {
                                      ref.read(authStateProvider.notifier).logout();
                                    },
                                  ),
                                ],
                              );
                            }
                          },
                          loading: () => const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          error: (_, __) => const Icon(Icons.error),
                        );
                      },
                    ),
                    const SizedBox(width: 16),
                    
                    IconButton(
                      icon: Icon(Icons.settings_outlined, color: colorScheme.onSurface),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SettingsScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: Container(
          color: colorScheme.onSurface,
          child: Container(
             decoration: BoxDecoration(
               color: colorScheme.surface,
               borderRadius: const BorderRadius.only(
                 bottomLeft: Radius.circular(40),
                 bottomRight: Radius.circular(40),
               ),
             ),
             child: Row(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 // Sidebar
                 const TagSidebar(),
                 
                 // Main Content
                 Expanded(
                   child: blogListAsync.when(
                    data: (posts) => ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
                      itemCount: posts.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 48),
                      itemBuilder: (context, index) {
                        final post = posts[index];
                        return Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 700),
                            child: _BlogPostCard(post: post),
                          ),
                        );
                      },
                    ),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (err, stack) => Center(child: Text('Error: $err')),
                  ),
                 ),
               ],
             ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterButton(BuildContext context, String text, bool isSelected) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isSelected ? colorScheme.onSurface : Colors.transparent,
        border: Border.all(color: colorScheme.onSurface),
        borderRadius: BorderRadius.circular(18),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: GoogleFonts.spaceMono(
          color: isSelected ? colorScheme.surface : colorScheme.onSurface,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }
}
