import 'package:flutter/material.dart';
import 'package:toastie/entities/trackers/food/meal_log_entity.dart';
import 'package:toastie/themes/colors.dart';

final Map<MealType, MaterialColor> mealTypeMap = {
  MealType.breakfast: accentPink,
  MealType.lunch: accentYellow,
  MealType.dinner: success,
  MealType.snack: info,
};
