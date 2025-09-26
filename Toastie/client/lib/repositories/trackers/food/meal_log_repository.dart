import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastie/entities/trackers/food/meal_log_entity.dart';
import 'package:toastie/services/services.dart';

class MealLogRepository {
  MealLogRepository() {
    _supabaseClient = locator<SupabaseClient>();
    _userId = _supabaseClient.auth.currentUser!.id;
  }
  static final String _tableName = 'meal_logs';
  late SupabaseClient _supabaseClient;
  late String _userId;

  Future<List<MealLogEntity?>> getMealDetailsForDay({
    required int startOfDayUnix,
    required int endOfDayUnix,
  }) async {
    List<MealLogEntity?>? mealLogs = [];
    await _supabaseClient
        .from(_tableName)
        .select()
        .eq('user_id', _userId)
        .gte('date_time', startOfDayUnix)
        .lte('date_time', endOfDayUnix)
        .order('date_time', ascending: true)
        .then((response) {
      response.forEach((element) {
        MealLogEntity entity = MealLogEntity.fromJson(element);
        mealLogs.add(entity);
      });
    });
    return mealLogs;
  }

  Future<List<MealLogEntity>> getMealDetailsForRange({
    required int startOfUnix,
    required int endOfUnix,
  }) async {
    List<MealLogEntity> meals = [];
    await _supabaseClient
        .from(_tableName)
        .select()
        .eq('user_id', _userId)
        .gte('date_time', startOfUnix)
        .lte('date_time', endOfUnix)
        .then((response) {
      response.forEach((element) {
        MealLogEntity entity = MealLogEntity.fromJson(element);
        meals.add(entity);
      });
    });
    return meals;
  }

  Future<List<MealLogEntity>> getMealByIds({
    required Set<int> log_ids,
  }) async {
    final result = await _supabaseClient
        .from(_tableName)
        .select()
        .eq('user_id', _userId)
        .in_('log_id', log_ids.toList()) as List;
    if (result.length == 0) {
      return [];
    }

    List<MealLogEntity> entities = [];
    result.forEach((entry) => entities.add(MealLogEntity.fromJson(entry)));
    return entities;
  }

  Future<MealLogEntity?> addMeal({required MealLogEntity mealLogEntity}) async {
    final result = await _supabaseClient
        .from(_tableName)
        .insert(mealLogEntity.toJson())
        .select();
    if (result != null && result.length > 0) {
      return MealLogEntity.fromJson(result.first);
    }
    return null;
  }

  updateMealWithId({
    required int log_id,
    required MealLogEntity mealLogEntity,
  }) async {
    await _supabaseClient
        .from(_tableName)
        .update(mealLogEntity.toJson())
        .eq('user_id', _userId)
        .eq('log_id', log_id);
  }

  deleteMealWithId({required int log_id}) async {
    await _supabaseClient
        .from(_tableName)
        .delete()
        .eq('user_id', _userId)
        .eq('log_id', log_id);
  }

  deleteAllMeals() async {
    await _supabaseClient.from(_tableName).delete().eq('user_id', _userId);
  }
}

void main() async {}
