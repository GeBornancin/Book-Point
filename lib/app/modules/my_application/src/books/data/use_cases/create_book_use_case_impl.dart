
import '../../domain/book_entity.dart';
import '../../domain/book_services_interfaces/book_service.dart';
import '../../domain/use_cases_interfaces/ICreateBookUseCase.dart';

class CreateBookUseCaseImpl implements ICreateBookUseCase {
  final BookService bookService;

  CreateBookUseCaseImpl(this.bookService);

  @override
  Future<void> createBook(BookEntity book) async {
    await bookService.createBook(book);
  }
}