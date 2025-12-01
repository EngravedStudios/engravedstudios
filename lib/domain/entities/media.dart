/// Media entity representing uploaded files (images, videos, GIFs)
/// 
/// Maps to the `media` table in the database.
class Media {
  /// Unique media identifier
  final int mediaId;
  
  /// URL to the uploaded file
  final String fileUrl;
  
  /// Type of media (image, video, gif)
  final MediaType mediaType;
  
  /// Display title for the media
  final String mediaTitle;
  
  /// Image/video width in pixels (optional)
  final int? width;
  
  /// Image/video height in pixels (optional)
  final int? height;
  
  /// BlurHash for progressive image loading (optional)
  final String? blurHash;
  
  /// File size in bytes (optional)
  final int? fileSizeBytes;
  
  /// Upload timestamp
  final DateTime? uploadedAt;

  const Media({
    required this.mediaId,
    required this.fileUrl,
    required this.mediaType,
    required this.mediaTitle,
    this.width,
    this.height,
    this.blurHash,
    this.fileSizeBytes,
    this.uploadedAt,
  });

  /// Create from JSON representation (from database)
  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      mediaId: json['mediaId'] as int,
      fileUrl: json['fileUrl'] as String,
      mediaType: MediaType.fromJson(json['mediaType'] as String),
      mediaTitle: json['mediaTitle'] as String,
      width: json['width'] as int?,
      height: json['height'] as int?,
      blurHash: json['blurHash'] as String?,
      fileSizeBytes: json['fileSizeBytes'] as int?,
      uploadedAt: json['uploadedAt'] != null 
          ? DateTime.parse(json['uploadedAt'] as String)
          : null,
    );
  }

  /// Convert to JSON for database storage (only required fields)
  Map<String, dynamic> toJson() {
    return {
      'mediaId': mediaId,
      'fileUrl': fileUrl,
      'mediaType': mediaType.toJson(),
      'mediaTitle': mediaTitle,
    };
  }

  /// Convert to JSON with all fields (for local use)
  Map<String, dynamic> toJsonComplete() {
    return {
      'mediaId': mediaId,
      'fileUrl': fileUrl,
      'mediaType': mediaType.toJson(),
      'mediaTitle': mediaTitle,
      'width': width,
      'height': height,
      'blurHash': blurHash,
      'fileSizeBytes': fileSizeBytes,
      'uploadedAt': uploadedAt?.toIso8601String(),
    };
  }

  /// Get aspect ratio (returns null if dimensions unknown)
  double? get aspectRatio {
    if (width != null && height != null && height! > 0) {
      return width! / height!;
    }
    return null;
  }

  Media copyWith({
    int? mediaId,
    String? fileUrl,
    MediaType? mediaType,
    String? mediaTitle,
    int? width,
    int? height,
    String? blurHash,
    int? fileSizeBytes,
    DateTime? uploadedAt,
  }) {
    return Media(
      mediaId: mediaId ?? this.mediaId,
      fileUrl: fileUrl ?? this.fileUrl,
      mediaType: mediaType ?? this.mediaType,
      mediaTitle: mediaTitle ?? this.mediaTitle,
      width: width ?? this.width,
      height: height ?? this.height,
      blurHash: blurHash ?? this.blurHash,
      fileSizeBytes: fileSizeBytes ?? this.fileSizeBytes,
      uploadedAt: uploadedAt ?? this.uploadedAt,
    );
  }
}

/// Media type enum matching database schema
enum MediaType {
  image,
  video,
  gif;

  String toJson() => name;

  static MediaType fromJson(String value) {
    return MediaType.values.firstWhere(
      (type) => type.name == value,
      orElse: () => MediaType.image,
    );
  }
}
