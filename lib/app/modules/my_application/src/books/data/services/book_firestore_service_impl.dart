import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/book_entity.dart';
import '../../domain/book_mapper.dart';
import '../../domain/book_services_interfaces/book_service.dart';

class BookFirestoreServiceImpl implements BookService {
  final FirebaseFirestore firestore;

  BookFirestoreServiceImpl(this.firestore);

  @override
  Future<void> createBook(BookEntity book) async {
    final collectionRef = firestore.collection('books');
    await collectionRef.add(BookMapper.entityToMap(book));
  }

  @override
  Future<void> deleteBook(String bookId) async {
    final documentRef = firestore.collection('books').doc(bookId);
    await documentRef.delete();
  }

  @override
  Future<BookEntity?> getBookById(String bookId) async {
    final documentSnapshot =
        await firestore.collection('books').doc(bookId).get();

    if (documentSnapshot.exists) {
      final map = documentSnapshot.data();
      if (map != null) {
        return BookMapper.mapToEntity(map);
      }
    }

    return null;
  }

  @override
  Future<void> updateBook(BookEntity book) async {
    final documentRef = firestore.collection('books').doc(book.bId);
    await documentRef.set(BookMapper.entityToMap(book));
  }
  
  @override
  Future<List<BookEntity>> getBookList() async {
    final querySnapshot = await firestore.collection('books').get();

    final books = querySnapshot.docs.map((doc) {
      final map = doc.data();
      return BookMapper.mapToEntity(map);
    }).toList();

  return books;
}
}