import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastie/entities/trackers/symptom/symptom_creation_entity.dart';
import 'package:toastie/entities/trackers/symptom/symptoms_entity.dart';
import 'package:toastie/services/authentication/authentication_service.dart';
import 'package:toastie/services/services.dart';
import 'package:toastie/services/test_account.dart';
import 'package:toastie/utils/time/time_utils.dart';

class SymptomCreationRepository {
  SymptomCreationRepository() {
    _supabaseClient = locator<SupabaseClient>();
  }

  static final String _tableName = 'symptom_creation';
  late SupabaseClient _supabaseClient;

  void createSymptom({
    required SymptomsEntity symptom,
    required int unixDateTime,
  }) async {
    SymptomCreationEntity creationEntity = SymptomCreationEntity(
      symptom_id: symptom.id,
      name: symptom.name,
      date_time: unixDateTime,
    );
    await _supabaseClient.from(_tableName).insert(creationEntity.toJson());
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
    SymptomCreationRepository symptomCreationRepository =
        SymptomCreationRepository();

    SymptomsEntity entity = SymptomsEntity(name: 'test', id: 10);
    symptomCreationRepository.createSymptom(
      symptom: entity,
      unixDateTime: convertToUnixDateTime(DateTime.now()),
    );
  }
}
