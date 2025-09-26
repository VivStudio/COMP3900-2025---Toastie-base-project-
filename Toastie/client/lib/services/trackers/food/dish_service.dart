import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastie/developer_mode.dart';
import 'package:toastie/entities/trackers/food/dish_entity.dart';
import 'package:toastie/repositories/trackers/food/dish_repository.dart';
import 'package:toastie/services/authentication/authentication_service.dart';
import 'package:toastie/services/services.dart';
import 'package:toastie/utils/time/time_utils.dart';

class DishService {
  DishService() {
    _supabaseClient = locator<SupabaseClient>();
    _dishRepository = locator<DishRepository>();
    _user = _supabaseClient.auth.currentUser!;
  }
  late SupabaseClient _supabaseClient;
  late DishRepository _dishRepository;
  late User _user;

  Future<List<DishEntity?>?> getDishes() async {
    return _dishRepository.getDishes();
  }

  Future<DishEntity> getDishWithId({
    required int log_id,
    DateTime? dateTime,
    String? name,
    List<int>? ingredientIds,
  }) async {
    if (!shouldRunRpc) {
      return DishEntity(
        user_id: 'user_id',
        log_id: 1,
        date_time: 1,
        name: 'Avocado toast',
        summary: 'Avocado, toast',
        ingredient_ids: [2, 3],
      );
    }

    DishEntity entity = DishEntity();
    if (dateTime != null) {
      entity.date_time = convertToUnixDateTime(dateTime);
    }
    entity.name ??= name?.toLowerCase();
    entity.ingredient_ids ??= ingredientIds;

    return _dishRepository.getDishWithId(
      log_id: log_id,
    );
  }

  addIngredient({
    required DateTime dateTime,
    required String name,
    required List<int> ingredientIds,
  }) {
    _dishRepository.addDish(
      dishEntity: DishEntity(
        user_id: _user.id,
        date_time: convertToUnixDateTime(dateTime),
        name: name.toLowerCase(),
        ingredient_ids: ingredientIds,
      ),
    );
  }

  updateDishWithId({
    required int log_id,
    DateTime? dateTime,
    String? name,
    List<int>? ingredientIds,
  }) {
    DishEntity entity = DishEntity();
    if (dateTime != null) {
      entity.date_time = convertToUnixDateTime(dateTime);
    }
    entity.name ??= name?.toLowerCase();
    entity.ingredient_ids ??= ingredientIds;

    _dishRepository.updateDishWithId(
      log_id: log_id,
      dishEntity: entity,
    );
  }

  deleteDishWithId({required int log_id}) {
    _dishRepository.deleteDishWithId(log_id: log_id);
  }

  deleteAllDishes() {
    _dishRepository.deleteAllDishes();
  }
}

void main() async {
  AuthenticationService authenticationService = AuthenticationService();
  User? user = await authenticationService.emailLogIn(
    email: 'hello@toastie.au',
    password: '0910lAVl!',
  );
  if (user != null) {}
}
