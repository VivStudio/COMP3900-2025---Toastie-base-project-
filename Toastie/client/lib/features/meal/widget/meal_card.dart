import 'package:flutter/material.dart';
import 'package:toastie/clients/photo_upload_client.dart';
import 'package:toastie/components/card/clickable_card/clickable_summary_card.dart';
import 'package:toastie/entities/trackers/food/meal_log_entity.dart';
import 'package:toastie/features/meal/utils/meal_type.dart';
import 'package:toastie/services/services.dart';
import 'package:toastie/shared/widgets/image/fetch_image.dart';
import 'package:toastie/themes/text/text.dart';
import 'package:toastie/utils/layout/grid.dart';
import 'package:toastie/utils/time/time_details.dart';
import 'package:toastie/utils/utils.dart';

class MealCard extends StatelessWidget {
  MealCard({required this.meal})
      : color = mealTypeMap[meal.type]!,
        _ingredients =
            _getIngredients(ingredientDetails: meal.ingredient_details);

  final MealLogEntity meal;
  final MaterialColor color;
  final List<IngredientDetails> _ingredients;

  static List<IngredientDetails> _getIngredients({
    required List<IngredientDetails>? ingredientDetails,
  }) {
    List<IngredientDetails> ingredients = [];
    ingredientDetails?.forEach((ingredient) {
      ingredients.add(ingredient);
    });
    return ingredients;
  }

  Widget FallbackImage() {
    String imageDirectory = switch (meal.type) {
      MealType.breakfast => 'assets/meal/defaultBreakfast.png',
      MealType.lunch => 'assets/meal/defaultLunch.png',
      MealType.dinner => 'assets/meal/defaultDinner.png',
      MealType.snack => 'assets/meal/defaultSnack.png',
      _ => 'assets/meal/defaultSnack.png',
    };
    return Image(
      image: AssetImage(imageDirectory),
      fit: BoxFit.fitWidth,
    );
  }

  Widget Photo() {
    if (meal.photo_ids == null || meal.photo_ids!.isEmpty) {
      return Container();
    }

    return Padding(
      padding: EdgeInsets.only(right: gridbaseline * 2),
      child: FetchImage(
        // Only support showing the first photo for now.
        fetchCall: locator<PhotoUploadClient>().getPhoto(meal.photo_ids!.first),
        color: color,
        fallbackImage: FallbackImage(),
      ),
    );
  }

  Widget DefaultCardContents({
    required BuildContext context,
    required String time,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                capitalizeFirstCharacter(meal.name.toString()),
                style: titleMediumTextWithColor(
                  context: context,
                  color: color[900]!,
                ),
              ),
            ),
            SizedBox(width: gridbaseline),
            Text(
              time,
              style: bodyMediumTextWithColor(
                context: context,
                color: color[900] as Color,
              ),
            ),
          ],
        ),
        Visibility(
          visible: (meal.photo_ids != null && meal.photo_ids!.isNotEmpty) ||
              _ingredients.isNotEmpty,
          child: SizedBox(height: gridbaseline),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Photo(),
            Visibility(
              visible: _ingredients.isNotEmpty,
              child: Expanded(
                child: Text(
                  capitalizeFirstCharacter(
                    _ingredients
                        .map((ingredient) => ingredient.name)
                        .join(', '),
                  ),
                  style: bodySmallTextWithColor(
                    context: context,
                    color: color[900] as Color,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget StackedCardContents({
    required BuildContext context,
    required String time,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          capitalizeFirstCharacter(meal.name.toString()),
          style: titleMediumTextWithColor(
            context: context,
            color: color[900] as Color,
          ),
        ),
        SizedBox(height: gridbaseline / 2),
        Text(
          time,
          style: bodyMediumTextWithColor(
            context: context,
            color: color[900] as Color,
          ),
        ),
        Visibility(
          visible: _ingredients.isNotEmpty,
          child: Column(
            children: [
              SizedBox(height: gridbaseline / 2),
              Text(
                capitalizeFirstCharacter(
                  _ingredients.map((ingredient) => ingredient.name).join(', '),
                ),
                style: bodySmallTextWithColor(
                  context: context,
                  color: color[900] as Color,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: gridbaseline / 2),
        Photo(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    TimeDetails timeDetails = timeDetailsFromUnixDateTime(meal.date_time!);
    bool isAM = timeDetails.isAm;
    List<bool> selectedTimeSuffix = [isAM, !isAM];

    final String time = stringFromTimeDetails(
      details: timeDetails,
      selectedTimeSuffix: selectedTimeSuffix,
    );

    return ClickableSummaryCard(
      solidColor: color[100],
      defaultCardContents: DefaultCardContents(context: context, time: time),
      stackedCardContents: StackedCardContents(context: context, time: time),
      actionHandler: () => {},
    );
  }
}
