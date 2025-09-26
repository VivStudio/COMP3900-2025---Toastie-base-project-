import 'package:toastie/features/medication/medication.dart';

/** Used to populate a toggle card (shown on search page) */
class ToggleCardItemDetail {
  ToggleCardItemDetail({
    required this.name,
    this.details = null,
  });

  final String name;
  final ToggleCardItemDetails? details;

  @override
  String toString() {
    return 'ToggleCardItemDetail name:$name, details:$details';
  }
}

sealed class ToggleCardItemDetails {
  Map<String, dynamic> toJson();
}

class MedicationToggleCardItemDetails extends ToggleCardItemDetails {
  MedicationToggleCardItemDetails({this.dose = '', this.quantity = 1});

  factory MedicationToggleCardItemDetails.fromJson(Map<String, dynamic> json) {
    return MedicationToggleCardItemDetails(
      dose: json['Dose'] as String,
      quantity: json['Quantity'] as double,
    );
  }

  final String dose;
  final double quantity;

  @override
  Map<String, dynamic> toJson() => {
        medicationToggleCardQuantityKey: quantity,
        medicationToggleCardDoseKey: dose,
      };
}
