import 'package:flutter/material.dart';
import 'package:toastie/components/button/icon_button.dart';
import 'package:toastie/themes/colors.dart';
import 'package:toastie/utils/grid.dart';

class Tag extends StatefulWidget {
  Tag({
    required this.text,
    required this.actionHandler,
    required this.isEditState,
  });

  final String text;
  final Function() actionHandler;
  final bool isEditState;

  @override
  State<Tag> createState() => _TagState();
}

class _TagState extends State<Tag> {
  @override
  Widget build(BuildContext context) {
    return Container(
      key: UniqueKey(),
      decoration: ShapeDecoration(
        color: accentPink,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius,
        ),
      ),
      padding: widget.isEditState
          ? EdgeInsets.only(left: gridbaseline * 2, right: gridbaseline)
          : EdgeInsets.symmetric(
              vertical: gridbaseline,
              horizontal: gridbaseline * 2,
            ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.text,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                ),
          ),
          if (widget.isEditState)
            ToastieIconButton(
              iconType: IconType.Delete,
              actionHandler: widget.actionHandler,
              iconButtonType: IconButtonType.FilledButton,
              iconColor: Colors.white,
            ),
        ],
      ),
    );
  }
}
