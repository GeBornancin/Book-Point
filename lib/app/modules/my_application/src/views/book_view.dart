import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';


import '../authentication/domain/user_credencial_entity.dart';
import '../authentication/presenter/controller/auth_store.dart';
import '../books/domain/book_entity.dart';
import '../books/domain/book_services_interfaces/book_service.dart';


class BookView extends StatefulWidget {
  @override
  _BookViewState createState() => _BookViewState();
}

class _BookViewState extends State<BookView> {
  final BookService bookService = Modular.get<BookService>();
  List<BookEntity> books = [];

  final TextEditingController titleController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  final TextEditingController currentPageController = TextEditingController();
  bool isCompleted = false;

  @override
  void initState() {
    super.initState();
    loadBooks();
  }

  Future<void> loadBooks() async {
    books = await bookService.getBookList();
    setState(() {});
  }

  Future<void> createBook(BookEntity book) async {
    await bookService.createBook(book);
    loadBooks();
  }

  Future<void> updateBook(BookEntity book) async {
    await bookService.updateBook(book);
    loadBooks();
  }

  Future<void> deleteBook(String bId) async {
    // Chame o método no serviço de livros para excluir o livro
    await bookService.deleteBook(bId);

    // Atualize a lista de livros e atualize a interface do usuário
    setState(() {
      books.removeWhere((book) => book.bId == bId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final AuthStore authStore = Modular.get<AuthStore>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book List'),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color.fromARGB(255, 43, 43, 43),
                    Colors.white,
                    Colors.grey.shade300,
                    const Color.fromARGB(255, 130, 130, 130),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: const [0.0, 0.3, 0.6, 0.9],
                ),
              ),
              child: ScopedBuilder<AuthStore, UserCredentialApp?>(
                store: authStore,
                onLoading: ((_) => const CircularProgressIndicator()),
                onState: (context, authState) {
                  var user = authState;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text(
                        'Book point',
                        style: TextStyle(fontSize: 30),
                      ),
                      Row(
                        children: [
                         GestureDetector(
                          child: CircleAvatar(
                            maxRadius: 35,
                            backgroundImage: (authStore.isAuth && user!.profileImage != null)
                                ? NetworkImage(user!.profileImage!)
                                : null,
                            child: (authStore.isAuth && user!.profileImage == null)
                                ? Text(
                                    user!.name!.substring(0, 1).toUpperCase(),
                                    style: const TextStyle(fontSize: 50),
                                  )
                                : null,
                          ),
                        ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              (authStore.isAuth)
                                  ? Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(user!.name!),
                                        const SizedBox(height: 5),
                                        Text(user.email),
                                      ],
                                    )
                                  : const Icon(Icons.login, size: 40),
                              TextButton(
                                onPressed: () async {
                                  await authStore.userSignOut();  
                                  Modular.to.pushNamed('/signin-page');
                                },
                                child: const Text("Sair"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          return BookItem(
            book: book,
            onUpdate: (updatedBook) => updateBook(updatedBook),
            onDelete: () => deleteBook(book.bId),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateBookDialog(),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        child: const Icon(Icons.bookmark_add),
      ),
    );
  }

  Future<void> _showCreateBookDialog() async {
    bool isCompleted = false;
    final AuthStore authStore = Modular.get<AuthStore>();
    final userId = authStore.state?.uId ?? ''; // Obtenha o ID do usuário

    await showDialog(
      context: context,
      builder: (context) {
        final TextEditingController titleController = TextEditingController();
        final TextEditingController authorController = TextEditingController();
        final TextEditingController currentPageController =
            TextEditingController();

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Livro novo:'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Titulo',
                    ),
                  ),
                  TextField(
                    controller: authorController,
                    decoration: const InputDecoration(
                      labelText: 'Autor',
                    ),
                  ),
                  TextField(
                    controller: currentPageController,
                    decoration: const InputDecoration(
                      labelText: 'Página em que parou',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  CheckboxListTile(
                    value: isCompleted,
                    onChanged: (value) {
                      setState(() {
                        isCompleted = value!;
                      });
                      const Color.fromARGB(255, 0, 0, 0);
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    title: const Text('Lido'),
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 246, 8, 8)), // Defina a cor de fundo como preto
                  ),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final book = BookEntity(
                      bId: UniqueKey().toString(),
                      title: titleController.text,
                      author: authorController.text,
                      currentPage: int.parse(currentPageController.text),
                      isCompleted: isCompleted,
                      userId: userId, // Set the user ID accordingly
                    );
                    createBook(book);
                    Navigator.of(context).pop();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.black), // Defina a cor de fundo como preto
                  ),
                  child: const Text('Salvar'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class BookItem extends StatefulWidget {
  final BookEntity book;
  final Function(BookEntity) onUpdate;
  final Function onDelete;

  const BookItem({
    Key? key,
    required this.book,
    required this.onUpdate,
    required this.onDelete,
  }) : super(key: key);

  @override
  _BookItemState createState() => _BookItemState();
}

class _BookItemState extends State<BookItem> {
  bool isCompleted = false;

  @override
  void initState() {
    super.initState();
    isCompleted = widget.book.isCompleted;
  }
  
@override
Widget build(BuildContext context) {
  return Column(
    children: [
      ListTile(
        title: Row(
          children: [
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 1000),
              firstChild: const Icon(Icons.clear, color: Colors.red),
              secondChild: const Icon(Icons.check, color: Colors.green),
              crossFadeState: widget.book.isCompleted
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
            ),
            const SizedBox(width: 8), // Espaçamento entre a animação e o título
            Text(widget.book.title),
          ],
        ),
        subtitle: Text(widget.book.author),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.delete),
              color: const Color.fromARGB(255, 252, 0, 0),
              onPressed: () => widget.onDelete(),
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              color: const Color.fromARGB(255, 0, 0, 0),
              onPressed: () => _showEditBookDialog(context),
            ),
          ],
        ),
      ),
      const Divider(
        color: Colors.grey, // Define a cor do Divider
        thickness: 1.0, // Define a espessura do Divider
      ),
    ],
  );
}

  Future<void> _showEditBookDialog(BuildContext context) async {
    final TextEditingController titleController =
        TextEditingController(text: widget.book.title);
    final TextEditingController authorController =
        TextEditingController(text: widget.book.author);
    final TextEditingController currentPageController =
        TextEditingController(text: widget.book.currentPage.toString());

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Editando livro'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Titulo',
                    ),
                  ),
                  TextField(
                    controller: authorController,
                    decoration: const InputDecoration(
                      labelText: 'Autor',
                    ),
                  ),
                  TextField(
                    controller: currentPageController,
                    decoration: const InputDecoration(
                      labelText: 'Pagina em que parou',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  CheckboxListTile(
                    value: isCompleted,
                    onChanged: (value) {
                      setState(() {
                        isCompleted = value!;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    title: const Text('Lido'),
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 246, 8, 8)), // Defina a cor de fundo como preto
                  ),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final updatedBook = widget.book.copyWith(
                      title: titleController.text,
                      author: authorController.text,
                      currentPage: int.parse(currentPageController.text),
                      isCompleted: isCompleted,
                    );
                    widget.onUpdate(updatedBook);
                    Navigator.of(context).pop();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 0, 0, 0)), // Defina a cor de fundo como preto
                  ),
                  child: const Text('Salvar'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class DrawerListTile extends StatelessWidget {
  String title;
  String page;
  IconData iconData;
  DrawerListTile(
      {super.key,
      required this.title,
      required this.page,
      required this.iconData});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Modular.to.pushNamed(page),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, top: 5),
        child: ListTile(
          title: Text(
            title,
            style: const TextStyle(fontSize: 20),
          ),
          leading: Icon(iconData),
        ),
      ),
    );
  }
}

class RatingWidget extends StatefulWidget {
  final int initialRating;
  final Function(int) onRatingChanged;

  const RatingWidget({
    Key? key,
    required this.initialRating,
    required this.onRatingChanged,
  }) : super(key: key);

  @override
  _RatingWidgetState createState() => _RatingWidgetState();
}

class _RatingWidgetState extends State<RatingWidget> {
  late int _currentRating;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.initialRating;
  }

  void _handleRatingChanged(int rating) {
    setState(() {
      _currentRating = rating;
    });

    widget.onRatingChanged(rating);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final filledStar = index < _currentRating;
        return GestureDetector(
          onTap: () => _handleRatingChanged(index + 1),
          child: Icon(
            filledStar ? Icons.star : Icons.star_border,
            color: filledStar ? Colors.yellow : Colors.grey,
          ),
        );
      }),
    );
  }
}
