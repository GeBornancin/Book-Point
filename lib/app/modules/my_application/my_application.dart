import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:login_with_firebase/app/modules/my_application/src/authentication/data/use_cases/auth_signin_user_case_impl.dart';
import 'package:login_with_firebase/app/modules/my_application/src/authentication/data/use_cases/auth_signout_user_case_impl.dart';
import 'package:login_with_firebase/app/modules/my_application/src/authentication/data/use_cases/auth_signup_user_case_impl.dart';
import 'package:login_with_firebase/app/modules/my_application/src/authentication/domain/user_credencial_entity.dart';
import 'package:login_with_firebase/app/modules/my_application/src/authentication/external/cache/auth_local_cache_sp_impl.dart';
import 'package:login_with_firebase/app/modules/my_application/src/authentication/external/services/email_auth_service_impl.dart';
import 'package:login_with_firebase/app/modules/my_application/src/authentication/manager/auth_service_manager.dart';
import 'package:login_with_firebase/app/modules/my_application/src/authentication/presenter/controller/auth_store.dart';
import 'package:login_with_firebase/app/modules/my_application/src/books/data/services/book_firestore_service_impl.dart';
import 'package:login_with_firebase/app/modules/my_application/src/books/data/use_cases/create_book_use_case_impl.dart';
import 'package:login_with_firebase/app/modules/my_application/src/books/data/use_cases/delete_book_use_case_impl.dart';
import 'package:login_with_firebase/app/modules/my_application/src/books/data/use_cases/get_book_by_id_use_case.dart';
import 'package:login_with_firebase/app/modules/my_application/src/books/data/use_cases/update_book_use_case_impl.dart';
import 'package:login_with_firebase/app/modules/my_application/src/books/domain/book_services_interfaces/book_service.dart';
import 'package:login_with_firebase/app/modules/my_application/src/books/domain/use_cases_interfaces/ICreateBookUseCase.dart';
import 'package:login_with_firebase/app/modules/my_application/src/books/domain/use_cases_interfaces/IDeleteBookUseCase.dart';
import 'package:login_with_firebase/app/modules/my_application/src/books/domain/use_cases_interfaces/IGetBookByIdUseCase.dart';
import 'package:login_with_firebase/app/modules/my_application/src/books/domain/use_cases_interfaces/IUpdateBookUseCase.dart';
import 'package:login_with_firebase/app/modules/my_application/src/views/book_view.dart';
import 'package:login_with_firebase/app/modules/my_application/src/views/home_page.dart';
import 'package:login_with_firebase/app/modules/my_application/src/views/signin_view.dart';
import 'package:login_with_firebase/app/modules/my_application/src/views/signup_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_guard.dart';

class MyApplication extends Module {
  @override
  List<Bind> binds = [
    //AsyncBind((i) => SharedPreferences.getInstance()),
    Bind.lazySingleton((i) => AuthServiceManager(AuthType.email)),
    Bind.lazySingleton((i) => EmailAuthServiceImpl()),
    Bind.singleton((i) => AuthLocalCacheSharedPrefsImpl()),
    
    //   Bind.lazySingleton((i) => AuthLocalCacheSharedPrefsImpl()),
    
    Bind.lazySingleton((i) => AuthSignInUserCaseImpl(i())),
    Bind.lazySingleton((i) => AuthSignOutUserCaseImpl(i())),
    Bind.lazySingleton((i) => AuthSignUpUserCaseImpl(i())),
    Bind.singleton<AuthStore>(
      (i) => AuthStore(
        userSignIn: i(),
        userSignOut: i(),
        userSignUp: i(),
        localCache: i(),
      ),
      onDispose: (store) => store.destroy,
      selector: (store) => store.state,
    ),

    // Register the BookService implementation
    Bind<BookService>((i) => BookFirestoreServiceImpl(
      FirebaseFirestore.instance,i.get<AuthStore>(),)),
    // Bind for Create
    Bind<ICreateBookUseCase>((i) => CreateBookUseCaseImpl(i.get<BookService>())),
    // Bind for Read
    Bind<IGetBookByIdUseCase>((i) => GetBookByIdUseCase(i.get<BookService>())),
    // Bind for Update
    Bind<IUpdateBookUseCase>((i) => UpdateBookUseCaseImpl(i.get<BookService>())),
    // Bind for Delete
    Bind<IDeleteBookUseCase>((i) => DeleteBookUseCaseImpl(i.get<BookService>())),
  ];

  @override
  List<ModularRoute> routes = [
    ChildRoute('/', child: (ctx, args) =>SignInPage(), guards: [HomeGuard()]),
    ChildRoute(
      '/home-page',
      child: (context, args) => BookView( ),
    ),
    ChildRoute(
      '/signin-page',
      child: (context, args) => SignInPage(),
    ),
    ChildRoute(
      '/signup-page',
      child: (context, args) => SignUpPage(),
    ),
  ];
}
