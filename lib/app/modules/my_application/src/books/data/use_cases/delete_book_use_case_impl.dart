import '../../domain/book_services_interfaces/book_service.dart';
import '../../domain/use_cases_interfaces/IDeleteBookUseCase.dart';

class DeleteBookUseCaseImpl implements IDeleteBookUseCase {
  final BookService bookService;

  DeleteBookUseCaseImpl(this.bookService);

  @override
  Future<void> deleteBook(String bookId) async {
    await bookService.deleteBook(bookId);
  }
}