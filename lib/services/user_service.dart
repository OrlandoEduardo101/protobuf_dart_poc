import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:protobuf_dart_poc/generated/lib/proto/user.pb.dart';

import '../data_mock.dart';
import '../user/user.dart';
import '../user/user_proto_mapper.dart';
import 'database_service.dart';

/// This file contains the implementation of the UserService class.
///
/// The UserService class is responsible for simulating API requests related to user data.
/// It acts as a repository, providing methods to fetch, create, update, and delete user data.
/// This class is used to abstract the data layer and provide a clean interface for interacting with user data.
///
///

class UserService {
  final ProtoMapper<User, UserProto> userMapper;

  final DatabaseService db;

  UserService(this.userMapper, this.db);

  User getUser(String id) {
    final userJson = findUserById(id);
    final userProto = UserProto.fromJson(jsonEncode(userJson));
    return userMapper.fromProto(userProto);
  }

  /// conver User object to Buffer and save it to the local database.
  void saveUserProto(UserProto userProto) {
    final buffer = userProto.writeToBuffer();

    db.saveUser(buffer, userProto.id);
    log('Saved user ${userProto.name} to local database');
  }

  /// Retrieves a user buffer from the local database and decodes it to a UserProto object.
  ///
  UserProto? getUserProto(String id) {
    final result = db.getUser(id) ?? [];

    if (result.isNotEmpty) {
      final protoBuffer = result as Uint8List;
      log('Retrieved user buffer from local database');
      return UserProto.fromBuffer(protoBuffer);
    } else {
      return null; // Retorna null se o usuário não for encontrado
    }
  }
}
