import 'package:engravedstudios/core/theme/design_system.dart';
import 'package:engravedstudios/core/utils/hoverable_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class NeubrutalistSquare extends ConsumerStatefulWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final String? url;
  final bool isMail;

  const NeubrutalistSquare({
    super.key, 
    required this.icon, 
    this.onTap,
    this.url,
    this.isMail = false,
  });

  @override
  ConsumerState<NeubrutalistSquare> createState() => _NeubrutalistSquareState();
}

class _NeubrutalistSquareState extends ConsumerState<NeubrutalistSquare> with HoverableMixin {
  
  Future<void> _handleTap() async {
    if (widget.onTap != null) {
      widget.onTap!();
      return;
    }

    if (widget.url != null) {
      final uri = Uri.parse(widget.url!);
      if (widget.isMail) {
        // Copy to clipboard or launch mailto
        // For now, let's try launch, if fail, copy? 
        // Or just copy for "COMM_CHANNEL"? 
        // Convention: usually launch mailto.
        if (await canLaunchUrl(uri)) {
           await launchUrl(uri);
        } else {
           // Fallback or just copy
           await Clipboard.setData(ClipboardData(text: widget.url!.replaceAll("mailto:", "")));
           // Show snackbar? context is available.
           if (mounted) {
             ScaffoldMessenger.of(context).showSnackBar(
               const SnackBar(content: Text("EMAIL COPIED TO CLIPBOARD")),
             );
           }
        }
      } else {
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: onEnter,
      onExit: onExit,
      cursor: SystemMouseCursors.none,
      child: GestureDetector(
        onTap: _handleTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 48,
          height: 48,
          transform: Matrix4.translationValues(
              isHovered ? -4 : 0, 
              isHovered ? -4 : 0, 
              0
          ),
          decoration: BoxDecoration(
            color: GameHUDColors.paperWhite,
            border: Border.all(width: 3, color: GameHUDColors.hardBlack),
            boxShadow: [
              BoxShadow(
                color: GameHUDColors.hardBlack,
                offset: isHovered ? const Offset(6, 6) : const Offset(0, 0), // Pop on hover
                blurRadius: 0,
              )
            ]
          ),
          child: Icon(widget.icon, color: GameHUDColors.hardBlack),
        ),
      ),
    );
  }
}
