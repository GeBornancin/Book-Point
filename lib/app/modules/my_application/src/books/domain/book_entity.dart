class BookEntity {
  final String bId;
  final String title;
  final String author;
  final int currentPage;
  final bool isCompleted;
  final String userId;

  BookEntity({
    required this.bId,
    required this.title,
    required this.author,
    required this.currentPage,
    required this.isCompleted,
    required this.userId,
  });

  BookEntity copyWith({
    String? bId,
    String? title,
    String? author,
    int? currentPage,
    bool? isCompleted,
    String? userId,
  }) {
    return BookEntity(
      bId: bId ?? this.bId,
      title: title ?? this.title,
      author: author ?? this.author,
      currentPage: currentPage ?? this.currentPage,
      isCompleted: isCompleted ?? this.isCompleted,
      userId: userId ?? this.userId,
    );
  }
}
