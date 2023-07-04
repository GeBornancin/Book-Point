import '../book_entity.dart';

abstract class BookService {
  Future<void> createBook(BookEntity book);
  Future<void> deleteBook(String bId);
  Future<BookEntity?> getBookById(String bId);
  Future<void> updateBook(BookEntity book);
  Future<List<BookEntity>> getBookList();
}
