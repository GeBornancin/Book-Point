import '../domain/book_entity.dart';
import '../domain/use_cases_interfaces/ICreateBookUseCase.dart';
import '../domain/use_cases_interfaces/IDeleteBookUseCase.dart';
import '../domain/use_cases_interfaces/IGetBookByIdUseCase.dart';
import '../domain/use_cases_interfaces/IUpdateBookUseCase.dart';

class BookManager {
  final ICreateBookUseCase createBookUseCase;
  final IDeleteBookUseCase deleteBookUseCase;
  final IGetBookByIdUseCase getBookByIdUseCase;
  final IUpdateBookUseCase updateBookUseCase;

  BookManager(
    this.createBookUseCase,
    this.deleteBookUseCase,
    this.getBookByIdUseCase,
    this.updateBookUseCase,
  );

  Future<void> createBook(BookEntity book) async {
    await createBookUseCase.createBook(book);
  }

  Future<void> deleteBook(String bookId) async {
    await deleteBookUseCase.deleteBook(bookId);
  }

  Future<BookEntity?> getBookById(String bookId) async {
    return await getBookByIdUseCase.getBookById(bookId);
  }

  Future<void> updateBook(BookEntity book) async {
    await updateBookUseCase.updateBook(book);
  }
}
