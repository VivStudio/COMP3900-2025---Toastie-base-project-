import 'package:flutter/material.dart';
import 'package:toastie/components/button/icon_button.dart';
import 'package:toastie/components/card/base_card.dart';
import 'package:toastie/utils/layout/padding.dart';

/*
 * Editable card component with slider. All variations of an editable card with slider should be built on top of this component.
 */
class EditableCardWithSlider extends StatefulWidget {
  EditableCardWithSlider({
    required this.isEditState,
    required this.color,
    required this.card,
    required this.cardEditor,
    required this.deleteCard,
  });

  final bool isEditState;
  final MaterialColor color;
  final Widget card;
  final Widget cardEditor;
  final Function() deleteCard;

  @override
  State<EditableCardWithSlider> createState() => _EditableCardWithSliderState();
}

class _EditableCardWithSliderState extends State<EditableCardWithSlider> {
  Widget _Card(BuildContext context) {
    return Padding(
      padding: cardOuterPadding,
      child: BaseCard(
        solidColor: widget.color[100]!,
        child: Padding(
          padding: cardLargeInnerPadding,
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
    return widget.isEditState ? _CardEditor(context) : _Card(context);
  }
}
