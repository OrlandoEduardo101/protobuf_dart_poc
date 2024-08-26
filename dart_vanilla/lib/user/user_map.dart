import '../generated/lib/proto/user.pb.dart';
import 'user.dart';

class UserMapper {
  static User fromProto(UserProto proto) {
    return User(
      id: proto.id,
      name: proto.name,
      email: proto.email,
    );
  }

  static UserProto toProto(User user) {
    return UserProto()
      ..id = user.id
      ..name = user.name
      ..email = user.email;
  }
}