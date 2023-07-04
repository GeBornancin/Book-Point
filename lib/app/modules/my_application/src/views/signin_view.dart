import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:login_with_firebase/app/modules/my_application/src/common/messages/messages_app.dart';

import '../authentication/domain/user_credencial_entity.dart';
import '../authentication/presenter/controller/auth_store.dart';
import '../components/form_field_login.dart';

class SignInPage extends StatefulWidget {
  SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _userLoginController = TextEditingController();
  final _userPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late AuthStore authStore;

  @override
  void initState() {
    super.initState();
    authStore = Modular.get<AuthStore>();
    authStore.checkCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: SafeArea(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.08,
                  vertical: size.height * 0.02,
                ),
                child: Column(
                  children: <Widget>[
                    Icon(
                      Icons.lock_person_rounded,
                      size: size.height * 0.2,
                    ),
                    SizedBox(height: size.height * 0.008),
                    const Text(
                      'Book Point',
                      style: TextStyle(fontSize: 24),
                    ),
                    SizedBox(height: size.height * 0.03),
                    FormFieldLogin(
                      hintName: 'E-mail do Usuário',
                      icon: Icons.person_2_outlined,
                      controller: _userLoginController,
                      inputType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: size.height * 0.01),
                    FormFieldLogin(
                      hintName: 'Senha',
                      icon: Icons.lock,
                      controller: _userPasswordController,
                      isObscured: true,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => Modular.to.pushNamed('/signup-page'),
                        child: const Text(
                          'Cadastrar-se',
                          style: TextStyle(
                            color: Color.fromARGB(255, 65, 81, 81),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    ScopedListener<AuthStore, UserCredentialApp?>(
                      store: authStore,
                      onState: (context_, state) {
                        try {
                          Modular.to.pushNamed('/home-page');
                        } catch (e) {
                          print(
                              'Erro durante a navegação para a próxima página: $e');
                        }
                      },
                      onError: (context, error) =>
                          MessagesApp.showCustom(context, error.toString()),
                      child: Container(
                        width: size.width * 0.75,
                        height: size.height * 0.06,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              authStore.userSignIn(
                                email: _userLoginController.text.trim(),
                                password: _userPasswordController.text.trim(),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            //shape: const StadiumBorder(),
                            backgroundColor: Colors.black,
                          ),
                          child: const Text(
                            'Entrar',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.04),
                    const Row(
                      children: <Widget>[
                        Expanded(
                          child: Divider(
                            color: Color.fromARGB(255, 65, 81, 81),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Color.fromARGB(255, 65, 81, 81),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
