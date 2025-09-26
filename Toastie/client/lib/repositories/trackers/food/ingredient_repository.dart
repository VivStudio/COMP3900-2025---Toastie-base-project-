import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastie/entities/trackers/food/ingredient_creation_entity.dart';
import 'package:toastie/entities/trackers/food/ingredient_entity.dart';
import 'package:toastie/services/services.dart';

class IngredientRepository {
  IngredientRepository() {
    _supabaseClient = locator<SupabaseClient>();
  }
  static final String _tableName = 'ingredients';
  // Only used for creating new ingredients.
  static final String _ingredientsCreationTableName = 'ingredient_creation';
  late SupabaseClient _supabaseClient;

  Future<IngredientEntity?> getIngredientThatMatchesName({
    required String name,
  }) async {
    IngredientEntity? ingredientEntity = null;

    final List response = await _supabaseClient
        .from(_tableName)
        .select()
        .eq('name', name)
        .limit(1);

    if (response.length == 1) {
      ingredientEntity = IngredientEntity.fromJson(response.first);
    }
    return ingredientEntity;
  }

  Future<IngredientEntity?> getIngredientThatMatchesAlias({
    required String aliasName,
  }) async {
    IngredientEntity? ingredientEntity = null;

    final List response = await _supabaseClient
        .from(_tableName)
        .select()
        .contains('aliases', [aliasName]).limit(1);

    if (response.length == 1) {
      ingredientEntity = IngredientEntity.fromJson(response.first);
    }
    return ingredientEntity;
  }

  Future<IngredientEntity> getIngredientWithId({
    required int log_id,
  }) async {
    IngredientEntity ingredientEntity = IngredientEntity();
    final List response =
        await _supabaseClient.from(_tableName).select().eq('log_id', log_id);
    if (response.length >= 1) {
      ingredientEntity = IngredientEntity.fromJson(response.first);
    }
    return ingredientEntity;
  }

  Future<IngredientEntity> createIngredient({
    required String name,
    required int unixDateTime,
  }) async {
    // Create new ingredient and get details of the new entity added.
    IngredientEntity entity = IngredientEntity(name: name);
    final List response =
        await _supabaseClient.from(_tableName).insert(entity.toJson()).select();
    IngredientEntity? lastCreatedEntity = null;
    if (response.first != null) {
      lastCreatedEntity = IngredientEntity.fromJson(response.first);
    }

    // Add new ingredient to ingredients_creation table with details from ingredient.
    IngredientCreationEntity ingredientCreation = IngredientCreationEntity(
      ingredient_id: lastCreatedEntity?.id,
      name: lastCreatedEntity?.name,
      date_time: unixDateTime,
    );
    await _supabaseClient
        .from(_ingredientsCreationTableName)
        .insert(ingredientCreation.toJson())
        .select();

    return lastCreatedEntity!;
  }

  updateIngredientWithId({
    required int log_id,
    required IngredientEntity ingredientEntity,
  }) async {
    await _supabaseClient
        .from(_tableName)
        .update(ingredientEntity.toJson())
        .eq('log_id', log_id);
  }
}
