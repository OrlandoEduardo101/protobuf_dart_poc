import 'dart:convert';

import 'package:protobuf_dart_poc/generated/lib/proto/user.pb.dart';

import '../data_mock.dart';
import '../user/user.dart';
import '../user/user_proto_mapper.dart';

class UserService {
  final ProtoMapper<User, UserProto> userMapper;

  UserService(this.userMapper);

  User getUser(String id) {
    final userJson = findUserById(id);
    final userProto = UserProto.fromJson(jsonEncode(userJson));
    return userMapper.fromProto(userProto);
  }

  User getUserFromBuffer(String id) {
    final userJson = findUserByIdBuffer(id) ?? [0];
    final userProto = UserProto.fromBuffer(userJson);
    return userMapper.fromProto(userProto);
  }
}
