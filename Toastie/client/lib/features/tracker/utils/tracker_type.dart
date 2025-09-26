enum TrackerType {
  symptom,
  medication,
  food,
  stool,
  period,
  weight,
  notes,
}

String getTrackerName(TrackerType tracker) {
  switch (tracker) {
    case TrackerType.symptom:
      return 'symptom';
    case TrackerType.medication:
      return 'medication';
    case TrackerType.food:
      return 'food';
    case TrackerType.stool:
      return 'stool';
    case TrackerType.period:
      return 'period';
    case TrackerType.notes:
      return 'notes';
    default:
      return '';
  }
}
