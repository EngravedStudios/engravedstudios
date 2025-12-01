import '../block_type.dart';
import '../post_block.dart';

/// Video block representing an embedded video with metadata
/// 
/// References the media table for actual video storage.
/// Includes thumbnail and dimensions for layout stability.
class VideoBlock extends PostBlock {
  /// Reference to media table (if uploaded) or external URL
  final int? mediaId;
  
  /// Direct URL to the video (for external videos or resolved from mediaId)
  final String url;
  
  /// Optional caption displayed below the video
  final String? caption;
  
  /// Thumbnail image URL for video preview
  final String? thumbnailUrl;
  
  /// Video width in pixels (for aspect ratio calculation)
  final int? width;
  
  /// Video height in pixels (for aspect ratio calculation)
  final int? height;
  
  /// Duration in seconds (optional metadata)
  final int? durationSeconds;

  const VideoBlock({
    required super.id,
    this.mediaId,
    required this.url,
    this.caption,
    this.thumbnailUrl,
    this.width,
    this.height,
    this.durationSeconds,
  }) : super(type: BlockType.video);

  /// Create an empty video block (used before upload)
  factory VideoBlock.empty(String id) {
    return VideoBlock(
      id: id,
      url: '',
    );
  }

  /// Create from JSON representation
  factory VideoBlock.fromJson(Map<String, dynamic> json) {
    return VideoBlock(
      id: json['id'] as String,
      mediaId: json['mediaId'] as int?,
      url: json['url'] as String,
      caption: json['caption'] as String?,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      width: json['width'] as int?,
      height: json['height'] as int?,
      durationSeconds: json['durationSeconds'] as int?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toJson(),
      'mediaId': mediaId,
      'url': url,
      'caption': caption,
      'thumbnailUrl': thumbnailUrl,
      'width': width,
      'height': height,
      'durationSeconds': durationSeconds,
    };
  }

  @override
  VideoBlock copyWith({
    String? id,
    int? mediaId,
    String? url,
    String? caption,
    String? thumbnailUrl,
    int? width,
    int? height,
    int? durationSeconds,
  }) {
    return VideoBlock(
      id: id ?? this.id,
      mediaId: mediaId ?? this.mediaId,
      url: url ?? this.url,
      caption: caption ?? this.caption,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      width: width ?? this.width,
      height: height ?? this.height,
      durationSeconds: durationSeconds ?? this.durationSeconds,
    );
  }

  /// Get aspect ratio for layout (returns null if dimensions unknown)
  double? get aspectRatio {
    if (width != null && height != null && height! > 0) {
      return width! / height!;
    }
    return null;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is VideoBlock &&
          mediaId == other.mediaId &&
          url == other.url &&
          caption == other.caption &&
          thumbnailUrl == other.thumbnailUrl &&
          width == other.width &&
          height == other.height &&
          durationSeconds == other.durationSeconds;

  @override
  int get hashCode =>
      super.hashCode ^
      mediaId.hashCode ^
      url.hashCode ^
      caption.hashCode ^
      thumbnailUrl.hashCode ^
      width.hashCode ^
      height.hashCode ^
      durationSeconds.hashCode;
}
