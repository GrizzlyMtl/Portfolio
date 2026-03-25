//Enumerate
enum Category { roman, scienceFiction, history, biography }

//Class Book
class Book {
  String title;
  String author;
  int year;
  Category category;
  bool isAvailable;

  Book({
    required this.title,
    required this.author,
    required this.year,
    required this.category,
    this.isAvailable = false,
  });

  void borrowBook() {
    if (isAvailable) {
      isAvailable = false;
      print('The book "$title" has been borrowed.');
    } else {
      print('The book "$title" is not available.');
    }
  }

  void returnBook() {
    if (!isAvailable) {
      isAvailable = true;
      print('The book "$title" has been returned.');
    } else {
      print('You can\'t return a book that you haven\'t borrowed');
    }
  }

  void displayBookInfo() {
    print('Title: $title');
    print('Author: $author');
    print('Year: $year');
    print('Category: ${category.name}');
    print('Is Available: ${isAvailable ? 'Available' : 'Not Available'}');
  }

  int getAge() => DateTime.now().year - year;

  @override
  String toString() {
    return 'Book: $title by $author';
  }
}

//Class Library
class Library {
  List<Book> books;

  Library({required this.books});

  void addBook(Book book) {
    books.add(book);
    print('The book "${book.title}" has been added to the library');
  }

  List<Book> searchByAuthor(String author) {
    return books
        .where((book) => book.author.toLowerCase() == author.toLowerCase())
        .toList();
  }

  List<Book> searchAvailableBooks() =>
      books.where((book) => book.isAvailable).toList();

  String getTotalBooks() => "Total number of books: ${books.length}";
}

//Function CalculateAvgAge
double calculateAvgAge(List<Book> books) {
  int totalAge = 0;
  for (Book book in books) {
    totalAge += book.getAge();
  }
  return totalAge / books.length;
}

//Function ShowStats
String ShowStats(Library library) {
  String totalBooks = "Total number of books: ${library.books.length}";
  String totalAvailableBooks =
      "Total number of available books: ${library.searchAvailableBooks().length}";
  String totalNotAvailableBooks =
      "Total number of not available books: ${library.searchAvailableBooks().length}";
  String totalAge =
      "Total age of books: ${library.books.map((book) => book.getAge()).reduce((a, b) => a + b)}";
  String avgAge = "Average age of books: ${calculateAvgAge(library.books)}";
  return "$totalBooks\n$totalAvailableBooks\n$totalNotAvailableBooks\n$totalAge\n$avgAge";
}

void main() {
  // Initialize library
  var library = Library(books: []);

  //Add books to library
  library.addBook(
    Book(
      title: "1984",
      author: "George Orwell",
      year: 1949,
      category: Category.roman,
      isAvailable: true,
    ),
  );

  library.addBook(
    Book(
      title: "Animal Farm",
      author: "George Orwell",
      year: 1945,
      category: Category.roman,
      isAvailable: true,
    ),
  );

  library.addBook(
    Book(
      title: "Homage to Catalonia",
      author: "George Orwell",
      year: 1938,
      category: Category.history,
      isAvailable: false,
    ),
  );

  library.addBook(
    Book(
      title: "Foundation",
      author: "Isaac Asimov",
      year: 1951,
      category: Category.scienceFiction,
      isAvailable: true,
    ),
  );

  library.addBook(
    Book(
      title: "I, Robot",
      author: "Isaac Asimov",
      year: 1950,
      category: Category.scienceFiction,
      isAvailable: false,
    ),
  );

  library.addBook(
    Book(
      title: "Harry Potter and the Philosopher's Stone",
      author: "J.K. Rowling",
      year: 1997,
      category: Category.roman,
      isAvailable: true,
    ),
  );

  library.addBook(
    Book(
      title: "Harry Potter and the Chamber of Secrets",
      author: "J.K. Rowling",
      year: 1998,
      category: Category.roman,
      isAvailable: false,
    ),
  );

  library.addBook(
    Book(
      title: "Pride and Prejudice",
      author: "Jane Austen",
      year: 1813,
      category: Category.roman,
      isAvailable: true,
    ),
  );

  library.addBook(
    Book(
      title: "Emma",
      author: "Jane Austen",
      year: 1815,
      category: Category.roman,
      isAvailable: true,
    ),
  );

  library.addBook(
    Book(
      title: "The Shining",
      author: "Stephen King",
      year: 1977,
      category: Category.roman,
      isAvailable: false,
    ),
  );

  library.addBook(
    Book(
      title: "It",
      author: "Stephen King",
      year: 1986,
      category: Category.roman,
      isAvailable: true,
    ),
  );

  library.addBook(
    Book(
      title: "Murder on the Orient Express",
      author: "Agatha Christie",
      year: 1934,
      category: Category.roman,
      isAvailable: true,
    ),
  );

  library.addBook(
    Book(
      title: "And Then There Were None",
      author: "Agatha Christie",
      year: 1939,
      category: Category.roman,
      isAvailable: false,
    ),
  );

  library.addBook(
    Book(
      title: "The Old Man and the Sea",
      author: "Ernest Hemingway",
      year: 1952,
      category: Category.roman,
      isAvailable: true,
    ),
  );

  library.addBook(
    Book(
      title: "A Farewell to Arms",
      author: "Ernest Hemingway",
      year: 1929,
      category: Category.roman,
      isAvailable: false,
    ),
  );

  library.addBook(
    Book(
      title: "Sapiens: A Brief History of Humankind",
      author: "Yuval Noah Harari",
      year: 2011,
      category: Category.history,
      isAvailable: true,
    ),
  );

  library.addBook(
    Book(
      title: "Homo Deus: A Brief History of Tomorrow",
      author: "Yuval Noah Harari",
      year: 2015,
      category: Category.history,
      isAvailable: true,
    ),
  );

  library.addBook(
    Book(
      title: "The Great Gatsby",
      author: "F. Scott Fitzgerald",
      year: 1925,
      category: Category.roman,
      isAvailable: false,
    ),
  );

  library.addBook(
    Book(
      title: "To Kill a Mockingbird",
      author: "Harper Lee",
      year: 1960,
      category: Category.roman,
      isAvailable: true,
    ),
  );

  library.addBook(
    Book(
      title: "Brave New World",
      author: "Aldous Huxley",
      year: 1932,
      category: Category.scienceFiction,
      isAvailable: true,
    ),
  );

  try {
    print(library.searchByAuthor("George Orwell"));
    print(library.searchAvailableBooks());
    print(library.getTotalBooks());
    print(library.books[5].getAge());
    library.books[5].returnBook();
    library.books[5].borrowBook();
    library.books[5].displayBookInfo();
    print(ShowStats(library));
  } catch (e) {
    print('Error: $e');
  }
}
