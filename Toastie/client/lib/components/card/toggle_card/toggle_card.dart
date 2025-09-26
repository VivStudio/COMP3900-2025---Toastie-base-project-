import 'package:flutter/material.dart';
import 'package:toastie/components/card/base_card.dart';
import 'package:toastie/components/card/toggle_card/toggle_card_item_detail.dart';
import 'package:toastie/features/medication/medication.dart';
import 'package:toastie/features/tracker/tracker.dart';
import 'package:toastie/themes/text/text.dart';
import 'package:toastie/utils/grid.dart';
import 'package:toastie/utils/utils.dart';
import 'package:toastie/themes/colors.dart';
import 'package:toastie/utils/layout/padding.dart';

class ToggleCard extends StatefulWidget {
  ToggleCard({
    required this.trackerType,
    required this.detail,
    required this.isSelected,
    required this.onSelected,
  });

  final TrackerType trackerType;
  final ToggleCardItemDetail detail;
  final bool isSelected;
  final ValueChanged<bool> onSelected;

  @override
  _ToggleCardState createState() => _ToggleCardState();
}

class _ToggleCardState extends State<ToggleCard> {
  var _isSelected = false;
  late ToggleCardItemDetail _originalDetail;

  @override
  void initState() {
    super.initState();
    _isSelected = widget.isSelected;
    _originalDetail = widget.detail;
  }

  @override
  void didUpdateWidget(covariant ToggleCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.detail != widget.detail) {
      _originalDetail = widget.detail;
      _isSelected = widget.isSelected;
    }
  }

  void toggleSelection() {
    setState(() {
      _isSelected = !_isSelected;
      widget.onSelected(_isSelected);
    });
  }

  Widget CardContent({
    required BuildContext context,
    required MaterialColor color,
  }) {
    return Padding(
      padding: cardInnerPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            capitalizeFirstCharacter(_originalDetail.name),
            style: bodyMediumTextWithColor(
              context: context,
              color: color[600] as Color,
            ),
          ),
          Visibility(
            visible: widget.trackerType == TrackerType.medication,
            child: MedicationDetails(
              context: context,
              color: _isSelected ? success : primary,
              detail: _originalDetail,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    MaterialColor color = _isSelected ? success : primary;

    return Padding(
      padding: toggleCardBottomPadding,
      child: BaseCard(
        solidColor: _isSelected ? success[100]! : primary[100]!,
        actionHandler: toggleSelection,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: gridbaseline * 1.5,
                  top: gridbaseline * 1.5,
                  bottom: gridbaseline * 1.5,
                ),
                child: MedicationCheckbox(
                  value: _isSelected,
                  onChanged: (bool? _) {
                    toggleSelection();
                  },
                ),
              ),
              Expanded(
                child: CardContent(
                  context: context,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
