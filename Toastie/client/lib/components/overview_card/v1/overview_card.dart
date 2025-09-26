import 'package:flutter/material.dart';
import 'package:toastie/components/button/icon_button.dart';
import 'package:toastie/themes/colors.dart';
import 'package:toastie/utils/grid.dart';

class OverviewCard extends StatefulWidget {
  OverviewCard({
    required this.contents,
    required this.isEditState,
    required this.index,
    required this.deleteButtonClicked,
  });

  final Widget contents;
  final bool isEditState;
  final int index;
  final Function(int index) deleteButtonClicked;

  @override
  State<OverviewCard> createState() => _OverviewCardState();
}

class _OverviewCardState extends State<OverviewCard> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      // Assign key if you want to manipulate lists in Flutter. Flutter compares widget only by Type and not state.
      key: UniqueKey(),
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: gridbaseline,
            right: gridbaseline,
          ),
          child: Card(
            shadowColor: Colors.transparent,
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: DecoratedBox(
                      decoration: ShapeDecoration(
                        color: primary[400],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(gridbaseline * 4),
                            bottomLeft: Radius.circular(gridbaseline * 4),
                          ),
                        ),
                      ),
                      // Question: why does this work but a nested container doesn't?
                      child: Center(
                        child: Image(
                          height: gridbaseline * 10,
                          image: AssetImage('assets/logo.png'),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: DecoratedBox(
                      decoration: ShapeDecoration(
                        color: primary[100],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(gridbaseline * 4),
                            bottomRight: Radius.circular(gridbaseline * 4),
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          widget.contents,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (widget.isEditState)
          Align(
            alignment: Alignment.topRight,
            child: ToastieIconButton(
              iconButtonType: IconButtonType.FilledButton,
              iconType: IconType.Delete,
              iconColor: Colors.white,
              actionHandler: () => widget.deleteButtonClicked(widget.index),
            ),
          ),
      ],
    );
  }
}
