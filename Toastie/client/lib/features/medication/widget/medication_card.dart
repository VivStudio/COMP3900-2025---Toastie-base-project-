import 'package:flutter/material.dart';
import 'package:toastie/components/card/clickable_card/clickable_summary_card.dart';
import 'package:toastie/entities/trackers/medication_logs_entity.dart';
import 'package:toastie/themes/colors.dart';
import 'package:toastie/themes/text/text.dart';
import 'package:toastie/utils/layout/grid.dart';
import 'package:toastie/utils/time/time_details.dart';
import 'package:toastie/utils/utils.dart';

class MedicationCard extends StatelessWidget {
  MedicationCard({required this.medication});

  final MedicationLogsEntity medication;
  final MaterialColor color = info;

  // Returns a list with [quantity] amount of pills images.
  List<Widget> MedicationIcons() {
    String quantity = medication.quantity.toString();
    int wholePills = double.parse(quantity).floor();
    bool hasPartialPill = (double.parse(quantity) - wholePills) >= 0.1;

    // Cap rendering of pills to 5.
    if (wholePills > 5) {
      wholePills = 1;
      hasPartialPill = false;
    }
    List<Widget> images = List.generate(
      wholePills,
      (index) => Image(
        image: AssetImage('assets/icons/medication/medication_info.png'),
        height: gridbaseline * 2.5,
        fit: BoxFit.fitHeight,
      ),
    );

    if (hasPartialPill) {
      images.add(
        Image(
          image: AssetImage('assets/icons/medication/medication_info_half.png'),
          height: gridbaseline * 2.5,
          fit: BoxFit.fitHeight,
        ),
      );
    }

    return images;
  }

  Widget MedicationQuantityAndDose({required BuildContext context}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Visibility(
          visible: medication.quantity != null,
          child: Row(
            children: MedicationIcons(),
          ),
        ),
        Visibility(
          visible: medication.quantity != null && medication.quantity! >= 6,
          child: Text(
            'x${medication.quantity}',
            style: labelMediumTextWithColor(context, color[900] as Color),
          ),
        ),
        Visibility(
          visible: medication.dose != null,
          child: Row(
            children: [
              SizedBox(width: gridbaseline),
              Text(
                capitalizeFirstCharacter(medication.dose.toString()),
                style: labelMediumTextWithColor(context, color[900] as Color),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget StackedCardContents({
    required BuildContext context,
    required String time,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          capitalizeFirstCharacter(medication.name.toString()),
          style: titleMediumTextWithColor(
            context: context,
            color: color[900]!,
          ),
        ),
        Text(
          time,
          style: bodyMediumTextWithColor(
            context: context,
            color: color[900] as Color,
          ),
        ),
        MedicationQuantityAndDose(context: context),
      ],
    );
  }

  Widget DefaultCardContents({
    required BuildContext context,
    required String time,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                capitalizeFirstCharacter(medication.name.toString()),
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
        MedicationQuantityAndDose(context: context),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    TimeDetails timeDetails =
        timeDetailsFromUnixDateTime(medication.date_time!);
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
