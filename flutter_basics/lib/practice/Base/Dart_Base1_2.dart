void main() {
  Map<String, dynamic> Dict2 = {};
  Map<String, dynamic> livre = {
    'Titre': 'Alice au pays des merveilles',
    'Auteur': 'Lewis Carroll',
    'Annee de publication': 1865,
    'Nombre de pages': 256,
    'Genre': 'Fable',
    'Prix': 10.99,
    'Disponible': true,
  };
  Dict2.addAll(livre);
  print(Dict2);
  //for (var key in livre.keys) {
  //  print('${key}: ${livre[key]}');
  //}
  if (livre['Disponible'] == true) {
    print('Le livre est disponible');
  } else {
    print('Le livre n\'est pas disponible');
  }

  List<int> list1 = [];
  List<int> list2 = [];
  List<int> list3 = [];
  List<int> list4 = [];

  for (int i = 0; i < 3; i++) {
    list1.add(i);
  }
  for (int i = 1; i <= 3; i++) {
    list2.add(i);
  }
  for (int i = 0; i < 6; i += 2) {
    list3.add(i);
  }
  for (int i = 5; i > 2; i--) {
    list4.add(i);
  }
  print(list1);
  print(list2);
  print(list3);
  print(list4);

  int age = 20;

  String status = age >= 18 ? 'Majeur' : 'Mineur';
  print(status);
  age = 65;
  if (age > 18 && age < 65) {
    print('Adulte');
  } else if (age >= 65) {
    print('Senior');
  } else {
    print('Mineur');
  }

  int temperature = 25;
  String weather = temperature >= 20
      ? 'Temperature Chaude'
      : (temperature >= 10 ? 'Temperature Fraiche ' : 'Temperature Froide');
  print(weather);

  List<int> list7 = [];
  List<String> fruits = ['Pomme', 'Banane', 'Orange'];
  for (var element in fruits) {
    list7.add(element.length);
  }
  print(list7);
  Map<int, String> Dict = {};
  for (var entry in fruits.asMap().entries) {
    Dict.addAll({entry.key: entry.value});
  }
  print(Dict);
  Map<int, String> Dict1 = {};
  List<String> colors = ['Rouge', 'Bleu', 'Vert', 'Jaune', 'Orange', 'Mauve'];
  for (var entry in colors.sublist(1).asMap().entries) {
    Dict1.addAll({entry.key + 1: entry.value});
  }
  print(Dict1);

  List<int> list5 = [];
  int compteur = 0;
  while (compteur < 10) {
    compteur++;
    list5.add(compteur);
  }
  print(list5);

  List<int> list6 = [];
  int compteur2 = 10;
  do {
    compteur2 -= 2;
    list6.add(compteur2);
  } while (compteur2 > 1);
  print(list6);
}
