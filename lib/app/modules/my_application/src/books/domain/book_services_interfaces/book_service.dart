import '../book_entity.dart';

abstract class BookService {
  Future<void> createBook(BookEntity book);
  Future<void> deleteBook(String bookId);
  Future<BookEntity?> getBookById(String bookId);
  Future<void> updateBook(BookEntity book);
}