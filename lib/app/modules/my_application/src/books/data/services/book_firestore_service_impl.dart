import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login_with_firebase/app/modules/my_application/src/authentication/presenter/controller/auth_store.dart';

import '../../domain/book_entity.dart';
import '../../domain/book_mapper.dart';
import '../../domain/book_services_interfaces/book_service.dart';

class BookFirestoreServiceImpl implements BookService {
  final FirebaseFirestore firestore;

  BookFirestoreServiceImpl(this.firestore, this.authStore);
    final AuthStore authStore; 

  @override
  Future<void> createBook(BookEntity book) async {
    final collectionRef = firestore.collection('books').doc(book.bId);
    await collectionRef.set(BookMapper.entityToMap(book));
  }

  @override
  Future<void> deleteBook(String bId) async {
    final documentRef = firestore.collection('books').doc(bId);
    print(documentRef);
    await documentRef.delete().then(
          (doc) => print("Document deleted "),
          onError: (e) => print("Error updating document $e"),
        );
  }

  @override
  Future<BookEntity?> getBookById(String bId) async {
    final documentSnapshot = await firestore.collection('books').doc(bId).get();

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
    final String? userId =
      authStore.getCurrentUserId(); // Acessar o ID do usuário atual

      final querySnapshot = await firestore
          .collection('books')
          .where('userId', isEqualTo: userId) // Filtrar por userId
          .get();

      final books = querySnapshot.docs.map((doc) {
        final map = doc.data();
        return BookMapper.mapToEntity(map);
      }).toList();

      return books;// Retornar uma lista vazia se o usuário não estiver autenticado
  }
}
