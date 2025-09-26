import 'package:flutter/material.dart';
import 'package:toastie/components/button/icon_button.dart';
import 'package:toastie/themes/colors.dart';
import 'package:toastie/utils/grid.dart';
import 'package:toastie/utils/responsive_utils.dart';

enum ToggleViewType {
  calendar,
  timeline,
}

class ToggleIconButton extends StatefulWidget {
  ToggleIconButton({
    required this.selectedTab,
    required this.actionHandler,
  });

  final ToggleViewType selectedTab;
  final Function({required ToggleViewType newTab}) actionHandler;

  @override
  State<ToggleIconButton> createState() => _ToggleIconButtonState();
}

class _ToggleIconButtonState extends State<ToggleIconButton> {
  Widget _buildToggleButton({
    required ToggleViewType type,
    required IconData icon,
  }) {
    bool isSelectedTab = widget.selectedTab == type;

    return InkWell(
      onTap: () => widget.actionHandler(newTab: type),
      borderRadius: BorderRadius.all(Radius.circular(gridbaseline * 5)),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelectedTab ? primary[200] : primary[100],
          borderRadius: BorderRadius.circular(gridbaseline * 4),
        ),
        child: Padding(
          padding: EdgeInsets.all(gridbaseline),
          child: Icon(
            icon,
            color: isSelectedTab ? primary : primary[300],
            size: scaleBySystemFont(
              context: context,
              size: smallIconSize,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: primary[100],
        borderRadius: BorderRadius.all(Radius.circular(gridbaseline * 5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildToggleButton(
            type: ToggleViewType.calendar,
            icon: Icons.calendar_today,
          ),
          _buildToggleButton(
            type: ToggleViewType.timeline,
            icon: Icons.list,
          ),
        ],
      ),
    );
  }
}
