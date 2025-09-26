import 'dart:async';

import 'package:flutter/material.dart';
import 'package:toastie/components/button/icon_button.dart';
import 'package:toastie/themes/colors.dart';
import 'package:toastie/themes/text/text.dart';
import 'package:toastie/utils/grid.dart';
import 'package:toastie/utils/responsive_utils.dart';

class QuickAdd extends StatefulWidget {
  const QuickAdd({
    required super.key,
    required this.medicationName,
    required this.onTap,
    required this.onDisappear,
  });

  final String medicationName;
  final VoidCallback onTap;
  final VoidCallback onDisappear;

  @override
  State<QuickAdd> createState() => _QuickAddState();
}

class _QuickAddState extends State<QuickAdd> {
  bool _isTapped = false;
  bool _isVisible = true;
  Timer? _disappearTimer;

  @override
  void dispose() {
    _disappearTimer?.cancel();
    super.dispose();
  }

  void _handleTap() {
    if (!_isTapped) {
      setState(() {
        _isTapped = true;
      });

      widget.onTap();

      _disappearTimer = Timer(Duration(seconds: 1), () {
        setState(() {
          _isVisible = false;
        });
        widget.onDisappear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _isVisible ? 1.0 : 0.0,
      duration: Duration(milliseconds: 500),
      child: GestureDetector(
        onTap: _handleTap,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 1),
          clipBehavior: Clip.hardEdge,
          decoration: ShapeDecoration(
            color: _isTapped ? success[200] : info[200],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(gridbaseline)),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: gridbaseline / 2,
              horizontal: gridbaseline,
            ),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: gridbaseline / 4,
              children: [
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 1),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child: Icon(
                    _isTapped ? Icons.check : Icons.add,
                    key: ValueKey<bool>(_isTapped),
                    color: _isTapped ? success[900] : info[900],
                    size: scaleBySystemFont(
                      context: context,
                      size: smallIconSize,
                    ),
                  ),
                ),
                Text(
                  widget.medicationName,
                  style: bodyMediumTextWithColor(
                    context: context,
                    color:
                        _isTapped ? success[900] as Color : info[900] as Color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
