import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../domain/entities/blocks/code_block.dart';

class CodeBlockRenderer extends StatelessWidget {
  final CodeBlock block;
  final bool isEditable;
  final VoidCallback? onDelete;
  final Function(CodeBlock)? onUpdate;

  const CodeBlockRenderer({
    super.key,
    required this.block,
    this.isEditable = false,
    this.onDelete,
    this.onUpdate,
  });

  // Common programming languages
  static const List<String> languages = [
    'dart',
    'javascript',
    'typescript',
    'python',
    'java',
    'cpp',
    'c',
    'csharp',
    'go',
    'rust',
    'ruby',
    'php',
    'swift',
    'kotlin',
    'sql',
    'html',
    'css',
    'json',
    'yaml',
    'bash',
    'plaintext',
  ];

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: block.code));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Code copied to clipboard!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Custom theme based on app colors (light)
  Map<String, TextStyle> _buildLightTheme(ColorScheme colorScheme) {
    return {
      'root': TextStyle(backgroundColor: Colors.transparent, color: colorScheme.onSurface),
      'keyword': TextStyle(color: const Color(0xFF0000FF)),
      'built_in': TextStyle(color: const Color(0xFF0000FF)),
      'type': TextStyle(color: const Color(0xFF2B91AF)),
      'literal': TextStyle(color: const Color(0xFF098658)),
      'number': TextStyle(color: const Color(0xFF098658)),
      'string': TextStyle(color: const Color(0xFFA31515)),
      'comment': TextStyle(color: const Color(0xFF008000), fontStyle: FontStyle.italic),
      'function': TextStyle(color: const Color(0xFF795E26)),
      'title': TextStyle(color: const Color(0xFF795E26)),
      'params': TextStyle(color: colorScheme.onSurface),
      'meta': TextStyle(color: const Color(0xFF808080)),
    };
  }

  // Custom theme based on app colors (dark)
  Map<String, TextStyle> _buildDarkTheme(ColorScheme colorScheme) {
    return {
      'root': TextStyle(backgroundColor: Colors.transparent, color: colorScheme.onSurface),
      'keyword': TextStyle(color: const Color(0xFF569CD6)),
      'built_in': TextStyle(color: const Color(0xFF569CD6)),
      'type': TextStyle(color: const Color(0xFF4EC9B0)),
      'literal': TextStyle(color: const Color(0xFFB5CEA8)),
      'number': TextStyle(color: const Color(0xFFB5CEA8)),
      'string': TextStyle(color: const Color(0xFFCE9178)),
      'comment': TextStyle(color: const Color(0xFF6A9955), fontStyle: FontStyle.italic),
      'function': TextStyle(color: const Color(0xFFDCDCAA)),
      'title': TextStyle(color: const Color(0xFFDCDCAA)),
      'params': TextStyle(color: colorScheme.onSurface),
      'meta': TextStyle(color: const Color(0xFF9CDCFE)),
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Language selector (only in editable mode)
          if (isEditable)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Text(
                    'Language:',
                    style: GoogleFonts.spaceMono(
                      fontSize: 12,
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(width: 8),
                  DropdownButton<String>(
                    value: languages.contains(block.language) 
                        ? block.language 
                        : 'plaintext',
                    items: languages.map((lang) {
                      return DropdownMenuItem(
                        value: lang,
                        child: Text(
                          lang,
                          style: GoogleFonts.spaceMono(fontSize: 12),
                        ),
                      );
                    }).toList(),
                    onChanged: onUpdate != null
                        ? (value) {
                            if (value != null) {
                              onUpdate!(block.copyWith(language: value));
                            }
                          }
                        : null,
                    underline: Container(),
                    icon: const Icon(Icons.arrow_drop_down, size: 16),
                  ),
                  const Spacer(),
                  if (onDelete != null)
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 18),
                      onPressed: onDelete,
                      tooltip: 'Delete code block',
                    ),
                ],
              ),
            ),

          // Code container
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  // Always darker than surface - use black overlay
                  color: Color.lerp(
                    colorScheme.surface,
                    Colors.black,
                    isDark ? 0.2 : 0.08,
                  ),
                  border: Border.all(
                    color: colorScheme.outline.withValues(alpha: 0.3),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(7), // Slightly smaller to account for border
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Code editor/viewer
                      if (isEditable)
                        TextField(
                          controller: TextEditingController(text: block.code)
                            ..selection = TextSelection.fromPosition(
                              TextPosition(offset: block.code.length),
                            ),
                          onChanged: (value) {
                            if (onUpdate != null) {
                              onUpdate!(block.copyWith(code: value));
                            }
                          },
                          maxLines: null,
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 14,
                            color: colorScheme.onSurface,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Enter code here...',
                            hintStyle: GoogleFonts.jetBrainsMono(
                              fontSize: 14,
                              color: colorScheme.onSurface.withValues(alpha: 0.3),
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(16),
                            filled: false,
                          ),
                        )
                      else
                        // Syntax highlighted code display
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            child: HighlightView(
                              block.code.isNotEmpty ? block.code : '// Empty code block',
                              language: block.language,
                              theme: isDark 
                                  ? _buildDarkTheme(colorScheme)
                                  : _buildLightTheme(colorScheme),
                              textStyle: GoogleFonts.jetBrainsMono(
                                fontSize: 14,
                              ),
                              padding: EdgeInsets.zero, // Remove default padding
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // Copy button (always visible, top-right)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surface.withValues(alpha: 0.95),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: colorScheme.outline.withValues(alpha: 0.3),
                    ),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.copy, size: 16),
                    onPressed: () => _copyToClipboard(context),
                    tooltip: 'Copy code',
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
