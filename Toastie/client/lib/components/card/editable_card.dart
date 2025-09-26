/*
 * Editable card component. All variations of an editable card should be built on top of this component.
 */
import 'package:flutter/material.dart';
import 'package:toastie/components/button/icon_button.dart';
import 'package:toastie/components/card/base_card.dart';
import 'package:toastie/utils/layout/padding.dart';

class EditableCard extends StatefulWidget {
  EditableCard({
    required this.isEditState,
    required this.color,
    required this.card,
    required this.cardEditor,
    required this.deleteCard,
    this.padding = cardLargeInnerPadding,
  });

  final bool isEditState;
  final MaterialColor color;
  final Widget card;
  final Widget cardEditor;
  final Function() deleteCard;
  final EdgeInsets padding;

  @override
  State<EditableCard> createState() => _EditableCardState();
}

class _EditableCardState extends State<EditableCard> {
  Widget _Card(BuildContext context) {
    return Padding(
      padding: cardOuterPadding,
      child: BaseCard(
        solidColor: widget.color[100]!,
        child: Padding(
          padding: widget.padding,
          child: widget.card,
        ),
      ),
    );
  }

  Widget _CardEditor(BuildContext context) {
    return Stack(
      // Assign key if you want to manipulate lists in Flutter.
      // Flutter compares widget only by type (not state).
      key: UniqueKey(),
      children: [
        Padding(
          padding: cardOuterEditStatePadding,
          child: BaseCard(
            solidColor: widget.color[100]!,
            child: Padding(
              padding: cardLargeInnerPadding,
              child: widget.cardEditor,
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: ToastieIconButton(
            iconButtonType: IconButtonType.FilledButton,
            iconType: IconType.Delete,
            iconColor: Colors.white,
            actionHandler: widget.deleteCard,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Use offstage here to maintain widget state while it is hidden.
    return Column(
      children: [
        Offstage(
          offstage: !widget.isEditState,
          child: _CardEditor(
            context,
          ),
        ),
        Offstage(
          offstage: widget.isEditState,
          child: _Card(context),
        ),
      ],
    );
  }
}
