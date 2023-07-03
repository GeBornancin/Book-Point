import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

import '../authentication/domain/user_credencial_entity.dart';
import '../authentication/presenter/controller/auth_store.dart';

class Home extends StatelessWidget {
  const Home({super.key});

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
