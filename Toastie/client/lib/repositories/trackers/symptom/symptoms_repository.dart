import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastie/entities/trackers/symptom/symptoms_entity.dart';
import 'package:toastie/services/authentication/authentication_service.dart';
import 'package:toastie/services/services.dart';
import 'package:toastie/services/test_account.dart';

class SymptomsRepository {
  SymptomsRepository() {
    _supabaseClient = locator<SupabaseClient>();
  }

  static final String _tableName = 'symptoms';
  late SupabaseClient _supabaseClient;

  Future<SymptomsEntity?> createSymptom({required String name}) async {
    SymptomsEntity entity = SymptomsEntity(name: name);
    final List response =
        await _supabaseClient.from(_tableName).insert(entity.toJson()).select();
    SymptomsEntity? createdEntity = null;
    if (response.first != null) {
      createdEntity = SymptomsEntity.fromJson(response.first);
    }
    return createdEntity;
  }

  Future<SymptomsEntity?> getSymptomThatMatchesName({
    required String name,
  }) async {
    SymptomsEntity? symptomsEntity = null;

    final List response = await _supabaseClient
        .from(_tableName)
        .select()
        .eq('name', name)
        .limit(1);

    if (response.length == 1) {
      symptomsEntity = SymptomsEntity.fromJson(response.first);
    }
    return symptomsEntity;
  }

  Future<SymptomsEntity?> getSymptomThatMatchesAlias({
    required String aliasName,
  }) async {
    SymptomsEntity? symptomsEntity = null;

    final List response = await _supabaseClient
        .from(_tableName)
        .select()
        .contains('aliases', [aliasName]).limit(1);

    if (response.length == 1) {
      symptomsEntity = SymptomsEntity.fromJson(response.first);
    }
    return symptomsEntity;
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
    // SymptomsRepository symptomsRepository = SymptomsRepository();

    // SymptomsEntity? symptom = await symptomsRepository
    //     .getSymptomThatMatchesName(name: 'stomach pain');
    // SymptomsEntity? symptom = await symptomsRepository
    //     .getSymptomThatMatchesAlias(aliasName: 'stomach ache');
    // print('symptom $symptom');

    // SymptomsEntity? symptom =
    //     await symptomsRepository.createSymptom(name: 'headache');
    // print(symptom);
  }
}
