import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastie/components/button/button.dart';
import 'package:toastie/components/button/text_button.dart';
import 'package:toastie/components/divider.dart';
import 'package:toastie/components/error_message_card.dart';
import 'package:toastie/components/button/gradient_button.dart';
import 'package:toastie/components/header/header_title_with_back_button.dart';
import 'package:toastie/shared/widgets/layout/page_container.dart';
import 'package:toastie/components/text_field.dart';
import 'package:toastie/developer_mode.dart';
import 'package:toastie/navigation/app_navigation.dart';
import 'package:toastie/navigation/app_navigation_utils.dart';
import 'package:toastie/pages/authentication/log_in/email/email_one_time_password.dart';
import 'package:toastie/services/services.dart';
import 'package:toastie/themes/colors.dart';
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
      home: EmailLogIn(
        email: 'viv@toastie.au',
      ),
    );
  }
}
/** END. */

class EmailLogIn extends StatefulWidget {
  EmailLogIn({required this.email});

  final String email;

  @override
  State<EmailLogIn> createState() => _EmailLogInState();
}

class _EmailLogInState extends State<EmailLogIn> {
  TextEditingController controller = TextEditingController();
  bool errorLogginIn = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  _backButtonClicked(BuildContext context) {
    Navigator.of(context).pop();
  }

  Future<void> _signInWithEmail(String password, BuildContext context) async {
    try {
      await locator<SupabaseClient>()
          .auth
          .signInWithPassword(email: widget.email, password: password);
      await setUpApp();
      AppNavigation.router.go(homePath);
    } catch (error) {
      setState(() {
        errorLogginIn = true;
      });
    }
  }

  _signInWithOneTimePassword(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EmailOneTimePassword(
          email: widget.email,
        ),
      ),
    );
  }

  _forgotPassword(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EmailOneTimePassword(
          type: EmailOneTimePasswordType.ResetPassword,
          email: widget.email,
        ),
      ),
    );
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
              title: 'Log in with email',
              backButtonClicked: () => _backButtonClicked(context),
            ),
            if (errorLogginIn)
              Column(
                children: [
                  ErrorMessageCard(
                    text:
                        'Something went wrong - either the email or password you entered is incorrect.',
                  ),
                  SizedBox(height: gridbaseline * 2),
                ],
              ),
            Text('With ${widget.email}'),
            SizedBox(height: gridbaseline * 2),
            ToastieTextFieldWithController(
              label: 'Password',
              hintText: 'Enter password',
              obscureText: true,
              floatingLabel: 'Enter password',
              showStickyFloatingLabel: false,
              controller: controller,
              textCapitalization: TextCapitalization.none,
            ),
            GradientButton(
              actionHandler: () => _signInWithEmail(controller.text, context),
              fullWidth: true,
              gradient: gradientButtonMain,
              text: 'Log in',
            ),
            SizedBox(height: gridbaseline * 2),
            Wrap(
              runSpacing: gridbaseline * 2,
              children: [
                ToastieDivider(
                  text: 'OR',
                ),
                Text('Go passwordless! We\'ll send you an email.'),
                Button(
                  buttonType: ButtonType.FilledButton,
                  text: 'Log in with a code instead',
                  color: neutral,
                  actionHandler: () => _signInWithOneTimePassword(context),
                  fullWidth: true,
                ),
                Visibility(
                  visible: enableResetPassword,
                  child: ToastieTextButton(
                    text: 'Forgot password?',
                    actionHandler: () => _forgotPassword(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
