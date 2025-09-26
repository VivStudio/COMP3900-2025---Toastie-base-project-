import 'package:flutter/material.dart';
import 'package:toastie/themes/colors.dart';
import 'package:toastie/utils/grid.dart';
import 'package:toastie/utils/layout/border_radius.dart';

class MedicationCheckbox extends StatelessWidget {
  MedicationCheckbox({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 100),
        width: gridbaseline * 4,
        height: gridbaseline * 4,
        decoration: BoxDecoration(
          color: value ? success : Colors.white,
          borderRadius: borderRadiusSmall,
        ),
        child: value ? Icon(Icons.check, color: Colors.white) : null,
      ),
    );
  }
}
