import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:toastie/components/header/header_title_with_back_and_edit_button.dart';
import 'package:toastie/entities/lab_report/lab_report_entity.dart';
import 'package:toastie/navigation/app_navigation.dart';
import 'package:toastie/features/lab_report/widgets/report_editor/report_editor.dart';
import 'package:toastie/services/services.dart';
import 'package:toastie/shared/widgets/layout/page_container.dart';
import 'package:toastie/themes/theme.dart';
import 'package:toastie/utils/grid.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Now safe to use plugins or async initialization.

  oneTimeSupabaseInitialisation(); // VERY IMPORTANT - THIS INITIALISES OUR SUPABASE

  await setUpApp();
  AppNavigation.instance;
  runApp(ReportCardScreenApp());
}

class ReportCardScreenApp extends StatefulWidget {
  ReportCardScreenApp({super.key});

  @override
  State<ReportCardScreenApp> createState() => _ReportCardScreenAppState();
}

class _ReportCardScreenAppState extends State<ReportCardScreenApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toastie',
      theme: ToastieTheme.defaultTheme,
      debugShowCheckedModeBanner: false,
      home: ReportCardScreen(
        entity: LabReportEntity(),
      ),
    );
  }
}

class ReportCardScreen extends StatefulWidget {
  ReportCardScreen({
    required this.entity,
    this.processingResults = const [],
  });

  final LabReportEntity entity;
  final List<Future<GenerateContentResponse>> processingResults;

  @override
  State<ReportCardScreen> createState() => _ReportCardScreenState();
}

class _ReportCardScreenState extends State<ReportCardScreen> {
  bool isEditState = false;
  List<Function> saveMethods = [];

  void backButtonClicked(BuildContext context) {
    Navigator.of(context).pop(true);
  }

  void editButtonClicked(BuildContext context) {
    setState(() {
      isEditState = true;
    });
  }

  void doneButtonClicked(BuildContext context) async {
    saveDetails();

    setState(() {
      isEditState = false;
    });
  }

  void saveDetails() {
    saveMethods.forEach((save) => save());
  }

  @override
  Widget build(BuildContext context) {
    return PageContainer(
      childInFactionallySizedBox: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            HeaderTitleWithBackAndEditButton(
              title: 'Report',
              isEditState: isEditState,
              backButtonClicked: () => backButtonClicked(context),
              editButtonClicked: () => editButtonClicked(context),
              doneButtonClicked: () => doneButtonClicked(context),
            ),
            SizedBox(height: gridbaseline * 2),
            ReportEditor(
              entity: widget.entity,
              processingResults: widget.processingResults,
              isEditState: isEditState,
              saveMethods: saveMethods,
            ),
          ],
        ),
      ),
    );
  }
}
