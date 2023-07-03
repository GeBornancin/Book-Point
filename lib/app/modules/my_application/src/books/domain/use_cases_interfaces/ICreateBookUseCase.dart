import '../book_entity.dart';

abstract class ICreateBookUseCase {
  Future<void> createBook(BookEntity book);
}