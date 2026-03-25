import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Personne.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const person = Person(
    nom: 'Guillaume Elie',
    titre: 'Développeur en IA',
    telephone: '(438)402-3561',
    email: 'loghdlxx@gmail.com',
    localisation: 'Montréal, Québec, Canada',
    photoUrl: 'https://xsgames.co/randomusers/avatar.php?g=male',
    competences: [
      'Langues : Français & Anglais',
      'Langages : Python (Avancé), R (Avancé), C++, SQL, JavaScript, Dart',
      'Frameworks : TensorFlow, PyTorch, Scikit-Learn, Pandas, NumPy, Polars, Seaborn, Plotly, Matplotlib, Flask, Django, React.js, Flutter',
      'Bases de données : SQLite, SQL',
      'Outils : Docker, GitHub, CI/CD, PowerBi Desktop',
      'Spécialités : Machine Learning, NLP, Visualisation de données',
    ],
    linkedinUrl: 'https://www.linkedin.com/in/guillaume-elie-a82a2b392/',
    githubUrl: 'https://github.com/GrizzlyMtl/',
    facebookUrl: 'https://www.facebook.com/Guillohm.Grizzly/',
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.transparent,

        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white, fontSize: 18),
          bodyLarge: TextStyle(color: Colors.white, fontSize: 20),
        ),

        cardTheme: CardThemeData(
          color: const Color(0xFF242424),
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black87,
          elevation: 6,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),

      home: const ProfilePage(person: person),
    );
  }
}

class ProfilePage extends StatelessWidget {
  final Person person;

  const ProfilePage({super.key, required this.person});

  // Fonction pour ouvrir une URL
  Future<void> openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  // Fonction qui retourne un widget pour une ligne de contact
  Widget buildContactItem(IconData icon, String text) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70),
        const SizedBox(height: 4),
        Text(text),
        const SizedBox(height: 12),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //Theme
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 0, 0, 82),
            Color.fromARGB(255, 57, 0, 180),
            Color(0xFF1A1A1A),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text("Mon Profil"),
          actions: [
            IconButton(
              icon: const FaIcon(FontAwesomeIcons.linkedin),
              onPressed: () => openUrl(person.linkedinUrl),
            ),
            IconButton(
              icon: const FaIcon(FontAwesomeIcons.github),
              onPressed: () => openUrl(person.githubUrl),
            ),
            IconButton(
              icon: const FaIcon(FontAwesomeIcons.facebook),
              onPressed: () => openUrl(person.facebookUrl),
            ),
          ],
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Competences
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Compétences",
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Boucle for dynamique
                          for (var competence in person.competences)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: InfoCard(
                                width: double.infinity,
                                height: 80,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      competence,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 32),
                    // Profile card
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.network(
                              person.photoUrl,
                              height: 200,
                              width: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 30),
                          InfoCard(
                            width: 300,
                            height: 320,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  person.nom,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  person.titre,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                const Divider(color: Colors.white24),
                                const SizedBox(height: 20),
                                // Contact
                                buildContactItem(Icons.phone, person.telephone),
                                buildContactItem(Icons.email, person.email),
                                buildContactItem(
                                  Icons.location_on,
                                  person.localisation,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;

  const InfoCard({
    super.key,
    required this.child,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}
