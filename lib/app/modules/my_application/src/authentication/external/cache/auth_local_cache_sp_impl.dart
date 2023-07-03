import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:login_with_firebase/app/modules/my_application/src/authentication/domain/user_credencial_entity.dart';
import 'package:login_with_firebase/app/modules/my_application/src/authentication/domain/user_credencial_mapper.dart';
import 'package:login_with_firebase/app/modules/my_application/src/authentication/presenter/cache_interfaces/auth_local_cache_contract.dart';
import 'package:login_with_firebase/app/modules/my_application/src/common/errors/errors_classes.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/errors/errors_messagens.dart';

class AuthLocalCacheSharedPrefsImpl implements IAuthLocalCache {
  //final _completer = Completer<SharedPreferences>();
  late SharedPreferences _sp;

  final String _key = 'USER_DATA';

  AuthLocalCacheSharedPrefsImpl() {
    // print("Construtor");
    _initSharedPreferences();
    // print("saiu init");
  }

  Future _initSharedPreferences() async {
    // print('entrou init');
    _sp = await SharedPreferences.getInstance();
    //  if (!_completer.isCompleted) _completer.complete(_sp);
    // print("passou por aqui");
    //return;
  }

  @override
  Future<Either<Failure, bool>> delete(
      {required UserCredentialApp user}) async {
    _sp = await SharedPreferences.getInstance();
    try {
      await _sp.remove(_key);
      return const Right(true);
    } catch (e) {
      return Left(
        UserSharedPrefencesError(MessagesError.deleteSharedP),
      );
    }

    //return Left(DefaultError(MessagesError.defaultError));
  }

  @override
  Future<Either<Failure, UserCredentialApp>> fetch() async {
    _sp = await SharedPreferences.getInstance();
    try {
      final result = _sp.getString(_key);

      if (result == null || result.isEmpty) {
        return Left(
          UserSharedPrefencesError(MessagesError.saveSharedPKeyNotFound),
        );
      }

      return Right(UserCredecialMapper.jsonToEnsity(result));
    } catch (e) {
      return Left(
        UserSharedPrefencesError(MessagesError.fetchSharedP),
      );
    }

    //return Left(DefaultError(MessagesError.defaultError));
  }

  @override
  Future<Either<Failure, bool>> save({required UserCredentialApp user}) async {
    _sp = await SharedPreferences.getInstance();
    try {
      var value = UserCredecialMapper.entityToJson(user);
      await _sp.setString(_key, value);
      return const Right(true);
    } catch (e) {
      return Left(
        UserSharedPrefencesError(MessagesError.saveSharedP),
      );
    }

    //return Left(DefaultError(MessagesError.defaultError));
  }
}
