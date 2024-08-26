import '../generated/lib/proto/user.pb.dart';

import 'user.dart';

abstract class ProtoMapper<T, P> {
  T fromProto(P proto);
  P toProto(T entity);
}

class UserProtoMapper implements ProtoMapper<User, UserProto> {
  @override
  User fromProto(UserProto proto) {
    return User(
      id: proto.id,
      name: proto.name,
      email: proto.email,
    );
  }

  @override
  UserProto toProto(User user) {
    return UserProto()
      ..id = user.id
      ..name = user.name
      ..email = user.email;
  }
}
