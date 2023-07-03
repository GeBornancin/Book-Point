import 'dart:convert';

import 'book_entity.dart';

abstract class BookMapper {
  static Map<String, dynamic> entityToMap(BookEntity book) {
    return {
      'bId': book.bId,
      'title': book.title,
      'author': book.author,
      'currentPage': book.currentPage,
      'isCompleted': book.isCompleted,
      'userId' : book.userId,
    };
  }

  static String entityToJson(BookEntity book) {
    var map = entityToMap(book);
    return mapToJson(map);
  }

  static BookEntity mapToEntity(Map<String, dynamic> map) {
    return BookEntity(
      bId: map['bId'],
      title: map['title'],
      author: map['author'],
      currentPage: map['currentPage'],
      isCompleted: map['isCompleted'],
      userId:map['userId'],
    );
  }

  static String mapToJson(Map<String, dynamic> map) => jsonEncode(map);
  static Map<String, dynamic> jsonToMap(String json) => jsonDecode(json);
  static BookEntity jsonToEntity(String json) {
    var map = jsonToMap(json);
    return mapToEntity(map);
  }
}
