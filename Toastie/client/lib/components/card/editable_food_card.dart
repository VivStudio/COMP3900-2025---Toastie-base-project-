import 'package:flutter/material.dart';
import 'package:toastie/components/card/base_card.dart';
import 'package:toastie/components/button/icon_button.dart';
import 'package:toastie/utils/layout/padding.dart';

class EditableFoodCard extends StatefulWidget {
  EditableFoodCard({
    required this.isEditState,
    required this.color,
    required this.card,
    required this.cardEditor,
    required this.deleteCard,
    this.hideDeleteButton = false,
  });

  final bool isEditState;
  final MaterialColor color;
  final Widget card;
  final Widget cardEditor;
  final Function() deleteCard;
  final bool hideDeleteButton;

  @override
  State<EditableFoodCard> createState() => _EditableFoodCardState();
}

class _EditableFoodCardState extends State<EditableFoodCard> {
  Widget _Card(BuildContext context) {
    return Container(
      child: widget.card,
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
        Visibility(
          visible: !widget.hideDeleteButton,
          child: Align(
            alignment: Alignment.topRight,
            child: ToastieIconButton(
              iconButtonType: IconButtonType.FilledButton,
              iconType: IconType.Delete,
              iconColor: Colors.white,
              actionHandler: widget.deleteCard,
            ),
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
