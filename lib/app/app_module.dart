import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:login_with_firebase/app/modules/my_application/src/books/data/use_cases/create_book_use_case_impl.dart';
import 'package:login_with_firebase/app/modules/my_application/src/books/domain/use_cases_interfaces/IDeleteBookUseCase.dart';
import 'package:login_with_firebase/app/modules/my_application/src/books/domain/use_cases_interfaces/IGetBookByIdUseCase.dart';
import 'package:login_with_firebase/app/modules/my_application/src/books/domain/use_cases_interfaces/IUpdateBookUseCase.dart';

import 'modules/my_application/my_application.dart';
import 'modules/my_application/src/books/data/services/book_firestore_service_impl.dart';
import 'modules/my_application/src/books/data/use_cases/delete_book_use_case_impl.dart';
import 'modules/my_application/src/books/data/use_cases/get_book_by_id_use_case.dart';
import 'modules/my_application/src/books/data/use_cases/update_book_use_case_impl.dart';
import 'modules/my_application/src/books/domain/book_services_interfaces/book_service.dart';
import 'modules/my_application/src/books/domain/use_cases_interfaces/ICreateBookUseCase.dart';

class AppModule extends Module {
  @override
  final List<Bind> binds = [
    
    ];
  @override
  List<ModularRoute> routes = [
    ModuleRoute(
      '/',
      module: MyApplication(),
    ),
  ];
}
