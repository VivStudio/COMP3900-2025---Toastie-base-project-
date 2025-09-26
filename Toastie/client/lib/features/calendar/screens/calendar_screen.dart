import 'package:flutter/material.dart';
import 'package:toastie/components/header/header_title_centered.dart';
import 'package:toastie/developer_mode.dart';
import 'package:toastie/features/calendar/models/calendar_view_modes.dart';
import 'package:toastie/features/calendar/utils/calendar_utils.dart';
import 'package:toastie/features/calendar/widget/calendar_view_mode_selector.dart';
import 'package:toastie/navigation/app_navigation.dart';
import 'package:toastie/services/services.dart';
import 'package:toastie/shared/widgets/layout/page_container.dart';
import 'package:toastie/themes/theme.dart';
import 'package:toastie/utils/grid.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Now safe to use plugins or async initialization.

  await oneTimeSupabaseInitialisation(); // VERY IMPORTANT - THIS INITIALISES OUR SUPABASE

  runActualApp ? await setUpAuthentication() : await setUpApp();

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
      home: CalendarScreen(),
    );
  }
}

class CalendarScreen extends StatefulWidget {
  CalendarScreen();

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarViewMode _viewMode = CalendarViewMode.month;

  @override
  void initState() {
    super.initState();
  }

  void _changeViewMode(CalendarViewMode mode) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _viewMode = mode;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageContainer(
      childInFactionallySizedBox: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderTitleCentered(
            title: viewModeToString(_viewMode),
          ),
          SizedBox(height: gridbaseline),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                CalendarViewModeSelector(
                  value: _viewMode,
                  onChanged: _changeViewMode,
                ),
              ],
            ),
          ),
          Text('You do not need to implement me'),
        ],
      ),
    );
  }
}
