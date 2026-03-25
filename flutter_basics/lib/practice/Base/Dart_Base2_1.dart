//Procedure
int counter = 0;
bool SaidHello = false;

void increment() {
  counter++;
}

void Bye(String nom, String msg) {
  print("$msg $nom");
}

//Function
int carre(int x) {
  return x * x;
}

String SayHello(String name, [msg = "Hello"]) {
  SaidHello = true;
  return "$msg $name";
}

//Arrow Function
int cube(int x) => x * x * x;

String SayHi(String name, [msg = "Hi"]) => "$msg $name";

//Recursive Function
int factorial(int n) {
  if (n == 0) return 1;
  return n * factorial(n - 1);
}

String SayBye(String name, [msg = "Bye"]) {
  if (SaidHello) {
    SaidHello = false;
    return "$msg $name";
  } else {
    return "You are alone.";
  }
}

void main() {
  increment();
  increment();
  increment();
  print(counter);

  Bye("John", "Bye");

  print(carre(5));
  SayHello("John");
  SayHello("John", "Hi");

  cube(5);
  SayHi("John");
  SayHi("John", "Hello");

  factorial(5);
  SayBye("John");
  SayBye("John", "GoodBye");
}
