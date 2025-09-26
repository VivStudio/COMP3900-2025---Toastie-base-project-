import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastie/entities/error/error_logs_entity.dart';
import 'package:toastie/services/authentication/authentication_service.dart';
import 'package:toastie/services/services.dart';
import 'package:toastie/services/test_account.dart';

class ErrorLogsRepository {
  ErrorLogsRepository() {
    _supabaseClient = locator<SupabaseClient>();
  }
  static final String _tableName = 'error_logs';
  late SupabaseClient _supabaseClient;

  Future addErrorLog({
    required ErrorLogsEntity errorLogsEntity,
  }) async {
    await _supabaseClient.from(_tableName).insert(errorLogsEntity.toJson());
  }

  // IDK why but it doesn't actually delete from the database.
  deleteAllErrors() async {
    String? userId = _supabaseClient.auth.currentUser!.id;
    await _supabaseClient.from(_tableName).delete().eq('user_id', userId);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await oneTimeSupabaseInitialisation();
  await setUpApp();
  User? user = await locator<AuthenticationService>().emailLogIn(
    email: toastieEmail,
    password: toastiePassword,
  );

  if (user != null) {
    // Add
    // int unixTimestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    // locator<ErrorLogsRepository>().addErrorLog(
    //   errorLogsEntity: ErrorLogsEntity(
    //     user_id: user.id,
    //     date_time: unixTimestamp,
    //     page_name: PageName.authentication,
    //     error_message: 'test',
    //   ),
    // );

    // locator<ErrorLogsRepository>().addErrorLog(
    //   errorLogsEntity: ErrorLogsEntity(
    //     user_id: null,
    //     date_time: unixTimestamp,
    //     page_name: PageName.authentication,
    //     error_message: 'test',
    //   ),
    // );

    // Delete
    locator<ErrorLogsRepository>().deleteAllErrors();
  }
}
