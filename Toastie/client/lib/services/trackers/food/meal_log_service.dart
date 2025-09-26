import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastie/developer_mode.dart';
import 'package:toastie/entities/trackers/food/meal_log_entity.dart';
import 'package:toastie/repositories/trackers/food/meal_log_repository.dart';
import 'package:toastie/services/services.dart';
import 'package:toastie/utils/time/unix_date_range.dart';

class MealLogService {
  MealLogService() {
    _user = locator<SupabaseClient>().auth.currentUser!;
  }

  late User _user;

  Future<List<MealLogEntity?>> getMealDetailsForDay({
    required DateTime date,
  }) async {
    if (!shouldRunRpc) {
      return [];
    }

    UnixDateRange unixTime = convertDayToUnixDateRange(date: date);
    return locator<MealLogRepository>().getMealDetailsForDay(
      startOfDayUnix: unixTime.startTime,
      endOfDayUnix: unixTime.endTime,
    );
  }

  Future<List<MealLogEntity>> getMealDetailsForDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    if (!shouldRunRpc) {
      return [];
    }

    UnixDateRange unixTime = convertDateRangeToUnixDateRange(
      startDate: startDate,
      endDate: endDate,
    );
    return locator<MealLogRepository>().getMealDetailsForRange(
      startOfUnix: unixTime.startTime,
      endOfUnix: unixTime.endTime,
    );
  }

  Future<List<MealLogEntity>> getMealByIds({
    required Set<int> log_ids,
  }) async {
    if (!shouldRunRpc) {
      return [];
    }

    return locator<MealLogRepository>().getMealByIds(
      log_ids: log_ids,
    );
  }

  addMeal({
    required int unixDateTime,
    required MealType type,
    required String name,
    List<IngredientDetails> ingredientDetails = const [],
    List<int> dishIds = const [],
    List<String> photoIds = const [],
  }) async {
    if (!shouldRunRpc) {
      return;
    }

    await locator<MealLogRepository>().addMeal(
      mealLogEntity: MealLogEntity(
        user_id: _user.id,
        date_time: unixDateTime,
        type: type,
        name: name.toLowerCase(),
        ingredient_details: ingredientDetails,
        dish_ids: dishIds,
        photo_ids: photoIds,
      ),
    );
  }

  updateMealWithId({
    required int log_id,
    int? unixDateTime,
    String? name,
    MealType? type,
    List<IngredientDetails>? ingredientDetails,
    List<int>? dishIds,
    List<String>? photoIds,
  }) {
    if (!shouldRunRpc) {
      return;
    }

    MealLogEntity entity = MealLogEntity();
    entity.date_time ??= unixDateTime;
    entity.name ??= name?.toLowerCase();
    entity.type ??= type;
    entity.ingredient_details ??= ingredientDetails;
    entity.dish_ids ??= dishIds;
    entity.photo_ids ??= photoIds;

    locator<MealLogRepository>().updateMealWithId(
      log_id: log_id,
      mealLogEntity: entity,
    );
  }

  deleteMealWithId({required int log_id}) {
    if (!shouldRunRpc) {
      return;
    }

    locator<MealLogRepository>().deleteMealWithId(log_id: log_id);
  }

  deleteAllMeals() {
    if (!shouldRunRpc) {
      return;
    }

    locator<MealLogRepository>().deleteAllMeals();
  }
}
