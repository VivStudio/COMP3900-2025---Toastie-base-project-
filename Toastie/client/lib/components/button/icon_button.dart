import 'package:flutter/material.dart';
import 'package:toastie/themes/colors.dart';
import 'package:toastie/utils/grid.dart';
import 'package:toastie/utils/responsive_utils.dart';

/** Common icons. */
enum IconType {
  Back,
  Calendar,
  Edit,
  Done,
  Delete,
  Expand,
  ExpandLess,
  ExpandMore,
  Add,
  NavigateBefore,
  NavigateNext,
  NotificationOn,
  NotificationOff,
  PhotoCamera,
  PhotoGallery,
  StartRecording,
  StopRecording,
  PauseRecording,
  Refresh,
  ResumeRecording,
  Save,
  Visibility,
  VisibilityOff,
  Send,
}

enum IconButtonType {
  DefaultButton,
  FilledButton,
}

enum IconSize {
  Default,
  Page,
  Card,
  Small,
  ExtraSmall,
}

enum IconShape {
  Round,
  Checkbox,
}

// Used for decorative icons such as on the lab report cards.
final double extraSmallIconSize = gridbaseline * 2;
final double smallIconSize = gridbaseline * 3;
final double largeIconSize = gridbaseline * 4;

class ToastieIconButton extends StatelessWidget {
  ToastieIconButton({
    required this.actionHandler,
    this.iconType,
    this.icon,
    this.iconButtonType = IconButtonType.DefaultButton,
    this.iconSize = IconSize.Default,
    this.toolTip,
    this.iconColor = primary,
    this.fillColor = accentPink,
    this.shape = IconShape.Round,
  }) {
    // If no iconType, then must have icon and toolTip as a parameter.
    if (iconType == null) {
      if (icon == null || toolTip != null) {
        return;
      }
    }
  }

  final Function() actionHandler;
  final IconType? iconType;
  final IconData? icon;
  final IconButtonType iconButtonType;
  final String? toolTip;
  final Color iconColor;
  final Color fillColor;
  final IconSize iconSize;
  final IconShape shape;

  @override
  Widget build(BuildContext context) {
    return switch (iconButtonType) {
      IconButtonType.DefaultButton => defaultIconButton(context),
      IconButtonType.FilledButton => filledIconButton(context),
    };
  }

  double iconSizeByType(BuildContext context) {
    switch (iconSize) {
      case IconSize.Page:
        return scaleBySystemFont(
          context: context,
          size: largeIconSize,
        );
      case IconSize.Card:
      case IconSize.Default:
      case IconSize.Small:
        return scaleBySystemFont(
          context: context,
          size: smallIconSize,
        );
      case IconSize.ExtraSmall:
        return scaleBySystemFont(
          context: context,
          size: extraSmallIconSize,
        );
    }
  }

  Widget defaultIconButton(BuildContext context) {
    return IconButton(
      color: iconColor,
      icon: icon != null
          ? Icon(icon)
          : switch (iconType) {
              IconType.Back => Icon(Icons.arrow_back),
              IconType.Calendar => Icon(Icons.calendar_today),
              IconType.Edit => Icon(Icons.edit),
              IconType.Done => Icon(Icons.check),
              IconType.Delete => Icon(Icons.clear),
              IconType.Expand => Icon(Icons.arrow_forward_ios),
              IconType.ExpandMore => Icon(Icons.expand_more),
              IconType.ExpandLess => Icon(Icons.expand_less),
              IconType.Add => Icon(Icons.add),
              IconType.NavigateBefore => Icon(Icons.navigate_before),
              IconType.NavigateNext => Icon(Icons.navigate_next),
              IconType.NotificationOn => Icon(Icons.notifications_active),
              IconType.NotificationOff =>
                Icon(Icons.notifications_off_outlined),
              IconType.PhotoCamera => Icon(Icons.add_a_photo),
              IconType.PhotoGallery => Icon(Icons.photo_library),
              IconType.StartRecording => Icon(Icons.mic),
              IconType.StopRecording => Icon(Icons.stop),
              IconType.PauseRecording => Icon(Icons.pause),
              IconType.Refresh => Icon(Icons.refresh),
              IconType.ResumeRecording => Icon(Icons.play_arrow),
              IconType.Save => Icon(Icons.check),
              IconType.Visibility => Icon(Icons.visibility),
              IconType.VisibilityOff => Icon(Icons.visibility_off),
              IconType.Send => Icon(Icons.send),
              null => Icon(Icons.warning),
            },
      onPressed: actionHandler,
      tooltip: toolTip != null
          ? toolTip
          : switch (iconType) {
              IconType.Back => 'Click to go back to the previous page.',
              IconType.Calendar => 'Go to today',
              IconType.Edit => 'Click edit to edit this page.',
              IconType.Done => 'Click to save edits on this page.',
              IconType.Delete => 'Click to delete this card.',
              IconType.Expand => 'Click to see more.',
              IconType.ExpandMore => 'Expand',
              IconType.ExpandLess => 'Collapse',
              IconType.Add => 'Click to add.',
              IconType.NavigateBefore => 'Click to go back.',
              IconType.NavigateNext => 'Click to see more.',
              IconType.NotificationOn => 'Turn notification on',
              IconType.NotificationOff => 'Turn notification off',
              IconType.PhotoCamera => 'Click to take a photo.',
              IconType.PhotoGallery =>
                'Click to add a photo from your gallery.',
              IconType.StartRecording => 'Start recording',
              IconType.StopRecording => 'Stop recording',
              IconType.PauseRecording => 'Pause recording',
              IconType.Refresh => 'Refresh',
              IconType.ResumeRecording => 'Resume recording',
              IconType.Save => 'Save',
              IconType.Visibility => 'Toggle visibility',
              IconType.VisibilityOff => 'Toggle visibility',
              IconType.Send => 'Click to send',
              null => '',
            },
      iconSize: iconSizeByType(context),
    );
  }

  Widget filledIconButton(BuildContext context) {
    Widget button = DecoratedBox(
      decoration: BoxDecoration(
        shape: shape == IconShape.Round ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: shape == IconShape.Checkbox ? borderRadius : null,
        color: fillColor,
      ),
      child: Padding(
        padding: iconSize == IconSize.Page
            ? EdgeInsets.all(gridbaseline / 2)
            : EdgeInsets.zero,
        child: defaultIconButton(context),
      ),
    );

    if (iconSize == IconSize.Card) {
      return Container(
        alignment: Alignment.center,
        child: button,
      );
    }
    return button;
  }
}
