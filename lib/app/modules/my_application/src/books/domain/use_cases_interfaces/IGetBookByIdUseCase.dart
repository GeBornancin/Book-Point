import '../book_entity.dart';

abstract class IGetBookByIdUseCase {
  Future<BookEntity?> getBookById(String bookId);
}