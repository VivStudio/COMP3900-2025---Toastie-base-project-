import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastie/clients/audio_upload_client.dart';
import 'package:toastie/clients/lab_report_upload_client.dart';
import 'package:toastie/clients/photo_upload_client.dart';
import 'package:toastie/developer_mode.dart';
import 'package:toastie/repositories/error_logs_repository.dart';
import 'package:toastie/repositories/feedback_repository.dart';
import 'package:toastie/repositories/lab_report_repository.dart';
import 'package:toastie/repositories/trackers/food/dish_repository.dart';
import 'package:toastie/repositories/trackers/food/ingredient_repository.dart';
import 'package:toastie/repositories/trackers/food/meal_log_repository.dart';
import 'package:toastie/repositories/trackers/medication_logs_repository.dart';
import 'package:toastie/repositories/trackers/note_logs_repository.dart';
import 'package:toastie/repositories/trackers/period_logs_repository.dart';
import 'package:toastie/repositories/trackers/stool_logs_repository.dart';
import 'package:toastie/repositories/trackers/symptom/symptom_creation_repository.dart';
import 'package:toastie/repositories/trackers/symptom/symptom_logs_repository.dart';
import 'package:toastie/repositories/trackers/symptom/symptoms_repository.dart';
import 'package:toastie/repositories/trackers/weight_logs_repository.dart';
import 'package:toastie/repositories/user_repository.dart';
import 'package:toastie/services/authentication/authentication_service.dart';
import 'package:toastie/services/error_logs_service.dart';
import 'package:toastie/services/feedback_service.dart';
import 'package:toastie/services/lab_report_service.dart';
import 'package:toastie/services/location_storage_utils.dart';
import 'package:toastie/services/supabase/key.dart';
import 'package:toastie/services/supabase/supabase_service.dart';
import 'package:toastie/services/test_account.dart';
import 'package:toastie/services/trackers/food/dish_service.dart';
import 'package:toastie/services/trackers/food/ingredient_service.dart';
import 'package:toastie/services/trackers/food/meal_log_service.dart';
import 'package:toastie/services/trackers/medication_logs_service.dart';
import 'package:toastie/services/trackers/note_logs_service.dart';
import 'package:toastie/services/trackers/period_logs_service.dart';
import 'package:toastie/services/trackers/stool_logs_service.dart';
import 'package:toastie/services/trackers/symptom/symptom_logs_service.dart';
import 'package:toastie/services/trackers/weight_logs_service.dart';
import 'package:toastie/services/user_service.dart';

final GetIt locator = GetIt.instance;

Future setUpApp() async {
  await setUpAuthentication();
  clearCache();
  await addSessionToCache();

  _setUpClients();
  _setUpRepositories();
  _setUpServices();
}

Future oneTimeSupabaseInitialisation() async {
  if (!locator.isRegistered<SupabaseService>()) {
    locator.registerLazySingleton<SupabaseService>(() => SupabaseService());
    await locator<SupabaseService>().initialize();
  }
}

Future setUpAuthentication() async {
  if (!locator.isRegistered<SharedPreferences>()) {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    locator.registerSingleton<SharedPreferences>(preferences);
  }

  if (!locator.isRegistered<AuthenticationService>()) {
    locator.registerLazySingleton<AuthenticationService>(
      () => AuthenticationService(),
    );
  }

  if (!locator.isRegistered<SupabaseClient>()) {
    locator.registerLazySingleton<SupabaseClient>(
      () => SupabaseClient(supabaseUrl, supabaseKey),
    );
  }

  if (shouldAuthenticateWithToastie &&
      locator<SupabaseClient>().auth.currentUser == null) {
    // This is required because the user needs to be authenticated before using any of the services.
    // shouldAuthenticateWithToastie should ONLY be true on dev.
    await locator<AuthenticationService>().emailLogIn(
      email: toastieEmail,
      password: toastiePassword,
    );
  }

  _setUpErrorLogging();
}

void _setUpErrorLogging() {
  if (!locator.isRegistered<ErrorLogsRepository>()) {
    locator.registerLazySingleton<ErrorLogsRepository>(
      () => ErrorLogsRepository(),
    );
  }

  if (!locator.isRegistered<ErrorLogsService>()) {
    locator.registerLazySingleton<ErrorLogsService>(() => ErrorLogsService());
  }
}

void _setUpServices() {
  // Sort in alphabetical order.
  if (!locator.isRegistered<DishService>()) {
    locator.registerLazySingleton<DishService>(() => DishService());
  }

  if (!locator.isRegistered<ErrorLogsService>()) {
    locator.registerLazySingleton<ErrorLogsService>(() => ErrorLogsService());
  }

  if (!locator.isRegistered<FeedbackService>()) {
    locator.registerLazySingleton<FeedbackService>(() => FeedbackService());
  }

  if (!locator.isRegistered<IngredientService>()) {
    locator.registerLazySingleton<IngredientService>(() => IngredientService());
  }

  if (!locator.isRegistered<LabReportService>()) {
    locator.registerLazySingleton<LabReportService>(() => LabReportService());
  }

  if (!locator.isRegistered<MealLogService>()) {
    locator.registerLazySingleton<MealLogService>(() => MealLogService());
  }

  if (!locator.isRegistered<MedicationLogsService>()) {
    locator.registerLazySingleton<MedicationLogsService>(
      () => MedicationLogsService(),
    );
  }

  if (!locator.isRegistered<NoteLogsService>()) {
    locator.registerLazySingleton<NoteLogsService>(() => NoteLogsService());
  }

  if (!locator.isRegistered<PeriodLogsService>()) {
    locator.registerLazySingleton<PeriodLogsService>(() => PeriodLogsService());
  }

  if (!locator.isRegistered<StoolLogsService>()) {
    locator.registerLazySingleton<StoolLogsService>(() => StoolLogsService());
  }

  if (!locator.isRegistered<SymptomLogsService>()) {
    locator
        .registerLazySingleton<SymptomLogsService>(() => SymptomLogsService());
  }

  if (!locator.isRegistered<WeightLogsService>()) {
    locator.registerLazySingleton<WeightLogsService>(() => WeightLogsService());
  }

  // Create user service last since it relies on other services to be created.
  if (!locator.isRegistered<UserService>()) {
    locator.registerLazySingleton<UserService>(() => UserService());
  }
}

void _setUpClients() {
  // Sort in alphabetical order.
  if (!locator.isRegistered<AudioUploadClient>()) {
    locator.registerLazySingleton<AudioUploadClient>(() => AudioUploadClient());
  }

  if (!locator.isRegistered<LabReportUploadClient>()) {
    locator.registerLazySingleton<LabReportUploadClient>(
      () => LabReportUploadClient(),
    );
  }

  if (!locator.isRegistered<PhotoUploadClient>()) {
    locator.registerLazySingleton<PhotoUploadClient>(() => PhotoUploadClient());
  }
}

void _setUpRepositories() {
  // Sort in alphabetical order.
  if (!locator.isRegistered<DishRepository>()) {
    locator.registerLazySingleton<DishRepository>(() => DishRepository());
  }

  if (!locator.isRegistered<ErrorLogsRepository>()) {
    locator.registerLazySingleton<ErrorLogsRepository>(
      () => ErrorLogsRepository(),
    );
  }

  if (!locator.isRegistered<FeedbackRepository>()) {
    locator.registerLazySingleton<FeedbackRepository>(
      () => FeedbackRepository(),
    );
  }

  if (!locator.isRegistered<IngredientRepository>()) {
    locator.registerLazySingleton<IngredientRepository>(
      () => IngredientRepository(),
    );
  }

  if (!locator.isRegistered<LabReportRepository>()) {
    locator.registerLazySingleton<LabReportRepository>(
      () => LabReportRepository(),
    );
  }

  if (!locator.isRegistered<MealLogRepository>()) {
    locator.registerLazySingleton<MealLogRepository>(() => MealLogRepository());
  }

  if (!locator.isRegistered<MedicationLogsRepository>()) {
    locator.registerLazySingleton<MedicationLogsRepository>(
      () => MedicationLogsRepository(),
    );
  }

  if (!locator.isRegistered<NoteLogsRepository>()) {
    locator.registerLazySingleton<NoteLogsRepository>(
      () => NoteLogsRepository(),
    );
  }

  if (!locator.isRegistered<PeriodLogsRepository>()) {
    locator.registerLazySingleton<PeriodLogsRepository>(
      () => PeriodLogsRepository(),
    );
  }

  if (!locator.isRegistered<StoolLogsRepository>()) {
    locator.registerLazySingleton<StoolLogsRepository>(
      () => StoolLogsRepository(),
    );
  }

  if (!locator.isRegistered<SymptomCreationRepository>()) {
    locator.registerLazySingleton<SymptomCreationRepository>(
      () => SymptomCreationRepository(),
    );
  }

  if (!locator.isRegistered<SymptomLogsRepository>()) {
    locator.registerLazySingleton<SymptomLogsRepository>(
      () => SymptomLogsRepository(),
    );
  }

  if (!locator.isRegistered<SymptomsRepository>()) {
    locator.registerLazySingleton<SymptomsRepository>(
      () => SymptomsRepository(),
    );
  }

  if (!locator.isRegistered<WeightLogsRepository>()) {
    locator.registerLazySingleton<WeightLogsRepository>(
      () => WeightLogsRepository(),
    );
  }

  // Create user repository last since it relies on other repositories to be created.
  if (!locator.isRegistered<UserRepository>()) {
    locator.registerLazySingleton<UserRepository>(() => UserRepository());
  }
}

Future resetServices() async {
  await locator.reset();
  await setUpAuthentication();
}
