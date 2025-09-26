import 'package:flutter/material.dart';
import 'package:toastie/components/card/toggle_card/toggle_card_item_detail.dart';
import 'package:toastie/features/medication/utils/medication_key.dart';
import 'package:toastie/themes/colors.dart';
import 'package:toastie/themes/text/text.dart';
import 'package:toastie/utils/grid.dart';

Widget MedicationDetails({
  required BuildContext context,
  // required bool isSelected,
  required MaterialColor color,
  ToggleCardItemDetail? detail,
}) {
  double? quantity;
  String? dose;

  if (detail != null) {
    Map<String, dynamic>? medicationDetails = detail.details?.toJson();
    if (medicationDetails == null) {
      return SizedBox.shrink();
    }

    quantity = medicationDetails[medicationToggleCardQuantityKey] ?? 1;
    dose = medicationDetails[medicationToggleCardDoseKey] ?? '';
  }

  return Row(
    children: [
      ...medicationIcons(quantity: quantity ?? 1.0, color: color),
      if (dose != null && dose.isNotEmpty) ...[
        SizedBox(width: gridbaseline),
        Text(
          dose,
          style: labelMediumTextWithColor(
            context,
            color[900]!,
          ),
        ),
      ],
    ],
  );
}

final Map<MaterialColor, String> materialColorNames = {
  primary: 'primary',
  success: 'success',
  neutral: 'neutral',
};

List<Widget> medicationIcons({
  required MaterialColor color,
  double quantity = 1,
}) {
  final colorName = materialColorNames[color] ?? 'default';

  int wholePills = quantity.truncate();
  List<Widget> pills = List.generate(
    wholePills,
    (index) => Image(
      image: AssetImage('assets/icons/medication/medication_${colorName}.png'),
      height: gridbaseline * 2.5,
      fit: BoxFit.fitHeight,
    ),
  );

  bool hasPartialPill = quantity % 1 != 0;
  if (hasPartialPill) {
    pills.add(
      Image(
        image: AssetImage(
          'assets/icons/medication/medication_${colorName}_half.png',
        ),
        height: gridbaseline * 2.5,
        fit: BoxFit.fitHeight,
      ),
    );
  }
  return pills;
}

String getMedicationScheduleNotifBodyString({
  String dose = '',
  String quantity = '',
}) {
  if (dose.isEmpty && quantity.isEmpty) return '';
  return [
    if (dose.isNotEmpty) dose,
    if (quantity.isNotEmpty) 'x$quantity',
  ].join(' ');
}
