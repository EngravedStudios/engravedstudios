import 'package:engravedstudios/core/theme/design_system.dart';
import 'package:flutter/material.dart';

class TerminalInput extends StatefulWidget {
  final String label;
  final int maxLines;

  const TerminalInput({super.key, required this.label, this.maxLines = 1});

  @override
  State<TerminalInput> createState() => _TerminalInputState();
}

class _TerminalInputState extends State<TerminalInput> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          "${widget.label} >",
          style: GameHUDTextStyles.terminalText.copyWith(
            color: _isFocused ? GameHUDColors.neonLime : GameHUDColors.ghostGray,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        
        // Input Box
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: _isFocused ? GameHUDColors.inkBlack : Colors.transparent,
            border: Border(
              bottom: BorderSide(
                width: 3, 
                color: _isFocused ? GameHUDColors.neonLime : GameHUDColors.hardBlack,
              ),
            ),
            boxShadow: _isFocused ? [
               const BoxShadow(
                 color: GameHUDColors.hardBlack,
                 offset: Offset(4, 4),
                 blurRadius: 0,
               )
            ] : [],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: TextField(
            focusNode: _focusNode,
            maxLines: widget.maxLines,
            style: GameHUDTextStyles.terminalText.copyWith(color: GameHUDColors.paperWhite),
            cursorColor: GameHUDColors.neonLime,
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
      ],
    );
  }
}
