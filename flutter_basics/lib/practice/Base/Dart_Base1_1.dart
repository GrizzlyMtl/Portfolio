void main() {
  String multiligne = '''
  C'est une chaine de caracteres
  sur plusieurs lignes
  ''';
  print(multiligne);

  double note1 = 15.5;
  double note2 = 17.0;
  double note3 = 14.5;

  double moyenne = (note1 + note2 + note3) / 3;
  print('Moyenne: ${moyenne.toStringAsFixed(2)}');

  if (moyenne >= 10) {
    print('Moyenne plus grande que 10');
  } else {
    print('Moyenne inferieure a 10');
  }

  bool estVrai = true;
  bool estFaux = false;

  bool x = 10 > 5;
  bool y = 10 == 5;
  bool z = 10 != 5;

  print(x);
  print(y);
  print(z);

  bool a = estVrai && estVrai;
  bool b = estVrai && estFaux;
  bool c = estFaux || estVrai;
  bool d = estFaux || estFaux;

  print(a);
  print(b);
  print(c);
  print(d);

  bool i = !true;
  bool j = !false;

  print(i);
  print(j);

  dynamic x1 = 10;
  print(x1.runtimeType);

  x1 = 'texte';
  print(x1.runtimeType);

  x1 = [1, 2, 3];
  print(x1.runtimeType);

  x1 = {1, 2, 3};
  print(x1.runtimeType);

  x1 = {1: 'a', 2: 'b', 3: 'c'};
  print(x1.runtimeType);

  x1 = null;
  print(x1.runtimeType);

  String? x2;
  print(x2.runtimeType);

  x1 = [1, 'A', true];
  print(x1.runtimeType);
  print(x1[0]);
  print(x1[x1.length - 1]);

  x1.add(4);
  print(x1);

  x1.insert(1, 'Bob');
  print(x1);

  x1.insertAll(1, ['Alice', 'Charlie']);
  print(x1);
  print(x1.first);
  print(x1.last);

  x1.remove(3);
  print(x1);

  // Removing multiple indices in reverse order to avoid shifting
  x1.removeAt(6);
  x1.removeAt(5);
  x1.removeAt(4);
  x1.removeAt(0);
  print(x1);

  print(x1.length);

  x1.reversed;
  print(x1.reversed);

  x1.reversed.toList();
  print(x1);
  print(x1.isEmpty);
  print(x1.isNotEmpty);
  x1.clear();
  print(x1);
}
