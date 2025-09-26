import 'package:flutter/material.dart';
import 'package:toastie/components/button/gradient_button.dart';
import 'package:toastie/components/button/toggle_button.dart';
import 'package:toastie/components/header/header_title_centered.dart';
import 'package:toastie/components/header/header_title_with_back_button.dart';
import 'package:toastie/shared/widgets/layout/page_container.dart';
import 'package:toastie/entities/lab_report/lab_report_entity.dart';
import 'package:toastie/navigation/app_navigation.dart';
import 'package:toastie/features/lab_report/add_report.dart';
import 'package:toastie/features/lab_report/widgets/lab_report_card.dart';
import 'package:toastie/features/lab_report/screens/report_card_screen.dart';
import 'package:toastie/services/lab_report_service.dart';
import 'package:toastie/services/services.dart';
import 'package:toastie/themes/gradient_background_colors.dart';
import 'package:toastie/themes/linear_gradient_colors.dart';
import 'package:toastie/themes/theme.dart';
import 'package:toastie/utils/layout/border_radius.dart';
import 'package:toastie/utils/layout/grid.dart';
import 'package:toastie/utils/layout/padding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Now safe to use plugins or async initialization.

  oneTimeSupabaseInitialisation(); // VERY IMPORTANT - THIS INITIALISES OUR SUPABASE

  await setUpApp();
  AppNavigation.instance;
  runApp(LabReportScreenApp());
}

class LabReportScreenApp extends StatelessWidget {
  LabReportScreenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toastie',
      theme: ToastieTheme.defaultTheme,
      debugShowCheckedModeBanner: false,
      home: LabReportScreen(),
    );
  }
}

class LabReportScreen extends StatefulWidget {
  LabReportScreen();

  @override
  State<LabReportScreen> createState() => _LabReportScreenState();
}

class _LabReportScreenState extends State<LabReportScreen> {
  ReportType _selectedTab = ReportType.imaging;
  List<LabReportEntity> _labReports = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLabReports();
  }

  Future<void> _fetchLabReports() async {
    setState(() {
      _isLoading = true;
    });

    List<LabReportEntity> reports =
        await locator<LabReportService>().getLabReportsByType(
      type: _selectedTab,
    );

    setState(() {
      _labReports = reports;
      _isLoading = false;
    });
  }

  void backButtonClicked(BuildContext context) {
    Navigator.of(context).pop();
  }

  void switchTab({required ReportType newTab}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _selectedTab = newTab;
      });
      _fetchLabReports();
    });
  }

  void navigateToReportCard({
    required BuildContext context,
    required LabReportEntity entity,
  }) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ReportCardScreen(
          entity: entity,
          // processingResults: [Future.delayed(Duration(seconds: 3))],
        ),
      ),
    );

    // If result is true, changes were made so refresh the data
    if (result == true) {
      _fetchLabReports();
    }
  }

  Widget AddReportBottomsheet() {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) => SingleChildScrollView(
        controller: scrollController,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: EdgeInsets.only(
                top: cardLargeInnerPadding.vertical / 2,
                right: cardLargeInnerPadding.horizontal / 2,
                left: cardHeaderPadding.horizontal / 2,
                bottom: cardLargeInnerPadding.vertical,
              ),
              child: Wrap(
                alignment: WrapAlignment.center,
                children: [
                  HeaderTitleCentered(
                    title: 'Add report',
                  ),
                  SizedBox(height: gridbaseline * 6),
                  AddReport(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _addReportClicked({required BuildContext context}) async {
    final result = await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: topBorderRadius,
      ),
      builder: (BuildContext context) {
        return AddReportBottomsheet();
      },
    );

    // If result is true, a new report was added so refresh the data
    if (result == true) {
      _fetchLabReports();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageContainer(
      color: primaryToNeutralGradientBackground,
      childInFactionallySizedBox: SizedBox.expand(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  HeaderTitleWithBackButton(
                    title: 'Reports',
                    backButtonClicked: () => backButtonClicked(context),
                  ),
                  ToastieToggleButton(
                    selectedTab: _selectedTab,
                    actionHandler: switchTab,
                  ),
                  SizedBox(height: gridbaseline * 2),
                  _isLoading
                      ? Padding(
                          padding: EdgeInsets.only(top: gridbaseline * 2),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      : Padding(
                          padding: EdgeInsets.only(
                            bottom: gridbaseline * gridbaseline,
                          ),
                          child: Wrap(
                            runSpacing: gridbaseline,
                            children: _labReports.map((report) {
                              return LabReportCard(
                                labReport: report,
                                actionHandler: () => navigateToReportCard(
                                  context: context,
                                  entity: report,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SafeArea(
                minimum: EdgeInsets.all(gridbaseline),
                child: GradientButton(
                  actionHandler: () => _addReportClicked(context: context),
                  gradient: gradientButtonMain,
                  text: 'Add report',
                  withTopPadding: false,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
