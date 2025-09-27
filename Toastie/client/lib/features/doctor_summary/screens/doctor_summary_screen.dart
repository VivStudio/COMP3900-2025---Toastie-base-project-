import 'package:flutter/material.dart';
import 'package:toastie/components/header/header_title_with_back_button.dart';
import 'package:toastie/navigation/app_navigation.dart';
import 'package:toastie/services/services.dart';
import 'package:toastie/shared/widgets/layout/layout.dart';
import 'package:toastie/themes/theme.dart';

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
      home: DoctorSummaryScreen(),
    );
  }
}

class DoctorSummaryScreen extends StatefulWidget {
  const DoctorSummaryScreen({super.key});

  @override
  State<DoctorSummaryScreen> createState() => _DoctorSummaryScreenState();
}

class _DoctorSummaryScreenState extends State<DoctorSummaryScreen> {
  void _backButtonClicked(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return PageContainer(
      childInFactionallySizedBox: SingleChildScrollView(
        child: Column(
          children: [
            HeaderTitleWithBackButton(
              title: 'Insights',
              backButtonClicked: () => _backButtonClicked(context),
            ),
            Text('TODO: 3900-F09B-BANANA Implement Doctor Summary'),
          ],
        ),
      ),
    );
  }
}
