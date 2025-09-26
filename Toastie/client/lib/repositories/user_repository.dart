import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastie/entities/user/user_entity.dart';
import 'package:toastie/services/authentication/authentication_service.dart';
import 'package:toastie/services/services.dart';
import 'package:toastie/services/test_account.dart';

class UserRepository {
  UserRepository() {
    _supabaseClient = locator<SupabaseClient>();
    _userId = _supabaseClient.auth.currentUser!.id;
  }

  static final String _tableName = 'users';
  late SupabaseClient _supabaseClient;
  late String _userId;

  Future<UserEntity?> getUser() async {
    UserEntity? userEntity = null;
    await _supabaseClient
        .from(_tableName)
        .select()
        .eq('user_id', _userId)
        .single()
        .then((response) {
      userEntity = UserEntity.fromJson(response);
    });
    return userEntity;
  }

  Future<int?> getUserSignUpDateTime() async {
    final result = await _supabaseClient
        .from(_tableName)
        .select('sign_up_date_time')
        .eq('user_id', _userId)
        .maybeSingle();
    UserEntity entity = UserEntity.fromJson(result);
    return entity.sign_up_date_time;
  }

  addUser({required UserEntity userEntity}) async {
    await _supabaseClient.from(_tableName).insert(userEntity.toJson());
  }

  updateUser({required UserEntity userEntity}) async {
    await _supabaseClient
        .from(_tableName)
        .update(userEntity.toJson())
        .eq('user_id', _userId);
  }

  deleteUser() async {
    await _supabaseClient.from(_tableName).delete().eq('user_id', _userId);
  }
}

void main() async {
  await setUpApp();

  AuthenticationService authenticationService = AuthenticationService();
  User? user = await authenticationService.emailLogIn(
    email: toastieEmail,
    password: toastiePassword,
  );

  if (user != null) {
    // Get
    // UserEntity? userEntity = await userRepository.getUser();

    // Add
    // DateTime now = DateTime.now();
    // int unixTimestamp = now.millisecondsSinceEpoch ~/ 1000;
    // userRepository.addUser(
    //     userEntity: UserEntity(
    //   user_id: toastieUserId,
    //   name: toastieEmail,
    //   sign_up_date: unixTimestamp,
    //   device: DEVICE_TYPE.IOS,
    //   version: 12.5,
    // ));

    // Update
    // userRepository.updateUser(
    //   userEntity: UserEntity(version: 3),
    // );

    // Delete
    // userRepository.deleteUser();
  }
}
