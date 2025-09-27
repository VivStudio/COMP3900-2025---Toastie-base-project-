import 'package:flutter/material.dart';
import 'package:toastie/components/header/header_title.dart';
import 'package:toastie/shared/widgets/layout/page_container.dart';
import 'package:toastie/navigation/app_navigation.dart';
import 'package:toastie/services/services.dart';
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
      home: InsightsPage(),
    );
  }
}

class InsightsPage extends StatelessWidget {
  InsightsPage();

  @override
  Widget build(BuildContext context) {
    return PageContainer(
      childInFactionallySizedBox: SingleChildScrollView(
        child: Column(
          children: [
            HeaderTitle(
              title: 'Insights',
            ),
            Text('TODO: 3900-F09B-BANANA Implement Doctor Summary'),
          ],
        ),
      ),
    );
  }
}
