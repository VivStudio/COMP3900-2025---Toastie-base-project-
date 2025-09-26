import 'package:toastie/utils/tracker_utils.dart';

class HomePageOption {
  HomePageOption({
    required this.id,
    required this.title,
    required this.iconAssetPath,
    this.isEnabled = true,
  });

  factory HomePageOption.fromJson(Map<String, dynamic> json) => HomePageOption(
        id: json['id'],
        title: json['title'],
        isEnabled: json['isEnabled'],
        iconAssetPath: json['iconAssetPath'],
      );

  final TrackerCategory id;
  final String title;
  final String iconAssetPath;
  bool isEnabled;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'isEnabled': isEnabled,
        'iconAssetPath': iconAssetPath,
      };
}
