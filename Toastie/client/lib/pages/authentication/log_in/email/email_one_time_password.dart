import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastie/components/button/text_button.dart';
import 'package:toastie/components/divider.dart';
import 'package:toastie/components/error_message_card.dart';
import 'package:toastie/components/button/gradient_button.dart';
import 'package:toastie/components/header/header_title_with_back_button.dart';
import 'package:toastie/shared/widgets/layout/page_container.dart';
import 'package:toastie/components/text_field.dart';
import 'package:toastie/pages/authentication/log_in/email/reset_password.dart';
import 'package:toastie/pages/authentication/authentication_provider/authentication_provider_utils.dart';
import 'package:toastie/pages/authentication/authentication_provider/google_authentication_provider.dart';
import 'package:toastie/navigation/app_navigation.dart';
import 'package:toastie/navigation/app_navigation_utils.dart';
import 'package:toastie/services/services.dart';
import 'package:toastie/themes/linear_gradient_colors.dart';
import 'package:toastie/themes/theme.dart';
import 'package:toastie/utils/grid.dart';

/** For running page in isolation. */
void main() async {
  setUpApp();
  runApp(ToastieApp());
}

class ToastieApp extends StatelessWidget {
  const ToastieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toastie',
      theme: ToastieTheme.defaultTheme,
      home: EmailOneTimePassword(
        email: 'viv@toastie.au',
      ),
    );
  }
}
/** END. */

enum EmailOneTimePasswordType {
  LogIn,
  ResetPassword,
}

class EmailOneTimePassword extends StatefulWidget {
  EmailOneTimePassword({
    required this.email,
    this.type = EmailOneTimePasswordType.LogIn,
  });

  final EmailOneTimePasswordType type;
  final String email;

  @override
  State<EmailOneTimePassword> createState() => _EmailOneTimePasswordState();
}

class _EmailOneTimePasswordState extends State<EmailOneTimePassword> {
  bool _errorLogginIn = false;
  static int _otpResendCooldownSeconds = 30;
  int _otpCountdownSeconds = _otpResendCooldownSeconds;
  TextEditingController controller = TextEditingController();
  Timer? timer;

  @override
  void initState() {
    _sendOneTimePassword();
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    controller.dispose();
    super.dispose();
  }

  void _startTimer() {
    // Required, in case there is a timer active. This can happen when the user clicks on the 'resend code' before the countdown hits 0.
    timer?.cancel();

    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      if (_otpCountdownSeconds > 0) {
        _otpCountdownSeconds--;
      } else {
        timer?.cancel();
      }

      setState(() {});
    });
  }

  _sendOneTimePassword() {
    locator<SupabaseClient>().auth.signInWithOtp(email: widget.email);
    setState(() {
      _otpCountdownSeconds = _otpResendCooldownSeconds;
      _startTimer();
    });
  }

  _backButtonClicked(BuildContext context) {
    Navigator.of(context).pop();
  }

  Future<void> _signInWithOneTimePassword(
    String password,
    BuildContext context,
  ) async {
    // Unfocus the keyboard since Android devices may pixel overflow during loading.
    FocusScope.of(context).unfocus();
    try {
      await locator<SupabaseClient>().auth.verifyOTP(
            email: widget.email,
            token: password,
            type: OtpType.email,
          );
      await setUpApp();
      switch (widget.type) {
        case EmailOneTimePasswordType.LogIn:
          AppNavigation.router.go(homePath);
        case EmailOneTimePasswordType.ResetPassword:
          // Note to future self: this should probably route using AppNavigation.
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => ResetPassword(email: widget.email),
            ),
          );
      }
    } catch (error) {
      setState(() {
        _errorLogginIn = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageContainer(
      childInFactionallySizedBox: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            HeaderTitleWithBackButton(
              title: 'Log in with code',
              backButtonClicked: () => _backButtonClicked(context),
            ),
            Wrap(
              runSpacing: gridbaseline * 2,
              children: [
                if (_errorLogginIn)
                  ErrorMessageCard(text: 'The code you entered is incorrect.'),
                Text(
                  "Once you enter the code we sent to ${widget.email}, you'll be all logged in.",
                ),
                SizedBox(height: gridbaseline * 2),
                ToastieTextFieldWithController(
                  label: 'Code',
                  floatingLabel: 'Enter code',
                  showStickyFloatingLabel: false,
                  hintText: 'Enter code',
                  controller: controller,
                  inputType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
                GradientButton(
                  actionHandler: () =>
                      _signInWithOneTimePassword(controller.text, context),
                  fullWidth: true,
                  gradient: gradientButtonMain,
                  text: 'Log in',
                  withTopPadding: false,
                ),
                ToastieDivider(
                  text: 'OR',
                ),
                GoogleAuthenticationProvider(type: AuthenticationType.logIn),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: gridbaseline,
                  children: [
                    Text(
                      'Didn\'t get the code?',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    _otpCountdownSeconds == 0
                        ? ToastieTextButton(
                            text: 'Resend code',
                            actionHandler: () => _sendOneTimePassword(),
                          )
                        : Text(
                            'Resend in $_otpCountdownSeconds seconds',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
