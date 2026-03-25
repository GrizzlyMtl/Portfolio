import 'dart:math';

//Classes
class BankAccount {
  int _accountNumber = Random().nextInt(1000000);
  double _balance;
  String owner;
  // Fixed: explicitly typed 'balance' as double default (5000.0)
  // Fixed: 'owner' default is now a string literal, not a class field
  BankAccount({double balance = 5000.0, this.owner = "Unknown"})
    : _balance = balance;
  int GetAccountNumber() => _accountNumber;
  int SetAccountNumber(int accountNumber) => _accountNumber = accountNumber;
  double GetBalance() => _balance;
  double SetBalance(double balance) => _balance = balance;
}

class Person {
  String FirstName;
  String LastName;
  String DateOfBirth;
  BankAccount account;
  Person({
    this.FirstName = "Guillaume",
    this.LastName = "Elie",
    this.DateOfBirth = '1995/03/28',
    BankAccount? account, // Fixed: made optional nullable
  }) : account =
           account ??
           // Fixed: Logic moved to initializer list where we can creates new objects
           BankAccount(balance: 5000.0, owner: "$FirstName $LastName");
  String DisplayInfo() => "$FirstName $LastName, born in $DateOfBirth";
  int GetAge() {
    int age = 2025 - int.parse(DateOfBirth.split('/')[0]);
    return age;
  }

  String SayHello() => "Hello, I'm $FirstName $LastName";
  String SayHelloToOtherPerson(Person otherPerson) {
    return "Hello ${otherPerson.FirstName}, I'm $FirstName";
  }
}

void main() {
  Person person = Person();
  Person person2 = Person(
    FirstName: "Paul",
    LastName: "Mircea",
    DateOfBirth: '1997/01/29',
  );
  // Fixed: passing a string (FirstName) instead of the whole Person object
  BankAccount account = BankAccount(owner: person.FirstName);
  print(person.DisplayInfo());
  print("${person.FirstName} is ${person.GetAge()}");
  print("${person2.FirstName} is ${person2.GetAge()}");
  print(person.SayHello());
  print(person2.SayHelloToOtherPerson(person));
  print(account.GetBalance());
  print(account.GetAccountNumber());
  account.SetBalance(10000.0);
  print(account.GetBalance());
}
