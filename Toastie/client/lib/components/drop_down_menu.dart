import 'package:flutter/material.dart';
import 'package:toastie/themes/text/text.dart';
import 'package:toastie/utils/layout/border_radius.dart';
import 'package:toastie/utils/layout/grid.dart';

class DropDownMenu extends StatefulWidget {
  DropDownMenu({
    required this.color,
    required this.selected,
    required this.options,
    required this.onChanged,
  });

  final ValueChanged<String?> onChanged;

  final MaterialColor color;
  final String selected;
  final List<String> options;

  @override
  State<DropDownMenu> createState() => DropDownMenuState();
}

class DropDownMenuState extends State<DropDownMenu> {
  late String selected;

  @override
  void initState() {
    super.initState();
    selected = widget.selected;
  }

  @override
  void didUpdateWidget(covariant DropDownMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget != widget) {
      selected = widget.selected;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      alignedDropdown: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: widget.color[300] as Color),
          borderRadius: borderRadius,
          color: widget.color[100],
        ),
        child: DropdownButton(
          value: selected,
          borderRadius: borderRadius,
          dropdownColor: widget.color[100],
          elevation: 1,
          focusColor: widget.color[300],
          isExpanded: true,
          iconEnabledColor: widget.color[900],
          style: titleMediumTextWithColor(
            context: context,
            color: widget.color[900]!,
          ),
          padding: EdgeInsets.only(right: gridbaseline),
          underline: Container(
            height: 0,
            color: Colors.transparent,
          ),
          onChanged: (String? newValue) {
            setState(() {
              selected = newValue!;
            });
            widget.onChanged(newValue);
          },
          items: widget.options.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem(
              value: value,
              child: Text(
                value,
                style: titleMediumTextWithColor(
                  context: context,
                  color: widget.color[900]!,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
