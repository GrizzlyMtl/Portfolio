class Animal {
  String name;
  int age;
  String sound;

  Animal(this.name, this.age, [this.sound = '']);

  void makeSound() {
    print('$name says $sound');
  }

  int get humanAge => age;
}

class Dog extends Animal {
  Dog(super.name, super.age);

  @override
  void makeSound() {
    sound = 'Woof';
    super.makeSound();
  }

  @override
  int get humanAge => age * 7;
}

class Cat extends Animal {
  Cat(super.name, super.age);

  @override
  void makeSound() {
    sound = 'Meow';
    super.makeSound();
  }

  @override
  int get humanAge => age * 6;
}

void main() {}
