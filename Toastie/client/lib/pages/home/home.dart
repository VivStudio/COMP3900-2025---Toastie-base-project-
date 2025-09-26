import 'dart:async';

import 'package:flutter/material.dart';
import 'package:toastie/components/button/button.dart';
import 'package:toastie/components/button/gradient_button.dart';
import 'package:toastie/components/loading_animation.dart';
import 'package:toastie/entities/lab_report/lab_report_entity.dart';
import 'package:toastie/features/settings/widgets/customise_home.dart';
import 'package:toastie/services/lab_report_service.dart';
import 'package:toastie/shared/widgets/layout/page_container.dart';
import 'package:toastie/navigation/app_navigation.dart';
import 'package:toastie/pages/home/day_carousel.dart';
import 'package:toastie/pages/home/home_utils.dart';
import 'package:toastie/pages/home/magic_tracker.dart';
import 'package:toastie/pages/home/summary_card.dart';
import 'package:toastie/features/settings/screens/settings_screen.dart';
import 'package:toastie/services/location_storage_utils.dart';
import 'package:toastie/services/services.dart';
import 'package:toastie/themes/colors.dart';
import 'package:toastie/themes/gradient_background_colors.dart';
import 'package:toastie/themes/linear_gradient_colors.dart';
import 'package:toastie/themes/text/text_utils.dart';
import 'package:toastie/themes/theme.dart';
import 'package:toastie/themes/text/text.dart';
import 'package:toastie/services/trackers/food/meal_log_service.dart';
import 'package:toastie/services/trackers/medication_logs_service.dart';
import 'package:toastie/services/trackers/note_logs_service.dart';
import 'package:toastie/services/trackers/period_logs_service.dart';
import 'package:toastie/services/trackers/stool_logs_service.dart';
import 'package:toastie/services/trackers/symptom/symptom_logs_service.dart';
import 'package:toastie/services/trackers/weight_logs_service.dart';
import 'package:toastie/entities/trackers/food/meal_log_entity.dart';
import 'package:toastie/entities/trackers/medication_logs_entity.dart';
import 'package:toastie/entities/trackers/note_logs_entity.dart';
import 'package:toastie/entities/trackers/period_logs_entity.dart';
import 'package:toastie/entities/trackers/stool_logs_entity.dart';
import 'package:toastie/entities/trackers/symptom/symptom_logs_entity.dart';
import 'package:toastie/entities/trackers/weight_logs_entity.dart';
import 'package:toastie/utils/grid.dart';
import 'package:toastie/utils/responsive_utils.dart';
import 'package:toastie/utils/tracker_utils.dart';
import 'package:provider/provider.dart';
import 'package:toastie/features/settings/providers/home_customization_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Now safe to use plugins or async initialization.

  oneTimeSupabaseInitialisation(); // VERY IMPORTANT - THIS INITIALISES OUR SUPABASE

  await setUpApp();
  AppNavigation.instance;
  runApp(ToastieApp());
}

class ToastieApp extends StatelessWidget {
  ToastieApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppNavigation.router,
      title: 'Toastie',
      theme: ToastieTheme.defaultTheme,
    );
  }
}

class Home extends StatefulWidget {
  Home({DateTime? date}) : date = date ?? DateTime.now();

  final DateTime date;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _userName = '';
  late final DayCarousel _dayCarousel;
  bool _isFetchingData = false;

  List<SymptomLogsEntity?>? symptoms = [];
  List<MedicationLogsEntity?>? medications = [];
  List<MealLogEntity?>? meals = [];
  List<StoolLogsEntity?>? stool = [];
  PeriodLogsEntity? period;
  WeightLogsEntity? weight;
  List<LabReportEntity> labReports = [];
  NoteLogsEntity? notes;

  String symptomSummary = '';
  String medicationSummary = '';
  String foodSummary = '';
  String stoolSummary = '';
  String periodSummary = '';
  String weightSummary = '';
  String labReportSummary = '';
  String noteSummary = '';

  @override
  void initState() {
    super.initState();
    _dayCarousel = DayCarousel(date: widget.date, fetchData: fetchData);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchData();
    });
  }

  void _profileClicked({required BuildContext context}) {
    showSettingsModal(context: context)
        .then(
          (value) => {
            _fetchName(),
          },
        )
        .then(
          (value) => {
            _fetchName(),
          },
        );
  }

  void _navigateToSummaryClicked(BuildContext context) {
    // No-op.
  }

  Future _fetchName() async {
    _userName = await getNameFromCache();
    setState(() {});
  }

  Future fetchData() async {
    _clearData();
    await _fetchName();

    final customizationProvider =
        Provider.of<HomeCustomizationProvider>(context, listen: false);

    /*
     * Use dayCarousel.getDate(); for current date.
     */
    DateTime date = _dayCarousel.getDate();

    Future<List<SymptomLogsEntity?>?> fetchSymptoms;
    if (customizationProvider.isOptionEnabled(TrackerCategory.symptom)) {
      fetchSymptoms = locator<SymptomLogsService>().getSymptomDetailsForDay(
        date: date,
      );
    } else {
      fetchSymptoms = Future.value(null);
    }

    Future<List<MedicationLogsEntity?>?> fetchMedications;
    if (customizationProvider.isOptionEnabled(TrackerCategory.medication)) {
      fetchMedications =
          locator<MedicationLogsService>().getMedicationDetailsForDay(
        date: date,
      );
    } else {
      fetchMedications = Future.value(null);
    }

    Future<List<MealLogEntity?>?> fetchMeals;
    if (customizationProvider.isOptionEnabled(TrackerCategory.food)) {
      fetchMeals = locator<MealLogService>().getMealDetailsForDay(
        date: date,
      );
    } else {
      fetchMeals = Future.value(null);
    }

    Future<List<StoolLogsEntity?>?> fetchStools;
    if (customizationProvider.isOptionEnabled(TrackerCategory.stool)) {
      fetchStools = locator<StoolLogsService>().getStoolDetailsForDay(
        date: date,
      );
    } else {
      fetchStools = Future.value(null);
    }

    Future<PeriodLogsEntity?> fetchPeriods;
    if (customizationProvider.isOptionEnabled(TrackerCategory.period)) {
      fetchPeriods = locator<PeriodLogsService>().getPeriodDetailsForDay(
        date: date,
      );
    } else {
      fetchPeriods = Future.value(null);
    }

    Future<WeightLogsEntity?> fetchWeight;
    if (customizationProvider.isOptionEnabled(TrackerCategory.weight)) {
      fetchWeight = locator<WeightLogsService>().getWeightForDay(
        date: date,
      );
    } else {
      fetchWeight = Future.value(null);
    }

    Future<List<LabReportEntity>> fetchLabReports;
    if (customizationProvider.isOptionEnabled(TrackerCategory.labReport)) {
      fetchLabReports = locator<LabReportService>().getLabReportsForDay(
        date: date,
      );
    } else {
      fetchLabReports = Future.value([]);
    }

    Future<NoteLogsEntity?> fetchNotes;
    if (customizationProvider.isOptionEnabled(TrackerCategory.notes)) {
      fetchNotes = locator<NoteLogsService>().getNoteDetailsForDay(
        date: date,
      );
    } else {
      fetchNotes = Future.value(null);
    }

    List<Future> homeFetchTasks = [
      fetchSymptoms,
      fetchMedications,
      fetchMeals,
      fetchStools,
      fetchPeriods,
      fetchWeight,
      fetchLabReports,
      fetchNotes,
    ];

    // Start a timer to show loading state if the data takes more than 1 second to fetch.
    Timer loadingTimer = Timer(Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isFetchingData = true;
        });
      }
    });
    await Future.wait(homeFetchTasks);

    symptoms = await fetchSymptoms;
    medications = await fetchMedications;
    meals = await fetchMeals;
    stool = await fetchStools;
    period = await fetchPeriods;
    weight = await fetchWeight;
    labReports = await fetchLabReports;
    notes = await fetchNotes;

    setState(() {
      symptomSummary = getListSummary(
        symptoms?.map((symptom) => symptom?.details?.name ?? '').toList(),
      );
      medicationSummary = getListSummary(
        medications?.map((medication) => medication?.name ?? '').toList(),
      );
      foodSummary = getListSummary(
        meals?.map((meal) => meal?.name ?? '').toList(),
      );
      stoolSummary = getStoolSummary(stool);
      periodSummary = getPeriodSummary(period);
      weightSummary = getWeightSummary(weight);
      labReportSummary = getListSummary(
        labReports.map((report) => report.name ?? '').toList(),
      );
      noteSummary = getNoteSummary(notes);
      _isFetchingData = false;
      loadingTimer.cancel();
    });
  }

  void _clearData() {
    setState(() {
      symptomSummary = '';
      medicationSummary = '';
      foodSummary = '';
      stoolSummary = '';
      periodSummary = '';
      weightSummary = '';
      noteSummary = '';
    });
  }

  bool _hasNoTrackedData() {
    final allData = [
      symptomSummary,
      medicationSummary,
      foodSummary,
      stoolSummary,
      periodSummary,
      weightSummary,
      noteSummary,
    ];
    return allData.every((summary) => summary.isEmpty);
  }

  void showOverviewSummaryPageForCategory({
    required BuildContext context,
    required TrackerCategory categoryType,
  }) {
    // No-op.
  }

  void _customiseHomeScreenClicked({required BuildContext context}) async {
    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      useSafeArea: true,
      isDismissible: true,
      enableDrag: true,
      shape: RoundedRectangleBorder(
        borderRadius: topBorderRadius,
      ),
      builder: (BuildContext context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: CustomiseHome(),
        );
      },
    );
  }

  Widget SummaryCards({
    required BuildContext context,
    required HomeCustomizationProvider customizationProvider,
  }) {
    return Column(
      children: <Widget>[
        _hasNoTrackedData()
            ? SizedBox(height: gridbaseline)
            : Button(
                text: 'Edit summary',
                actionHandler: () => _navigateToSummaryClicked(context),
                color: primary,
                buttonType: ButtonType.TextButton,
              ),
        if (customizationProvider.noOptionsEnabled())
          FractionallySizedBox(
            widthFactor: 0.8,
            child: Column(
              children: [
                ClipOval(
                  child: Image(
                    image: AssetImage('assets/track.png'),
                    height: headerSmallImageSize(context),
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  height: gridbaseline * 2,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'No trackers enabled.',
                      textAlign: TextAlign.center,
                      style: titleMediumTextWithColor(
                        context: context,
                        color: primary[900]!,
                      ),
                    ),
                    SizedBox(height: gridbaseline),
                    Text(
                      'You can customize your home page anytime in settings.',
                      textAlign: TextAlign.center,
                      style: bodyMediumTextWithColor(
                        context: context,
                        color: primary[700]!,
                      ),
                    ),
                    GradientButton(
                      actionHandler: () =>
                          _customiseHomeScreenClicked(context: context),
                      text: 'Customize trackers',
                      gradient: gradientButtonMain,
                    ),
                    SizedBox(height: gridbaseline),
                  ],
                ),
              ],
            ),
          ),
        Wrap(
          alignment: WrapAlignment.center,
          runSpacing: gridbaseline,
          children: [
            if (customizationProvider.isOptionEnabled(TrackerCategory.symptom))
              SummaryCard(
                type: TrackerCategory.symptom,
                summaryDetails: symptomSummary,
                date: _dayCarousel.getDate(),
                reloadHomePage: fetchData,
                onSummaryCardTap: symptomSummary.isNotEmpty
                    ? () => showOverviewSummaryPageForCategory(
                          context: context,
                          categoryType: TrackerCategory.symptom,
                        )
                    : null,
              ),
            if (customizationProvider
                .isOptionEnabled(TrackerCategory.medication))
              SummaryCard(
                type: TrackerCategory.medication,
                summaryDetails: medicationSummary,
                date: _dayCarousel.getDate(),
                reloadHomePage: fetchData,
                onSummaryCardTap: medicationSummary.isNotEmpty
                    ? () => showOverviewSummaryPageForCategory(
                          context: context,
                          categoryType: TrackerCategory.medication,
                        )
                    : null,
                child: Container(),
              ),
            if (customizationProvider.isOptionEnabled(TrackerCategory.food))
              SummaryCard(
                type: TrackerCategory.food,
                summaryDetails: foodSummary,
                date: _dayCarousel.getDate(),
                reloadHomePage: fetchData,
                onSummaryCardTap: foodSummary.isNotEmpty
                    ? () => showOverviewSummaryPageForCategory(
                          context: context,
                          categoryType: TrackerCategory.food,
                        )
                    : null,
              ),
            if (customizationProvider.isOptionEnabled(TrackerCategory.stool))
              SummaryCard(
                type: TrackerCategory.stool,
                summaryDetails: stoolSummary,
                date: _dayCarousel.getDate(),
                reloadHomePage: fetchData,
                onSummaryCardTap: stoolSummary.isNotEmpty
                    ? () => showOverviewSummaryPageForCategory(
                          context: context,
                          categoryType: TrackerCategory.stool,
                        )
                    : null,
              ),
            if (customizationProvider.isOptionEnabled(TrackerCategory.period))
              SummaryCard(
                type: TrackerCategory.period,
                summaryDetails: periodSummary,
                date: _dayCarousel.getDate(),
                reloadHomePage: fetchData,
                onSummaryCardTap: null,
              ),
            if (customizationProvider.isOptionEnabled(TrackerCategory.weight))
              SummaryCard(
                type: TrackerCategory.weight,
                summaryDetails: weightSummary,
                date: _dayCarousel.getDate(),
                reloadHomePage: fetchData,
                onSummaryCardTap: null,
              ),
            if (customizationProvider
                .isOptionEnabled(TrackerCategory.labReport))
              SummaryCard(
                type: TrackerCategory.labReport,
                summaryDetails: labReportSummary,
                date: _dayCarousel.getDate(),
                reloadHomePage: fetchData,
                onSummaryCardTap: labReportSummary.isNotEmpty
                    ? () => showOverviewSummaryPageForCategory(
                          context: context,
                          categoryType: TrackerCategory.labReport,
                        )
                    : null,
              ),
            if (customizationProvider.isOptionEnabled(TrackerCategory.notes))
              SummaryCard(
                type: TrackerCategory.notes,
                summaryDetails: noteSummary,
                date: _dayCarousel.getDate(),
                reloadHomePage: fetchData,
                onSummaryCardTap: null,
              ),
          ],
        ),
        SizedBox(height: gridbaseline),
      ],
    );
  }

  Widget ProfileIcon({required BuildContext context}) {
    final double imageSize = scaleBySystemFont(
      context: context,
      size: gridbaseline * 7,
    );

    return GestureDetector(
      onTap: () => _profileClicked(context: context),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: imageSize,
            width: imageSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 1),
              image: DecorationImage(
                image: AssetImage('assets/defaultProfilePicture.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: -4,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_drop_down,
                size: scaleBySystemFont(
                  context: context,
                  size: gridbaseline * 2,
                ),
                color: primary[900],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget WelcomeAndSettings({required BuildContext context}) {
    return shouldAdaptForAccessibility(context: context)
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileIcon(context: context),
              SizedBox(height: gridbaseline * 2),
              Text(
                'Hi ${_userName}',
                style: displayMediumTextWithColor(
                  context: context,
                  color: primary[600]!,
                  fontFamily: ToastieFontFamily.libreBaskerville,
                ),
              ),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Hi ${_userName}',
                  style: displayMediumTextWithColor(
                    context: context,
                    color: primary[600]!,
                    fontFamily: ToastieFontFamily.libreBaskerville,
                  ),
                ),
              ),
              ProfileIcon(context: context),
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    return PageContainer(
      color: primaryGradientBackground,
      childInFactionallySizedBox: SingleChildScrollView(
        child: Column(
          children: [
            Wrap(
              runSpacing: gridbaseline,
              alignment: WrapAlignment.center,
              children: [
                WelcomeAndSettings(context: context),
                _dayCarousel,
                MagicTracker(
                  date: _dayCarousel.getDate(),
                  reloadHomePage: fetchData,
                ),
              ],
            ),
            _isFetchingData
                ? LoadingAnimation()
                : Consumer<HomeCustomizationProvider>(
                    builder: (context, customizationProvider, child) {
                      return SummaryCards(
                        context: context,
                        customizationProvider: customizationProvider,
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
