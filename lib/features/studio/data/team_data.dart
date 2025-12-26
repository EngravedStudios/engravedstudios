import 'package:engravedstudios/features/studio/domain/team_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'team_data.g.dart';

// No complex async needed for static team data, but Provider is good for consistency
@riverpod
List<TeamMember> teamMembers(Ref ref) {
  return const [
    TeamMember(
      name: "PASCAL 'VOIT' D.",
      role: "Game Developer & Technical Artist",
      stats: {
        "LOGIC": 0.90,
        "ART": 0.55,
        "CHAOS": 0.6,
      },
      secretTrait: "Compiles in his sleep.",
    ),
    TeamMember(
      name: "NIKLAS 'NIZCA' A.",
      role: "Sound Designer & Game Designer",
      stats: {
        "LOGIC": 0.55,
        "AUDIO": 1.0,
        "CHAOS": 0.35,
      },
      secretTrait: "Listens to white noise.",
    ),
    TeamMember(
      name: "EPHRAM 'SERKA' J.",
      role: "Art Director & Artist",
      stats: {
        "LOGIC": 0.4,
        "ART": 1.0,
        "CHAOS": 0.75,
      },
      secretTrait: "Sees wireframes in RL.",
    ),
  ];
}
