class BookEntity {
  final String bId;
  final String title;
  final String author;
  int currentPage;
  bool isCompleted;
  final String userId;

  BookEntity({
    required this.bId,
    required this.title,
    required this.author,
    this.currentPage = 0,
    this.isCompleted = false,
    required this.userId,
  });
}