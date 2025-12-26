class TeamMember {
  final String name;
  final String role;
  final Map<String, double> stats; // e.g. "LOGIC": 0.8
  final String secretTrait;

  const TeamMember({
    required this.name,
    required this.role,
    required this.stats,
    required this.secretTrait,
  });
}
