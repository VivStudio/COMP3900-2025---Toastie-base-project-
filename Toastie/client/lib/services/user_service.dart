import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastie/developer_mode.dart';
import 'package:toastie/entities/user/user_entity.dart';
import 'package:toastie/services/error_logs_service.dart';
import 'package:toastie/services/lab_report_service.dart';
import 'package:toastie/services/services.dart';
import 'package:toastie/repositories/user_repository.dart';
import 'package:toastie/services/trackers/food/dish_service.dart';
import 'package:toastie/services/trackers/food/meal_log_service.dart';
import 'package:toastie/services/trackers/medication_logs_service.dart';
import 'package:toastie/services/trackers/note_logs_service.dart';
import 'package:toastie/services/trackers/period_logs_service.dart';
import 'package:toastie/services/trackers/stool_logs_service.dart';
import 'package:toastie/services/trackers/symptom/symptom_logs_service.dart';

class UserService {
  UserService() {}

  Future<UserEntity?> getUserDetails() async {
    return locator<UserRepository>().getUser();
  }

  Future<int?> getUserSignUpDateTime() async {
    return await locator<UserRepository>().getUserSignUpDateTime();
  }

  /**
   * New user row will be created on sign up through the Supabase handle_new_user database function (email, uuid).
   * Here, we populate the row with other details.
   */
  populateNewUser({String name = ''}) {
    if (name.isEmpty || name == '') {
      // Get auth user metadata if name is not specified.
      name =
          locator<SupabaseClient>().auth.currentUser?.userMetadata?['name'] ??
              '';
    }

    DateTime now = DateTime.now();
    int unixTimestamp = now.millisecondsSinceEpoch ~/ 1000;

    DeviceType deviceType = DeviceType.other;
    if (Platform.isIOS) {
      deviceType = DeviceType.ios;
    } else if (Platform.isAndroid) {
      deviceType = DeviceType.android;
    }

    UserEntity userEntity = UserEntity(
      name: name,
      sign_up_date_time: unixTimestamp,
      device: deviceType,
      version: Platform.operatingSystemVersion,
    );
    locator<UserRepository>().updateUser(userEntity: userEntity);
  }

  updateUser({required UserEntity userEntity}) {
    locator<UserRepository>().updateUser(userEntity: userEntity);
  }

  // Risk: Non-atomic. Do it in a transaction instead (you can use Supabase function).
  // Make sure error is informative if it does fail.
  deleteUser() {
    if (!shouldDeleteAccount) {
      return;
    }

    locator<ErrorLogsService>().deleteAllErrors();

    // Trackers
    locator<SymptomLogsService>().deleteAllSymptoms();
    locator<MedicationLogsService>().deleteAllMedications();
    locator<StoolLogsService>().deleteAllStools();
    locator<PeriodLogsService>().deleteAllPeriods();
    locator<NoteLogsService>().deleteAllNotes();
    locator<MealLogService>().deleteAllMeals();
    locator<DishService>().deleteAllDishes();
    locator<LabReportService>().deleteAllLabReports();

    // Delete user last
    locator<UserRepository>().deleteUser();
  }
}

void main() async {}
