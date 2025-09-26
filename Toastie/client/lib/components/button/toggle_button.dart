import 'package:flutter/material.dart';
import 'package:toastie/entities/lab_report/lab_report_entity.dart';
import 'package:toastie/themes/colors.dart';
import 'package:toastie/themes/text/text.dart';
import 'package:toastie/utils/layout/border_radius.dart';
import 'package:toastie/utils/layout/grid.dart';
import 'package:toastie/utils/utils.dart';

// Do NOT use flutter in-built toggle button, it does not account for overflows, so please use this component instead.
// NOTE: this is currently only being used on the lab report page, make this more generic when we need to re-use this component elsewhere.
class ToastieToggleButton extends StatefulWidget {
  ToastieToggleButton({
    required this.selectedTab,
    required this.actionHandler,
  });

  final ReportType selectedTab;
  final Function({required ReportType newTab}) actionHandler;

  @override
  State<ToastieToggleButton> createState() => _ToastieToggleButtonState();
}

class _ToastieToggleButtonState extends State<ToastieToggleButton> {
  Widget ToggleButton({required ReportType type}) {
    bool isSelectedTab = widget.selectedTab.name == type.name;

    return Expanded(
      child: TextButton(
        onPressed: () => widget.actionHandler(newTab: type),
        style: TextButton.styleFrom(
          backgroundColor: isSelectedTab ? primary[400] : Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadiusSmall,
          ),
        ),
        child: Text(
          capitalizeFirstCharacter(type.name),
          style: titleSmallTextWithColor(
            context: context,
            color: isSelectedTab ? Colors.white : primary[600] as Color,
          ).copyWith(
            fontWeight: isSelectedTab ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: borderRadius,
      ),
      padding: EdgeInsets.all(gridbaseline),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ToggleButton(type: ReportType.imaging),
            ToggleButton(type: ReportType.lab),
            ToggleButton(type: ReportType.other),
          ],
        ),
      ),
    );
  }
}
