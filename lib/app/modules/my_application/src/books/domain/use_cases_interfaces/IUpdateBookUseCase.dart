import '../book_entity.dart';

abstract class IUpdateBookUseCase {
  Future<void> updateBook(BookEntity book);
}