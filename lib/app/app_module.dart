import 'package:flutter_modular/flutter_modular.dart';

import 'modules/my_application/my_application.dart';

class AppModule extends Module {
  @override
  List<Bind> binds = [];
  @override
  List<ModularRoute> routes = [
    ModuleRoute(
      '/',
      module: MyApplication(),
    ),
  ];
}
