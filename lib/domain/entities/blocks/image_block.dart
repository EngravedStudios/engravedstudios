import '../block_type.dart';
import '../post_block.dart';

/// Image block representing an embedded image with metadata
/// 
/// References the media table for actual image storage.
/// Includes blur hash for progressive loading and dimensions for layout stability.
class ImageBlock extends PostBlock {
  /// Reference to media table (if uploaded) or external URL
  final int? mediaId;
  
  /// Direct URL to the image (for external images or resolved from mediaId)
  final String url;
  
  /// Optional caption displayed below the image
  final String? caption;
  
  /// Image width in pixels (for aspect ratio calculation)
  final int? width;
  
  /// Image height in pixels (for aspect ratio calculation)
  final int? height;
  
  /// BlurHash string for progressive loading placeholder
  final String? blurHash;
  
  /// Alt text for accessibility
  final String? altText;

  const ImageBlock({
    required super.id,
    this.mediaId,
    required this.url,
    this.caption,
    this.width,
    this.height,
    this.blurHash,
    this.altText,
  }) : super(type: BlockType.image);

  /// Create an empty image block (used before upload)
  factory ImageBlock.empty(String id) {
    return ImageBlock(
      id: id,
      url: '',
    );
  }

  /// Create from JSON representation
  factory ImageBlock.fromJson(Map<String, dynamic> json) {
    return ImageBlock(
      id: json['id'] as String,
      mediaId: json['mediaId'] as int?,
      url: json['url'] as String,
      caption: json['caption'] as String?,
      width: json['width'] as int?,
      height: json['height'] as int?,
      blurHash: json['blurHash'] as String?,
      altText: json['altText'] as String?,
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
      'width': width,
      'height': height,
      'blurHash': blurHash,
      'altText': altText,
    };
  }

  @override
  ImageBlock copyWith({
    String? id,
    int? mediaId,
    String? url,
    String? caption,
    int? width,
    int? height,
    String? blurHash,
    String? altText,
  }) {
    return ImageBlock(
      id: id ?? this.id,
      mediaId: mediaId ?? this.mediaId,
      url: url ?? this.url,
      caption: caption ?? this.caption,
      width: width ?? this.width,
      height: height ?? this.height,
      blurHash: blurHash ?? this.blurHash,
      altText: altText ?? this.altText,
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
          other is ImageBlock &&
          mediaId == other.mediaId &&
          url == other.url &&
          caption == other.caption &&
          width == other.width &&
          height == other.height &&
          blurHash == other.blurHash &&
          altText == other.altText;

  @override
  int get hashCode =>
      super.hashCode ^
      mediaId.hashCode ^
      url.hashCode ^
      caption.hashCode ^
      width.hashCode ^
      height.hashCode ^
      blurHash.hashCode ^
      altText.hashCode;
}
