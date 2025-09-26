import 'package:flutter/material.dart';
import 'package:toastie/components/header/header_title.dart';
import 'package:toastie/entities/lab_report/lab_report_entity.dart';
import 'package:toastie/entities/trackers/food/meal_log_entity.dart';
import 'package:toastie/entities/trackers/medication_logs_entity.dart';
import 'package:toastie/entities/trackers/note_logs_entity.dart';
import 'package:toastie/entities/trackers/period_logs_entity.dart';
import 'package:toastie/entities/trackers/stool_logs_entity.dart';
import 'package:toastie/entities/trackers/symptom/symptom_logs_entity.dart';
import 'package:toastie/entities/trackers/weight_logs_entity.dart';
import 'package:toastie/features/lab_report/lab_report.dart';
import 'package:toastie/features/meal/meal.dart';
import 'package:toastie/features/medication/widget/medication_card.dart';
import 'package:toastie/features/note/widget/note_card.dart';
import 'package:toastie/features/period/widget/period_card.dart';
import 'package:toastie/features/stool/widget/stool_card.dart';
import 'package:toastie/features/symptom/symptom.dart';
import 'package:toastie/features/weight/weight.dart';
import 'package:toastie/shared/widgets/layout/page_container.dart';
import 'package:toastie/navigation/app_navigation.dart';
import 'package:toastie/services/services.dart';
import 'package:toastie/themes/theme.dart';
import 'package:toastie/utils/layout/grid.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Now safe to use plugins or async initialization.

  oneTimeSupabaseInitialisation(); // VERY IMPORTANT - THIS INITIALISES OUR SUPABASE

  await setUpApp();
  AppNavigation.instance;
  runApp(ToastieApp());
}

class ToastieApp extends StatelessWidget {
  ToastieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toastie',
      theme: ToastieTheme.defaultTheme,
      debugShowCheckedModeBanner: false,
      home: Gallery(),
    );
  }
}

class Gallery extends StatelessWidget {
  Gallery();

  @override
  Widget build(BuildContext context) {
    return PageContainer(
      childInFactionallySizedBox: SingleChildScrollView(
        child: Column(
          children: [
            HeaderTitle(title: 'Gallery'),
            SizedBox(height: gridbaseline * 2),
            SymptomCard(
              symptom: SymptomLogsEntity(
                log_id: 1,
                date_time: DateTime.now().millisecondsSinceEpoch,
                details: SymptomDetails(name: 'Headache', symptom_id: 1),
                severity: SymptomSeverity.moderate,
              ),
            ),
            MedicationCard(
              medication: MedicationLogsEntity(
                log_id: 1,
                date_time: DateTime.now().millisecondsSinceEpoch,
                name: 'Paracetamol',
                dose: '500mg',
                quantity: 2,
                schedule_id: 1,
              ),
            ),
            MealCard(
              meal: MealLogEntity(
                log_id: 1,
                date_time: DateTime.now().millisecondsSinceEpoch,
                name: 'Avocado Toast',
                type: MealType.breakfast,
                ingredient_details: [
                  IngredientDetails(log_id: 1, name: 'Avocado'),
                  IngredientDetails(log_id: 2, name: 'Bread'),
                ],
                dish_ids: [],
                photo_ids: [],
              ),
            ),
            StoolCard(
              stool: StoolLogsEntity(
                log_id: 1,
                date_time: DateTime.now().millisecondsSinceEpoch,
                severity: BristolScale.type4,
              ),
            ),
            PeriodCard(
              period: PeriodLogsEntity(
                log_id: 1,
                date_time: DateTime.now().millisecondsSinceEpoch,
                severity: PeriodFlow.heavy,
                period_id: 2,
              ),
            ),
            MedicalRecordCard(
              medicalRecord: LabReportEntity(
                id: 1,
                date_time: DateTime.now().millisecondsSinceEpoch,
                type: ReportType.lab,
                name: 'Blood Test Report',
                notes: 'No significant issues found.',
                summary: 'All parameters within normal range.',
                photo_ids: [],
                referred_by: 'Dr. Smith',
                examined_by: 'Dr. Smith',
              ),
            ),
            WeightCard(
              weight: WeightLogsEntity(
                log_id: 1,
                date_time: DateTime.now().millisecondsSinceEpoch,
                weight: 50.5,
              ),
            ),
            NoteCard(
              note: NoteLogsEntity(
                log_id: 1,
                date_time: DateTime.now().millisecondsSinceEpoch,
                note: 'This is a sample note.',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
