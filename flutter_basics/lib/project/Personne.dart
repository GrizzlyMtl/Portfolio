class Person {
  final String nom;
  final String titre;
  final String telephone;
  final String email;
  final String localisation;
  final String photoUrl;
  final List<String> competences;

  final String linkedinUrl;
  final String githubUrl;
  final String facebookUrl;

  const Person({
    required this.nom,
    required this.titre,
    required this.telephone,
    required this.email,
    required this.localisation,
    required this.photoUrl,
    required this.competences,
    required this.linkedinUrl,
    required this.githubUrl,
    required this.facebookUrl,
  });
}
