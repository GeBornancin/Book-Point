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

 Future<void> deleteBook(String bookId) async {
  // Chame o método no serviço de livros para excluir o livro
  await bookService.deleteBook(bookId);

  // Atualize a lista de livros e atualize a interface do usuário
  setState(() {
    books.removeWhere((book) => book.bId == bookId);
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Books'),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            const LoginDrawerHeader(),
            DrawerListTile(
              title: "Página 1",
              iconData: Icons.home,
              page: '/books',
            ),
            DrawerListTile(
              title: "Página 2",
              iconData: Icons.list,
              page: '/page2',
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
        child: Icon(Icons.add),
      ),
    );
  }

Future<void> _showCreateBookDialog() async {
  bool isCompleted = false;

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
            title: Text('Add Book'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                  ),
                ),
                TextField(
                  controller: authorController,
                  decoration: InputDecoration(
                    labelText: 'Author',
                  ),
                ),
                TextField(
                  controller: currentPageController,
                  decoration: InputDecoration(
                    labelText: 'Current Page',
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
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  final book = BookEntity(
                    bId: UniqueKey().toString(),
                    title: titleController.text,
                    author: authorController.text,
                    currentPage: int.parse(currentPageController.text),
                    isCompleted: isCompleted,
                    userId: '', // Set the user ID accordingly
                  );
                  createBook(book);
                  Navigator.of(context).pop();
                },
                child: Text('Save'),
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
    return ListTile(
      title: Text(widget.book.title),
      subtitle: Text(widget.book.author),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () => widget.onDelete(),
      ),
      onTap: () => _showEditBookDialog(context),
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
              title: Text('Edit Book'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: 'Title',
                    ),
                  ),
                  TextField(
                    controller: authorController,
                    decoration: InputDecoration(
                      labelText: 'Author',
                    ),
                  ),
                  TextField(
                    controller: currentPageController,
                    decoration: InputDecoration(
                      labelText: 'Current Page',
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
                  child: Text('Cancel'),
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
                  child: Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}



@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Book Point'),
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
    ),
    drawer: Drawer(
      child: ListView(
        children: <Widget>[
          const LoginDrawerHeader(),
          DrawerListTile(
            title: "Página 1",
            iconData: Icons.home,
            page: '/page1',
          ),
          DrawerListTile(
            title: "Página 2",
            iconData: Icons.list,
            page: '/page2',
          ),
        ],
      ),
    ),
  );
}

// class BookItem extends StatelessWidget {
//   final BookEntity book;
//   final Function(BookEntity) onUpdate;
//   final Function onDelete;

//   const BookItem({
//     Key? key,
//     required this.book,
//     required this.onUpdate,
//     required this.onDelete,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       title: Text(book.title),
//       subtitle: Text(book.author),
//       trailing: IconButton(
//         icon: Icon(Icons.delete),
//         onPressed: () => onDelete(),
//       ),
//       onTap: () => _showEditBookDialog(context),
//     );
//   }

//   Future<void> _showEditBookDialog(BuildContext context) async {
//     final TextEditingController titleController = TextEditingController(text: book.title);
//     final TextEditingController authorController = TextEditingController(text: book.author);

//     await showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Edit Book'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: titleController,
//                 decoration: InputDecoration(
//                   labelText: 'Title',
//                 ),
//               ),
//               TextField(
//                 controller: authorController,
//                 decoration: InputDecoration(
//                   labelText: 'Author',
//                 ),
//               ),
//             ],
//           ),
//           actions: [
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 final updatedBook = book.copyWith(
//                   title: titleController.text,
//                   author: authorController.text,
//                 );
//                 onUpdate(updatedBook);
//                 Navigator.of(context).pop();
//               },
//               child: Text('Save'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

Widget gambiarra() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      const Text(
        'Meu Aplicativo',
        style: TextStyle(fontSize: 30),
      ),
      Row(
        children: [
          const CircleAvatar(
            maxRadius: 35,
            child: Icon(Icons.question_mark, size: 40),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Icon(Icons.login, size: 40),
              TextButton(
                onPressed: () {
                  Modular.to.pushNamed('/login-page');
                },
                child: const Text("Entrar ou Cadastrar Login"),
              ),
            ],
          ),
        ],
      ),
    ],
  );
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

class LoginDrawerHeader extends StatelessWidget {
  const LoginDrawerHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final AuthStore authStore = Modular.get<AuthStore>();
    return DrawerHeader(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: [
          Color.fromARGB(255, 43, 43, 43),
          Colors.white,
          Colors.grey.shade300,
          Color.fromARGB(255, 130, 130, 130),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: const [0.0, 0.3, 0.6, 0.9],
      )),
      child: ScopedBuilder<AuthStore, UserCredentialApp?>(
        store: authStore,
        onLoading: ((_) => const CircularProgressIndicator()),
        onError: (_, failure) => gambiarra(),
        // onError: (_, failure) => Center(
        //   child: Text(
        //     '${failure.toString()}, por favor recarregue',
        //     style: const TextStyle(
        //       color: Colors.red,
        //       fontSize: 24.0,
        //     ),
        //   ),
        // ),
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
                  CircleAvatar(
                    maxRadius: 35,
                    child: (authStore.isAuth)
                        ? Text(
                            user!.name!.substring(0, 1).toUpperCase(),
                            style: const TextStyle(fontSize: 50),
                          )
                        : const Icon(Icons.question_mark, size: 40),
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
                        onPressed: () {
                          (authStore.isAuth)
                              ? authStore.userSignOut()
                              : Modular.to.pushNamed('/signin-page');
                        },
                        child: (authStore.isAuth)
                            ? const Text("Sair")
                            : const Text("Entrar ou Cadastrar Login"),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
