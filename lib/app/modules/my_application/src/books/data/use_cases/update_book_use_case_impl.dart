import '../../domain/book_entity.dart';
import '../../domain/book_services_interfaces/book_service.dart';
import '../../domain/use_cases_interfaces/IUpdateBookUseCase.dart';

class UpdateBookUseCaseImpl implements IUpdateBookUseCase {
  final BookService bookService;

  UpdateBookUseCaseImpl(this.bookService);

  @override
  Future<void> updateBook(BookEntity book) async {
    await bookService.updateBook(book);
  }
}