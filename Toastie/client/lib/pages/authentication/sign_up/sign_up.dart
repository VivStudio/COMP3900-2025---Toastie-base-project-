import 'dart:async';
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
import 'package:toastie/services/authentication/authentication_utils.dart';
import 'package:toastie/utils/grid.dart';
import 'package:toastie/pages/authentication/authentication_button.dart';
import 'package:toastie/pages/authentication/authentication_provider/authentication_provider_utils.dart';
import 'package:toastie/pages/authentication/authentication_provider/google_authentication_provider.dart';
import 'package:toastie/pages/authentication/sign_up/email_sign_up.dart';
import 'package:toastie/services/services.dart';
import 'package:toastie/themes/colors.dart';
import 'package:toastie/themes/theme.dart';

/** For running page in isolation. */
void main() async {
  await setUpApp();
  runApp(ToastieApp());
}

class ToastieApp extends StatelessWidget {
  ToastieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toastie',
      theme: ToastieTheme.defaultTheme,
      home: SignUp(),
    );
  }
}
/** END. */

class SignUp extends StatefulWidget {
  SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  StreamSubscription<AuthState>? _authStateSubscription;

  @override
  void initState() {
    _setupAuthListener();
    super.initState();
  }

  @override
  void dispose() {
    _authStateSubscription?.cancel();
    super.dispose();
  }

  void _setupAuthListener() async {
    _authStateSubscription =
        locator<SupabaseClient>().auth.onAuthStateChange.listen((data) async {
      final event = data.event;
      if (event == AuthChangeEvent.signedIn &&
          locator<SupabaseClient>().auth.currentUser != null) {
        await authenticateUser(type: AuthenticationType.signUp);
      }
    });
  }

  backButtonClicked(BuildContext context) {
    Navigator.of(context).pop();
  }

  _emailSignUp(BuildContext context) {
    // pushReplacement doesn't work here :(
    Navigator.of(context).pop();
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => EmailSignUp()),
    );
  }

  _phoneSignUp(BuildContext context) {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => PhoneLogIn()));
  }

  _logInClicked(BuildContext context) {
    AppNavigation.router.push(logInPath);
  }

  @override
  Widget build(BuildContext context) {
    return PageContainer(
      childInFactionallySizedBox: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          HeaderTitleWithBackButton(
            title: 'Sign up',
            backButtonClicked: () => backButtonClicked(context),
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
              GoogleAuthenticationProvider(type: AuthenticationType.signUp),
              AppleAuthenticationProvider(type: AuthenticationType.signUp),
              AuthenticationButton(
                providerImage: Icon(Icons.email_outlined),
                text: 'Continue with email',
                actionHandler: () async {
                  await _emailSignUp(context);
                },
              ),
              AuthenticationButton(
                providerImage: Icon(Icons.phone_outlined),
                text: 'Continue with phone',
                actionHandler: () => _phoneSignUp(context),
              ),
            ],
          ),
          SizedBox(height: gridbaseline * 4),
          // TODO(TOAS-101): Add links to terms of service and privacy policy.
          Center(
            child: Text(
              'By creating an account, you agree to our Terms of Service and acknowledge that you have read our Privacy Policy.',
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(color: neutral[400]),
            ),
          ),
          SizedBox(height: gridbaseline * 4),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: gridbaseline,
            children: [
              Text(
                'Already have an account?',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              ToastieTextButton(
                actionHandler: () => _logInClicked(context),
                text: 'Log in',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
