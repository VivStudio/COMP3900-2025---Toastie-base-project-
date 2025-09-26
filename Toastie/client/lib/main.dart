import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toastie/core/core.dart';
import 'package:toastie/developer_mode.dart';
import 'package:toastie/features/settings/settings.dart';
import 'package:toastie/navigation/app_navigation.dart';
import 'package:toastie/services/services.dart';
import 'package:toastie/themes/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Now safe to use plugins or async initialization.

  await oneTimeSupabaseInitialisation(); // VERY IMPORTANT - THIS INITIALISES OUR SUPABASE

  runActualApp ? await setUpAuthentication() : await setUpApp();

  AppNavigation.instance;
  runApp(MainToastieApp());
}

class MainToastieApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<HomeCustomizationProvider>(
          create: (BuildContext context) => HomeCustomizationProvider(),
          lazy: false,
        ),
      ],
      child: LifecycleHandler(
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: AppNavigation.router,
          title: 'Toastie',
          theme: ToastieTheme.defaultTheme,
        ),
      ),
    );
  }
}
