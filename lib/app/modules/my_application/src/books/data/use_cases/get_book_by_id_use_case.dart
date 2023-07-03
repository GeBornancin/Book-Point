import '../../domain/book_entity.dart';
import '../../domain/book_services_interfaces/book_service.dart';
import '../../domain/use_cases_interfaces/IGetBookByIdUseCase.dart';

class GetBookByIdUseCase implements IGetBookByIdUseCase {
  final BookService bookService;

  GetBookByIdUseCase(this.bookService);

  @override
  Future<BookEntity?> getBookById(String bookId) async {
    return await bookService.getBookById(bookId);
  }
}