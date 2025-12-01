import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../domain/entities/blocks/video_block.dart';

class VideoBlockRenderer extends StatefulWidget {
  final VideoBlock block;
  final bool isEditable;
  final VoidCallback? onDelete;
  final Function(VideoBlock)? onUpdate;

  const VideoBlockRenderer({
    super.key,
    required this.block,
    this.isEditable = true,
    this.onDelete,
    this.onUpdate,
  });

  @override
  State<VideoBlockRenderer> createState() => _VideoBlockRendererState();
}

class _VideoBlockRendererState extends State<VideoBlockRenderer> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    if (widget.block.url.isNotEmpty) {
      _initializeVideo();
    }
  }

  @override
  void didUpdateWidget(VideoBlockRenderer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.block.url != oldWidget.block.url) {
      _controller?.dispose();
      _isInitialized = false;
      if (widget.block.url.isNotEmpty) {
        _initializeVideo();
      }
    }
  }

  Future<void> _initializeVideo() async {
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.block.url));
    try {
      await _controller!.initialize();
      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      debugPrint('Error initializing video: $e');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Widget videoWidget;
    if (widget.block.url.isEmpty) {
      videoWidget = Container(
        height: 200,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.video_library_outlined, size: 48, color: colorScheme.onSurfaceVariant),
              const SizedBox(height: 8),
              Text(
                'Add a video',
                style: GoogleFonts.spaceMono(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    } else if (!_isInitialized) {
      videoWidget = AspectRatio(
        aspectRatio: widget.block.aspectRatio ?? 16 / 9,
        child: Container(
          color: colorScheme.surfaceContainerHighest,
          child: const Center(child: CircularProgressIndicator()),
        ),
      );
    } else {
      videoWidget = AspectRatio(
        aspectRatio: _controller!.value.aspectRatio,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            VideoPlayer(_controller!),
            _VideoControls(controller: _controller!),
          ],
        ),
      );
    }

    return MouseRegion(
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: videoWidget,
              ),
              if (widget.block.caption != null || widget.isEditable) ...[
                const SizedBox(height: 8),
                TextFormField(
                  initialValue: widget.block.caption,
                  enabled: widget.isEditable,
                  decoration: InputDecoration(
                    hintText: 'Write a caption...',
                    hintStyle: GoogleFonts.spaceMono(
                      fontSize: 12,
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: GoogleFonts.spaceMono(
                    fontSize: 12,
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    if (widget.onUpdate != null) {
                      widget.onUpdate!(widget.block.copyWith(caption: value));
                    }
                  },
                ),
              ],
            ],
          ),
          if (widget.isEditable && widget.onDelete != null)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.surface.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: IconButton(
                  icon: const Icon(Icons.delete_outline, size: 20),
                  onPressed: widget.onDelete,
                  color: colorScheme.error,
                  tooltip: 'Remove video',
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _VideoControls extends StatefulWidget {
  final VideoPlayerController controller;

  const _VideoControls({required this.controller});

  @override
  State<_VideoControls> createState() => _VideoControlsState();
}

class _VideoControlsState extends State<_VideoControls> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withValues(alpha: 0.5),
          ],
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              widget.controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                widget.controller.value.isPlaying
                    ? widget.controller.pause()
                    : widget.controller.play();
              });
            },
          ),
          Expanded(
            child: VideoProgressIndicator(
              widget.controller,
              allowScrubbing: true,
              colors: const VideoProgressColors(
                playedColor: Colors.white,
                bufferedColor: Colors.white24,
                backgroundColor: Colors.white10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
