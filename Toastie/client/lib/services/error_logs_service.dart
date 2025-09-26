import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastie/entities/error/error_logs_entity.dart';
import 'package:toastie/repositories/error_logs_repository.dart';
import 'package:toastie/services/authentication/authentication_service.dart';
import 'package:toastie/services/services.dart';
import 'package:toastie/services/test_account.dart';
import 'package:toastie/utils/time/time_utils.dart';

class ErrorLogsService {
  ErrorLogsService() {
    _errorLogsRepository = locator<ErrorLogsRepository>();
  }
  late ErrorLogsRepository _errorLogsRepository;

  Future addErrorLog({
    required PageName pageName,
    required String errorMessage,
    String?
        userId, // Optional for error messages that will be logged before the user logs in.
  }) async {
    DateTime dateTime = DateTime.now();
    await _errorLogsRepository.addErrorLog(
      errorLogsEntity: ErrorLogsEntity(
        user_id: userId,
        date_time: convertToUnixDateTime(dateTime),
        page_name: pageName,
        error_message: errorMessage,
      ),
    );
  }

  deleteAllErrors() {
    _errorLogsRepository.deleteAllErrors();
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
    locator<ErrorLogsService>().addErrorLog(
      pageName: PageName.authentication,
      errorMessage: 'test',
    );

    // Delete
    // analyticsRepository.deleteAllAnalytics();
  }
}
