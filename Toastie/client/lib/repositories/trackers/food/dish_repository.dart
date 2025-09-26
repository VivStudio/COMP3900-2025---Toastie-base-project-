import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastie/entities/trackers/food/dish_entity.dart';
import 'package:toastie/services/services.dart';

class DishRepository {
  DishRepository() {
    _supabaseClient = locator<SupabaseClient>();
    _userId = _supabaseClient.auth.currentUser!.id;
  }
  static final String _tableName = 'dishes';
  late SupabaseClient _supabaseClient;
  late String _userId;

  Future<List<DishEntity?>?> getDishes() async {
    List<DishEntity?>? dishes = [];
    await _supabaseClient
        .from(_tableName)
        .select()
        .eq('user_id', _userId)
        .then((response) {
      response.forEach((element) {
        DishEntity entity = DishEntity.fromJson(element);
        dishes.add(entity);
      });
    });
    return dishes;
  }

  Future<DishEntity> getDishWithId({
    required int log_id,
  }) async {
    DishEntity dishEntity = DishEntity();
    final List response = await _supabaseClient
        .from(_tableName)
        .select()
        .eq('user_id', _userId)
        .eq('log_id', log_id);
    if (response.length >= 1) {
      dishEntity = DishEntity.fromJson(response.first);
    }
    return dishEntity;
  }

  addDish({required DishEntity dishEntity}) async {
    await _supabaseClient.from(_tableName).insert(dishEntity.toJson());
  }

  updateDishWithId({
    required int log_id,
    required DishEntity dishEntity,
  }) async {
    await _supabaseClient
        .from(_tableName)
        .update(dishEntity.toJson())
        .eq('user_id', _userId)
        .eq('log_id', log_id);
  }

  deleteDishWithId({required int log_id}) async {
    await _supabaseClient
        .from(_tableName)
        .delete()
        .eq('user_id', _userId)
        .eq('log_id', log_id);
  }

  deleteAllDishes() async {
    await _supabaseClient.from(_tableName).delete().eq('user_id', _userId);
  }
}

void main() async {}
