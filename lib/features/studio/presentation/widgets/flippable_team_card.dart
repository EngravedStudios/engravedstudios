import 'dart:math';
import 'package:engravedstudios/core/theme/design_system.dart';
import 'package:engravedstudios/features/studio/domain/team_model.dart';
import 'package:flutter/material.dart';

class FlippableTeamCard extends StatefulWidget {
  final TeamMember member;
  const FlippableTeamCard({super.key, required this.member});

  @override
  State<FlippableTeamCard> createState() => _FlippableTeamCardState();
}

class _FlippableTeamCardState extends State<FlippableTeamCard> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _showBack = false;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flip() {
    if (_showBack) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    _showBack = !_showBack;
  }

  void _onEnter(PointerEvent event) {
    setState(() => _isHovered = true);
  }

  void _onExit(PointerEvent event) {
    if (!mounted) return;
    setState(() => _isHovered = false);
  }

  @override
  Widget build(BuildContext context) {    
    return MouseRegion(
      onEnter: _onEnter,
      onExit: _onExit,
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _flip,
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            final angle = _animation.value * pi;
            final isBack = angle > pi / 2;
            
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001) // Perspective
                ..rotateY(angle),
              child: isBack
                  ? Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()..rotateY(pi),
                      child: _buildBackCard(context),
                    )
                  : _buildFrontCard(context),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFrontCard(BuildContext context) {
    final nbt = context.nbt;
    final member = widget.member;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(24),
      transform: Matrix4.translationValues(0, _isHovered ? -8 : 0, 0),
      decoration: BoxDecoration(
        color: nbt.surface,
        border: Border.all(
          color: _isHovered ? nbt.primaryAccent : nbt.textColor,
          width: _isHovered ? 3 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: _isHovered ? nbt.primaryAccent.withOpacity(0.3) : nbt.shadowColor,
            offset: Offset(_isHovered ? 12 : 8, _isHovered ? 12 : 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 64, 
                height: 64, 
                decoration: BoxDecoration(
                  color: _isHovered ? nbt.primaryAccent : Colors.grey[800],
                  border: Border.all(
                    color: _isHovered ? nbt.primaryAccent : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    member.name.substring(0, 1),
                    style: GameHUDTextStyles.headlineHeavy.copyWith(
                      fontSize: 32,
                      color: _isHovered ? nbt.surface : nbt.textColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(member.name, style: GameHUDTextStyles.titleLarge.copyWith(fontSize: 18)),
                    Text(member.role, style: GameHUDTextStyles.terminalText.copyWith(fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Stats
          ...member.stats.entries.map((e) => Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                SizedBox(width: 60, child: Text(e.key, style: GameHUDTextStyles.codeText)),
                Expanded(
                  child: LinearProgressIndicator(
                    value: e.value, 
                    backgroundColor: nbt.borderColor.withOpacity(0.2),
                    color: _isHovered ? nbt.primaryAccent : nbt.textColor.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          )),
          const Spacer(),
          // Hint to flip
          Center(
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: _isHovered ? 1.0 : 0.0,
              child: Text(
                "[ CLICK TO VIEW DOSSIER ]",
                style: GameHUDTextStyles.codeText.copyWith(
                  color: nbt.primaryAccent,
                  fontSize: 10,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackCard(BuildContext context) {
    final nbt = context.nbt;
    final member = widget.member;
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: nbt.primaryAccent,
        border: Border.all(color: nbt.textColor, width: 2),
        boxShadow: [BoxShadow(color: nbt.shadowColor, offset: const Offset(8, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "CLASSIFIED_DOSSIER",
            style: GameHUDTextStyles.terminalText.copyWith(
              color: nbt.surface,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            member.name.toUpperCase(),
            style: GameHUDTextStyles.titleLarge.copyWith(
              color: nbt.surface,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 24),
          
          // Secret Trait
          Container(
            padding: const EdgeInsets.all(12),
            color: nbt.surface.withOpacity(0.2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "SECRET_TRAIT:",
                  style: GameHUDTextStyles.codeText.copyWith(
                    color: nbt.surface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  member.secretTrait,
                  style: GameHUDTextStyles.terminalText.copyWith(
                    color: nbt.surface,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          
          const Spacer(),
          
          Center(
            child: Text(
              "[ CLICK TO RETURN ]",
              style: GameHUDTextStyles.codeText.copyWith(
                color: nbt.surface.withOpacity(0.7),
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
