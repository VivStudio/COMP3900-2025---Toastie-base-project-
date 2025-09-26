import 'package:flutter/material.dart';
import 'package:toastie/components/button/icon_button.dart';
import 'package:toastie/components/header/header_title.dart';
import 'package:toastie/themes/colors.dart';
import 'package:toastie/utils/grid.dart';
import 'package:toastie/utils/responsive_utils.dart';

class HeaderTitleWithBackAndEditButton extends StatefulWidget {
  HeaderTitleWithBackAndEditButton({
    required this.title,
    required this.backButtonClicked,
    required this.editButtonClicked,
    required this.doneButtonClicked,
    this.isEditState = false,
  });

  final String title;
  final bool isEditState;
  final Function() backButtonClicked;
  final Function() editButtonClicked;
  final Function() doneButtonClicked;

  @override
  State<HeaderTitleWithBackAndEditButton> createState() =>
      _HeaderTitleWithBackAndEditButton();
}

class _HeaderTitleWithBackAndEditButton
    extends State<HeaderTitleWithBackAndEditButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: ToastieIconButton(
                iconType: IconType.Back,
                actionHandler: widget.backButtonClicked,
              ),
            ),
            Padding(
              // TODO: this is not good, think of a better way to do this
              padding: EdgeInsets.symmetric(
                horizontal:
                    (scaleBySystemFont(context: context, size: smallIconSize) +
                        gridbaseline * 4),
              ),
              child: HeaderTitle(title: widget.title),
            ),
            widget.isEditState
                ? Align(
                    alignment: Alignment.centerRight,
                    child: ToastieIconButton(
                      iconType: IconType.Done,
                      iconButtonType: IconButtonType.FilledButton,
                      iconColor: Colors.white,
                      actionHandler: widget.doneButtonClicked,
                      fillColor: accentPink,
                    ),
                  )
                : Align(
                    alignment: Alignment.centerRight,
                    child: ToastieIconButton(
                      iconType: IconType.Edit,
                      actionHandler: widget.editButtonClicked,
                    ),
                  ),
          ],
        ),
        SizedBox(height: gridbaseline),
      ],
    );
  }
}
