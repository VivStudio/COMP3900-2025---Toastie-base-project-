import 'package:flutter/material.dart';
import 'package:toastie/utils/layout/grid.dart';
import 'package:toastie/utils/responsive_utils.dart';

class IconButtonV2 extends StatelessWidget {
  IconButtonV2({
    required this.icon,
    // eg. Start recoding, Send message. Imperative and concise.
    required this.toolTip,
    required this.onTap,
    required this.fillColor,
    required this.focusColor,
    required this.iconColor,
  });

  final IconData icon;
  final String toolTip;
  final VoidCallback onTap;
  final Color fillColor;
  final Color focusColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final double size = scaleBySystemFont(
      context: context,
      size: gridbaseline * 5,
    );

    final double iconSize = scaleBySystemFont(
      context: context,
      size: gridbaseline * 3,
    );

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: fillColor,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon),
        tooltip: toolTip,
        iconSize: iconSize,
        color: iconColor,
        focusColor: focusColor,
        onPressed: onTap,
      ),
    );
  }
}
