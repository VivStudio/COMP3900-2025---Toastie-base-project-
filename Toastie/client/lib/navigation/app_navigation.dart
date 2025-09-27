import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastie/entities/error/error_logs_entity.dart';
import 'package:toastie/navigation/app_navigation_utils.dart';
import 'package:toastie/pages/authentication/log_in/email/email.dart';
import 'package:toastie/pages/authentication/log_in/log_in.dart';
import 'package:toastie/pages/authentication/log_in/phone_log_in.dart';
import 'package:toastie/pages/authentication/sign_up/sign_up.dart';
import 'package:toastie/pages/authentication/start_screen.dart';
import 'package:toastie/pages/home/home.dart';
import 'package:toastie/navigation/scaffold_with_navigation_bar.dart';
import 'package:toastie/features/calendar/calendar.dart';
import 'package:toastie/pages/insights/insights_page.dart';
import 'package:toastie/services/error_logs_service.dart';
import 'package:toastie/services/location_storage_utils.dart';
import 'package:toastie/services/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

StatefulNavigationShell? globalNavigationShell = null;

class AppNavigation {
  factory AppNavigation() {
    return _instance;
  }

  AppNavigation._internal() {
    router = GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: root,
      redirect: (BuildContext context, GoRouterState state) async {
        String? sessionString =
            locator<SharedPreferences>().getString(supabaseSessionKey);
        Session? currentSession = locator<SupabaseClient>().auth.currentSession;

        // If the session string exists and supabase hasn't started a session yet, then recover the session (authentication persistence).
        AuthResponse? response = null;
        if (sessionString != null && currentSession == null) {
          try {
            response = await locator<SupabaseClient>()
                .auth
                .recoverSession(sessionString);
            if (response.session != null) {
              await locator<SharedPreferences>().setBool(
                didRecoverSessionKey,
                true,
              );

              await setUpApp();
              return homePath;
            }
          } catch (error) {
            await locator<ErrorLogsService>().addErrorLog(
              pageName: PageName.authentication,
              errorMessage: '$error sessionString=${sessionString}',
              userId: null,
            );

            await locator<SharedPreferences>().setBool(
              didRecoverSessionKey,
              false,
            );
          }
        }

        // If the session is null, the user is not authenticated so if the user is not on an auth flow, show the 'our story' page.
        bool isAuthFlow = authFlowPaths.contains(state.matchedLocation);
        if (currentSession == null && !isAuthFlow) {
          return startScreenPath;
        }
        return null;
      },
      routes: routes,
    );
  }

  static final AppNavigation _instance = AppNavigation._internal();

  static AppNavigation get instance => _instance;

  static late final GoRouter router;

  static String root = homePath;

  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> _homeNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> _calendarNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> _insightsNavigatorKey =
      GlobalKey<NavigatorState>();

  BuildContext get context =>
      router.routerDelegate.navigatorKey.currentContext!;

  GoRouterDelegate get routerDelegate => router.routerDelegate;

  GoRouteInformationParser get routeInformationParser =>
      router.routeInformationParser;

  static Page getPage({
    required Widget child,
    required GoRouterState state,
  }) {
    return MaterialPage(
      key: state.pageKey,
      child: child,
    );
  }

  void clearStackAndNavigate(String path) {
    while (context.canPop()) {
      context.pop();
    }

    context.pushReplacement(path);
  }

  final routes = [
    StatefulShellRoute.indexedStack(
      parentNavigatorKey: _rootNavigatorKey,
      branches: [
        // Home tab
        StatefulShellBranch(
          navigatorKey: _homeNavigatorKey,
          routes: [
            GoRoute(
              path: homePath,
              name: homeTabName,
              pageBuilder: (context, GoRouterState state) {
                return MaterialPage(child: Home());
              },
              routes: [],
            ),
          ],
        ),
        // Calendar tab
        StatefulShellBranch(
          navigatorKey: _calendarNavigatorKey,
          routes: [
            GoRoute(
              path: calendarPath,
              name: calendarTabName,
              pageBuilder: (context, GoRouterState state) {
                return MaterialPage(
                  child: CalendarScreen(),
                );
              },
              routes: [],
            ),
          ],
        ),
        // Insights tab
        StatefulShellBranch(
          navigatorKey: _insightsNavigatorKey,
          routes: [
            GoRoute(
              path: insightsPath,
              name: insightsName,
              pageBuilder: (context, GoRouterState state) {
                return MaterialPage(child: InsightsPage());
              },
              routes: [],
            ),
          ],
        ),
      ],
      pageBuilder: (
        BuildContext context,
        GoRouterState state,
        StatefulNavigationShell navigationShell,
      ) {
        globalNavigationShell = navigationShell;
        return getPage(
          child: ScaffoldWithNavigationBar(
            navigationShell: navigationShell,
          ),
          state: state,
        );
      },
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: startScreenPath,
      pageBuilder: (context, state) {
        return getPage(
          child: StartScreen(),
          state: state,
        );
      },
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: signUpPath,
      pageBuilder: (context, state) {
        return getPage(
          child: SignUp(),
          state: state,
        );
      },
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: logInPath,
      pageBuilder: (context, state) {
        return getPage(
          child: LogIn(),
          state: state,
        );
      },
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: phoneLogInPath,
      pageBuilder: (context, state) {
        return getPage(
          child: PhoneLogIn(),
          state: state,
        );
      },
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: emailPath,
      pageBuilder: (context, state) {
        return getPage(
          child: Email(),
          state: state,
        );
      },
    ),
  ];
}
