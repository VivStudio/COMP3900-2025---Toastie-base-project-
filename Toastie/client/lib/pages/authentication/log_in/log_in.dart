import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:toastie/components/button/text_button.dart';
import 'package:toastie/components/header/header_title_with_back_button.dart';
import 'package:toastie/pages/authentication/authentication_provider/apple_authentication_provider.dart';
import 'package:toastie/pages/authentication/log_in/phone_log_in.dart';
import 'package:toastie/shared/widgets/layout/page_container.dart';
import 'package:toastie/developer_mode.dart';
import 'package:toastie/navigation/app_navigation.dart';
import 'package:toastie/navigation/app_navigation_utils.dart';
import 'package:toastie/pages/authentication/authentication_button.dart';
import 'package:toastie/pages/authentication/authentication_provider/authentication_provider_utils.dart';
import 'package:toastie/pages/authentication/authentication_provider/google_authentication_provider.dart';
import 'package:toastie/services/authentication/authentication_utils.dart';
import 'package:toastie/services/location_storage_utils.dart';
import 'package:toastie/services/services.dart';
import 'package:toastie/themes/colors.dart';
import 'package:toastie/themes/text/text.dart';
import 'package:toastie/themes/theme.dart';
import 'package:toastie/utils/grid.dart';

/** For running page in isolation. */
void main() async {
  await setUpApp();
  runApp(ToastieApp());
}

class ToastieApp extends StatelessWidget {
  ToastieApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toastie',
      theme: ToastieTheme.defaultTheme,
      home: LogIn(),
    );
  }
}
/** END. */

class LogIn extends StatefulWidget {
  LogIn();

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  @override
  void initState() {
    _setupAuthListener();
    super.initState();
  }

  void _setupAuthListener() async {
    locator<SupabaseClient>().auth.onAuthStateChange.listen((data) async {
      final event = data.event;
      if (event == AuthChangeEvent.signedIn &&
          locator<SupabaseClient>().auth.currentUser != null) {
        await authenticateUser(type: AuthenticationType.logIn);
        await addSessionToCache();
      }

      // Probably need to do this later:
      // await setUpApp();
      // AppNavigation.router.go(homePath);
    });
  }

  void _backButtonClicked(BuildContext context) {
    AppNavigation.router.pop();
  }

  Future<void> _emailLogIn(BuildContext context) async {
    AppNavigation.router.push(emailPath);
  }

  _phoneLogIn(BuildContext context) {
    AppNavigation.router.push(phoneLogInPath);
  }

  void _signUpClicked(BuildContext context) {
    AppNavigation.router.push(signUpPath);
  }

  @override
  Widget build(BuildContext context) {
    return PageContainer(
      childInFactionallySizedBox: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          HeaderTitleWithBackButton(
            title: 'Log In',
            backButtonClicked: () => _backButtonClicked(context),
          ),
          Center(
            child: Image(
              height: authenticationLogoSize(context),
              image: AssetImage('assets/logo.png'),
            ),
          ),
          SizedBox(height: gridbaseline * 4),
          Wrap(
            runSpacing: gridbaseline * 2,
            children: [
              GoogleAuthenticationProvider(type: AuthenticationType.logIn),
              AppleAuthenticationProvider(type: AuthenticationType.logIn),
              AuthenticationButton(
                providerImage: Icon(Icons.email_outlined),
                text: 'Continue with Email',
                actionHandler: () => _emailLogIn(context),
              ),
              AuthenticationButton(
                providerImage: Icon(Icons.phone_outlined),
                text: 'Continue with phone',
                actionHandler: () => _phoneLogIn(context),
              ),
            ],
          ),
          SizedBox(height: gridbaseline * 4),
          // TODO(TOAS-101): Add links to terms of service and privacy policy.
          Center(
            child: Text(
              'By continuing with an account, you agree to our Terms of Service and acknowledge that you have read our Privacy Policy.',
              style: labelSmallTextWithColor(context, neutral[400]!),
            ),
          ),
          SizedBox(height: gridbaseline * 4),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: gridbaseline,
            children: [
              Text(
                "Don't have have an account?",
                style: Theme.of(context).textTheme.labelMedium,
              ),
              ToastieTextButton(
                actionHandler: () => _signUpClicked(context),
                text: 'Sign up',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
