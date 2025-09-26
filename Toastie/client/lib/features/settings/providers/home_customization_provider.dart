import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastie/features/settings/models/home_page_option.dart';
import 'dart:convert';
import 'package:toastie/utils/tracker_utils.dart';

class HomeCustomizationProvider with ChangeNotifier {
  HomeCustomizationProvider() {
    _loadPreferences();
  }
  static const _preferencesKey = 'homePageCustomization';

  List<HomePageOption> _options = [
    HomePageOption(
      id: TrackerCategory.symptom,
      title: 'Show symptom',
      iconAssetPath: getImageAssetNameFromTrackerCategory(
        category: TrackerCategory.symptom,
      ),
    ),
    HomePageOption(
      id: TrackerCategory.medication,
      title: 'Show medication',
      iconAssetPath: getImageAssetNameFromTrackerCategory(
        category: TrackerCategory.medication,
      ),
    ),
    HomePageOption(
      id: TrackerCategory.food,
      title: 'Show food',
      iconAssetPath: getImageAssetNameFromTrackerCategory(
        category: TrackerCategory.food,
      ),
    ),
    HomePageOption(
      id: TrackerCategory.stool,
      title: 'Show stool',
      iconAssetPath: getImageAssetNameFromTrackerCategory(
        category: TrackerCategory.stool,
      ),
    ),
    HomePageOption(
      id: TrackerCategory.period,
      title: 'Show period',
      iconAssetPath: getImageAssetNameFromTrackerCategory(
        category: TrackerCategory.period,
      ),
    ),
    HomePageOption(
      id: TrackerCategory.weight,
      title: 'Show weight',
      iconAssetPath: getImageAssetNameFromTrackerCategory(
        category: TrackerCategory.weight,
      ),
    ),
    HomePageOption(
      id: TrackerCategory.labReport,
      title: 'Show lab report',
      iconAssetPath: getImageAssetNameFromTrackerCategory(
        category: TrackerCategory.labReport,
      ),
    ),
    HomePageOption(
      id: TrackerCategory.notes,
      title: 'Show notes',
      iconAssetPath: getImageAssetNameFromTrackerCategory(
        category: TrackerCategory.notes,
      ),
    ),
  ];

  List<HomePageOption> get options => _options;

  void toggleOption(TrackerCategory id, bool value) {
    final index = _options.indexWhere((option) => option.id == id);
    if (index != -1) {
      _options[index].isEnabled = value;
    }
    _savePreferences();
    notifyListeners();
  }

  void enableAllOptions() {
    for (final option in _options) {
      option.isEnabled = true;
    }
    _savePreferences();
    notifyListeners();
  }

  bool isOptionEnabled(TrackerCategory id) {
    return _options.firstWhere((option) => option.id == id).isEnabled;
  }

  bool noOptionsEnabled() {
    return _options.every((option) => !option.isEnabled);
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_preferencesKey);
    if (jsonString != null) {
      final List<dynamic> decodedList = json.decode(jsonString);
      final List<HomePageOption> loadedOptions = decodedList
          .map((item) => HomePageOption.fromJson(item as Map<String, dynamic>))
          .toList();

      for (var defaultOption in _options) {
        final loadedOption = loadedOptions.firstWhere(
          (opt) => opt.id == defaultOption.id,
          orElse: () => defaultOption,
        );
        defaultOption.isEnabled = loadedOption.isEnabled;
      }
    }
    notifyListeners();
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    // Encode the list of HomePageOption objects to a JSON string
    final String jsonString =
        json.encode(_options.map((option) => option.toJson()).toList());
    await prefs.setString(_preferencesKey, jsonString);
  }
}
