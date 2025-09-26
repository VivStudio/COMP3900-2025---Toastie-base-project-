import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastie/components/button/text_button.dart';
import 'package:toastie/components/error_message_card.dart';
import 'package:toastie/components/button/gradient_button.dart';
import 'package:toastie/components/header/header_title_with_back_button.dart';
import 'package:toastie/shared/widgets/layout/page_container.dart';
import 'package:toastie/components/text_field.dart';
import 'package:toastie/themes/linear_gradient_colors.dart';
import 'package:toastie/utils/grid.dart';
import 'package:toastie/pages/authentication/log_in/email/email_login_in.dart';
import 'package:toastie/pages/authentication/log_in/log_in.dart';
import 'package:toastie/pages/home/home.dart';
import 'package:toastie/services/services.dart';
import 'package:toastie/themes/colors.dart';
import 'package:toastie/themes/theme.dart';
import 'package:toastie/utils/utils.dart';

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
      home: ResetPassword(
        email: 'viv@toastie.au',
      ),
    );
  }
}
/** END. */

class ResetPassword extends StatefulWidget {
  ResetPassword({required this.email});

  final String email;

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  bool _passwordDoesNotMatch = false;
  bool _passwordIsNotStrong = false;
  bool _errorLoggingIn = false;
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  _backButtonClicked(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EmailLogIn(email: widget.email),
      ),
    );
  }

  _resetPassword(
    String password,
    String confirmPassword,
    BuildContext context,
  ) async {
    setState(() {
      _errorLoggingIn = false;
      _passwordDoesNotMatch = password != confirmPassword;
      _passwordIsNotStrong = !isStrongPassword(password);
    });

    if (_errorLoggingIn || _passwordDoesNotMatch || _passwordIsNotStrong) {
      return;
    }

    try {
      await locator<SupabaseClient>().auth.updateUser(
            UserAttributes(
              password: password,
            ),
          );

      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => Home()));
    } catch (error) {
      setState(() {
        _errorLoggingIn = true;
      });
    }
  }

  _returnToLogIn(BuildContext context) {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => LogIn()));
  }

  @override
  Widget build(BuildContext context) {
    return PageContainer(
      childInFactionallySizedBox: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          HeaderTitleWithBackButton(
            title: 'Reset your password',
            backButtonClicked: () => _backButtonClicked(context),
          ),
          if (_passwordDoesNotMatch)
            Column(
              children: [
                ErrorMessageCard(
                  text:
                      'Please ensure the password you have entered matches the first.',
                ),
                SizedBox(height: gridbaseline * 2),
              ],
            ),
          if (_passwordIsNotStrong)
            Column(
              children: [
                ErrorMessageCard(
                  text:
                      'Please ensure the password is strong. Use 8 or more characters with a mix of letters, numbers & symbols.',
                ),
                SizedBox(height: gridbaseline * 2),
              ],
            ),
          if (_errorLoggingIn)
            Column(
              children: [
                ErrorMessageCard(
                  text: 'Error resetting password, please try again.',
                ),
                SizedBox(height: gridbaseline * 2),
              ],
            ),
          Wrap(
            runSpacing: gridbaseline * 2,
            children: [
              Text(
                'Please set a new password for your account ${widget.email}.',
              ),
              SizedBox(height: gridbaseline * 2),
              ToastieTextFieldWithController(
                label: 'New password',
                floatingLabel: 'New password',
                showStickyFloatingLabel: false,
                hintText: 'Add password',
                obscureText: true,
                controller: passwordController,
              ),
              Text(
                'Use 8 or more characters with a mix of letters, numbers & symbols.',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              ToastieTextFieldWithController(
                label: 'Confirm new password',
                floatingLabel: 'Confirm password',
                showStickyFloatingLabel: false,
                hintText: 'Retype password',
                obscureText: true,
                controller: confirmPasswordController,
              ),
              GradientButton(
                actionHandler: () => _resetPassword(
                  passwordController.text,
                  confirmPasswordController.text,
                  context,
                ),
                fullWidth: true,
                gradient: gradientButtonMain,
                text: 'Set password and log in',
                withTopPadding: false,
              ),
              SizedBox(height: gridbaseline * 2),
              ToastieTextButton(
                text: 'Return to log in',
                color: primary,
                actionHandler: () => _returnToLogIn(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
