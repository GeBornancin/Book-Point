import 'package:flutter_modular/flutter_modular.dart';
import 'package:login_with_firebase/app/modules/my_application/src/authentication/data/use_cases/auth_signin_user_case_impl.dart';
import 'package:login_with_firebase/app/modules/my_application/src/authentication/data/use_cases/auth_signout_user_case_impl.dart';
import 'package:login_with_firebase/app/modules/my_application/src/authentication/data/use_cases/auth_signup_user_case_impl.dart';
import 'package:login_with_firebase/app/modules/my_application/src/authentication/domain/user_credencial_entity.dart';
import 'package:login_with_firebase/app/modules/my_application/src/authentication/external/cache/auth_local_cache_sp_impl.dart';
import 'package:login_with_firebase/app/modules/my_application/src/authentication/external/services/email_auth_service_impl.dart';
import 'package:login_with_firebase/app/modules/my_application/src/authentication/manager/auth_service_manager.dart';
import 'package:login_with_firebase/app/modules/my_application/src/authentication/presenter/controller/auth_store.dart';
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
  ];

  @override
  List<ModularRoute> routes = [
    ChildRoute('/', child: (ctx, args) => const Home(), guards: [HomeGuard()]),
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
