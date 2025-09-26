import 'package:flutter/material.dart';
import 'package:toastie/components/card/clickable_card/clickable_summary_card.dart';
import 'package:toastie/entities/trackers/note_logs_entity.dart';
import 'package:toastie/themes/colors.dart';
import 'package:toastie/themes/text/text.dart';
import 'package:toastie/utils/utils.dart';

class NoteCard extends StatelessWidget {
  NoteCard({required this.note});

  final NoteLogsEntity note;
  final MaterialColor color = purple;

  Widget Content({required BuildContext context}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          capitalizeFirstCharacter(note.note.toString()),
          style: titleSmallTextWithColor(
            context: context,
            color: color[900] as Color,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClickableSummaryCard(
      solidColor: color[100],
      defaultCardContents: Content(context: context),
      stackedCardContents: Content(context: context),
      actionHandler: () => {},
    );
  }
}
