import '../block_type.dart';
import '../post_block.dart';

/// Code block representing a code snippet with syntax highlighting
/// 
/// Supports multiple programming languages and provides a copy-to-clipboard feature.
class CodeBlock extends PostBlock {
  /// The code content
  final String code;
  
  /// Programming language for syntax highlighting (e.g., 'dart', 'javascript', 'python')
  final String language;

  const CodeBlock({
    required super.id,
    required this.code,
    this.language = 'plaintext',
  }) : super(type: BlockType.code);

  /// Create an empty code block
  factory CodeBlock.empty(String id) {
    return CodeBlock(
      id: id,
      code: '',
      language: 'dart',
    );
  }

  /// Create from JSON representation
  factory CodeBlock.fromJson(Map<String, dynamic> json) {
    return CodeBlock(
      id: json['id'] as String,
      code: json['code'] as String? ?? '',
      language: json['language'] as String? ?? 'dart',
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toJson(),
      'code': code,
      'language': language,
    };
  }

  @override
  CodeBlock copyWith({
    String? id,
    String? code,
    String? language,
  }) {
    return CodeBlock(
      id: id ?? this.id,
      code: code ?? this.code,
      language: language ?? this.language,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is CodeBlock &&
          code == other.code &&
          language == other.language;

  @override
  int get hashCode =>
      super.hashCode ^
      code.hashCode ^
      language.hashCode;
}
