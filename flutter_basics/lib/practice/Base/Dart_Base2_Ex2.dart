// Enum for book categories
enum Category { humor, scienceFiction, fantasy, biography }

// Book class definition
class Book {
  final String title;
  final String author;
  final int year;
  final Category category;
  bool _isAvailable;

  Book({
    required this.title,
    required this.author,
    required this.year,
    required this.category,
    required bool isAvailable,
  }) : _isAvailable = isAvailable;

  // Borrow a book
  void borrowBook() {
    if (_isAvailable) {
      _isAvailable = false;
      print('The book "$title" has been borrowed.');
    } else {
      print('The book "$title" is not available.');
    }
  }

  // Return a book
  void returnBook() {
    if (!_isAvailable) {
      _isAvailable = true;
      print('The book "$title" has been returned.');
    } else {
      print('You cannot return a book that was not borrowed.');
    }
  }

  // Display book information
  String displayBookInfo() {
    return '''
Title: $title
Author: $author
Year: $year
Category: ${category.name}
Availability: ${_isAvailable ? 'Available' : 'Not Available'}
''';
  }

  // Availability getter
  bool get isAvailable => _isAvailable;

  // Age of the book
  int getAge() => DateTime.now().year - year;

  @override
  String toString() => 'Book: $title by $author';
}

// Library class definition
class Library {
  final List<Book> books;

  Library(this.books);

  // Add a book to the library
  void addBook(Book book) {
    books.add(book);
    print('The book "${book.title}" has been added to the library.');
  }

  // Search books by author
  void searchByAuthor(String author) {
    final result = books
        .where((book) => book.author.toLowerCase() == author.toLowerCase())
        .toList();

    print("${result.length} books found for author $author.");
    for (var book in result) {
      print("- ${book.title}");
    }
  }

  // Search available books
  void searchAvailableBooks() {
    final result = books.where((book) => book.isAvailable).toList();
    print("${result.length} books are available.");
    for (var book in result) {
      print("- ${book.title}");
    }
  }

  // Get total number of books
  String getTotalBooks() => "Total number of books: ${books.length}";

  // Get average age of books
  double getAvgAge() =>
      books.map((book) => book.getAge()).reduce((a, b) => a + b) / books.length;

  // Get library statistics
  String getStats() {
    final availableCount = books.where((book) => book.isAvailable).length;
    final borrowedCount = books.length - availableCount;
    final totalAge = books.map((book) => book.getAge()).reduce((a, b) => a + b);

    return '''
Total number of books: ${books.length}
Total number of available books: $availableCount
Total number of borrowed books: $borrowedCount
Total age of books: $totalAge
Average age of books: ${getAvgAge().toStringAsFixed(1)}
''';
  }
}

class LibraryConfig {
  static const int maxBooks = 100;
  static const int maxBorrowDays = 14;
  static const double lateFeePerDay = 1.5;
}

// Main function
void main() {
  final library = Library([]);

  library.addBook(
    Book(
      title: '1984',
      author: 'George Orwell',
      year: 1949,
      category: Category.humor,
      isAvailable: true,
    ),
  );

  library.addBook(
    Book(
      title: 'Animal Farm',
      author: 'George Orwell',
      year: 1945,
      category: Category.humor,
      isAvailable: true,
    ),
  );

  library.addBook(
    Book(
      title: 'The Great Gatsby',
      author: 'F. Scott Fitzgerald',
      year: 1925,
      category: Category.humor,
      isAvailable: true,
    ),
  );

  library.addBook(
    Book(
      title: 'To Kill a Mockingbird',
      author: 'Harper Lee',
      year: 1960,
      category: Category.humor,
      isAvailable: true,
    ),
  );

  library.addBook(
    Book(
      title: 'The Catcher in the Rye',
      author: 'J.D. Salinger',
      year: 1951,
      category: Category.humor,
      isAvailable: true,
    ),
  );

  // Borrow and return operations
  library.books[2].borrowBook();
  library.books[2].returnBook();
  library.books[2].borrowBook();
  library.books[4].borrowBook();

  // Display all books
  for (var book in library.books) {
    print(book.displayBookInfo());
  }

  // Search operations
  library.searchByAuthor('George Orwell');
  library.searchAvailableBooks();

  // Statistics
  print(library.getStats());

  // More borrow/return operations
  library.books[2].borrowBook();
  library.books[2].returnBook();

  // Updated statistics
  print(library.getStats());
}
