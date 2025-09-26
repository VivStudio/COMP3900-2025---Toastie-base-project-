import 'package:toastie/developer_mode.dart';
import 'package:toastie/entities/trackers/food/ingredient_entity.dart';
import 'package:toastie/repositories/trackers/food/ingredient_repository.dart';
import 'package:toastie/services/services.dart';

class IngredientService {
  IngredientService() {
    _ingredientRepository = locator<IngredientRepository>();
  }
  late IngredientRepository _ingredientRepository;

  Future<IngredientEntity> getIngredientWithId({
    required int log_id,
    String? name,
  }) async {
    if (!shouldRunRpc) {
      return IngredientEntity(id: -1, name: 'fake data');
    }

    return _ingredientRepository.getIngredientWithId(
      log_id: log_id,
    );
  }

  /**
   * Determines whether to create a new ingredient or add it as an alias of an existing ingredient.
   * 1. Try to string match on ingredient name.
   * 2. Try to string match on ingredient alias name.
   * 3. Create new ingredient if none of the above matches. Newly created ingredient will also be added to the ingredients_creation table to allow us to do proper categorisation and backfill later.
   */
  Future<IngredientEntity> createOrAddIngredient({
    required String name,
    required int unixDateTime,
  }) async {
    if (!shouldRunRpc) {
      return IngredientEntity(id: -1, name: 'fake data');
    }

    // Ingredient name must be in lower case to match database entries.
    String lowerCaseName = name.toLowerCase();

    // Try to string match on ingredient name.
    IngredientEntity? nameMatch = await _ingredientRepository
        .getIngredientThatMatchesName(name: lowerCaseName);
    if (nameMatch != null) {
      return nameMatch;
    }

    // Try to string match on ingredient alias name.
    IngredientEntity? aliasMatch = await _ingredientRepository
        .getIngredientThatMatchesAlias(aliasName: lowerCaseName);
    if (aliasMatch != null) {
      return aliasMatch;
    }

    // Otherwise, create new ingredient entry.
    IngredientEntity entity = await _ingredientRepository.createIngredient(
      name: lowerCaseName,
      unixDateTime: unixDateTime,
    );
    return entity;
  }

  updateIngredientWithId({
    required int log_id,
    String? name,
  }) {
    if (!shouldRunRpc) {
      return;
    }

    IngredientEntity entity = IngredientEntity();
    entity.name ??= name?.toLowerCase();

    _ingredientRepository.updateIngredientWithId(
      log_id: log_id,
      ingredientEntity: entity,
    );
  }
}

void main() async {
  // await setUpApp();

  // AuthenticationService authenticationService = AuthenticationService();
  // User? user = await authenticationService.emailLogIn(
  //   email: toastieEmail,
  //   password: toastiePassword,
  // );
  // if (user != null) {
  //   IngredientService ingredientService = IngredientService();

  //   DateTime now = DateTime.now();
  //   int unixDateTime = convertToUnixDateTime(now);
  //   IngredientEntity ingredientEntity =
  //       await ingredientService.createOrAddIngredient(
  //     name: 'milk 1',
  //     unixDateTime: unixDateTime,
  //   );
  // }
}
