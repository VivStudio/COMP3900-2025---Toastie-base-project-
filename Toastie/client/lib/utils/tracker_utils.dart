import 'package:flutter/material.dart';
import 'package:toastie/themes/colors.dart';
import 'package:toastie/themes/gradient_background_colors.dart';
import 'package:toastie/utils/utils.dart';

enum TrackerCategory {
  symptom,
  medication,
  food,
  stool,
  period,
  weight,
  notes,
  labReport,
}

MaterialColor getColorFromTrackerCategory({required TrackerCategory category}) {
  switch (category) {
    case TrackerCategory.symptom:
    case TrackerCategory.period:
      return accentPink;
    case TrackerCategory.medication:
      return info;
    case TrackerCategory.food:
      return success;
    case TrackerCategory.stool:
      return primary;
    case TrackerCategory.weight:
      return accentYellow;
    case TrackerCategory.notes:
      return purple;
    case TrackerCategory.labReport:
      return info;
  }
}

BoxDecoration getGradientBackgroundColorFromTrackerCategory({
  required TrackerCategory category,
}) {
  switch (category) {
    case TrackerCategory.symptom:
    case TrackerCategory.period:
      return accentPinkAndNeutralGradientBackground;
    case TrackerCategory.medication:
    case TrackerCategory.notes:
      return infoNeutralAndPrimaryGradientBackground;
    case TrackerCategory.food:
      return successNeutralAndPrimaryGradientBackground;
    case TrackerCategory.stool:
      return primaryAndNeutralGradientBackground;
    case TrackerCategory.weight:
      return accentYellowAndNeutralGradientBackground;
    case TrackerCategory.labReport:
      return infoNeutralAndPrimaryGradientBackground;
  }
}

String getImageAssetNameFromTrackerCategory({
  required TrackerCategory category,
}) {
  return switch (category) {
    TrackerCategory.symptom => 'assets/icons/symptomsIcon.png',
    TrackerCategory.medication => 'assets/icons/medication/medication_info.png',
    TrackerCategory.food => 'assets/icons/foodIcon.png',
    TrackerCategory.stool => 'assets/icons/stoolIcon.png',
    TrackerCategory.period => 'assets/icons/periodIcon.png',
    TrackerCategory.weight => 'assets/icons/weightIcon.png',
    TrackerCategory.notes => 'assets/icons/notesIcon.png',
    TrackerCategory.labReport => 'assets/icons/labReportIcon.png',
  };
}

String getTrackerName(TrackerCategory type) {
  if (type == TrackerCategory.labReport) {
    return 'Lab report';
  }
  return capitalizeFirstCharacter(type.name);
}
