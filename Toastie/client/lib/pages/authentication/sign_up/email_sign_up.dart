import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastie/components/error_message_card.dart';
import 'package:toastie/components/button/gradient_button.dart';
import 'package:toastie/components/header/header_title_with_back_button.dart';
import 'package:toastie/shared/widgets/layout/page_container.dart';
import 'package:toastie/components/text_field.dart';
import 'package:toastie/navigation/app_navigation.dart';
import 'package:toastie/navigation/app_navigation_utils.dart';
import 'package:toastie/services/services.dart';
import 'package:toastie/services/user_service.dart';
import 'package:toastie/themes/linear_gradient_colors.dart';
import 'package:toastie/themes/theme.dart';
import 'package:toastie/utils/grid.dart';
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
      home: EmailSignUp(),
    );
  }
}
/** END. */

class EmailSignUp extends StatefulWidget {
  EmailSignUp({super.key});

  @override
  State<EmailSignUp> createState() => _EmailSignUpState();
}

class _EmailSignUpState extends State<EmailSignUp> {
  bool _nameIsEmpty = false;
  bool _emailInvalid = false;
  bool _passwordIsNotStrong = false;
  String _errorLogginIn = '';

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  _backButtonClicked(BuildContext context) {
    Navigator.of(context).pop();
  }

  Future<void> _signUpWithEmail(BuildContext context) async {
    String name = nameController.text;
    String email = emailController.text;
    String password = passwordController.text;

    setState(() {
      _nameIsEmpty = name.length < 0;
      _emailInvalid = !isValidEmail(email);
      _passwordIsNotStrong = !isStrongPassword(password);
    });

    if (_nameIsEmpty || _emailInvalid || _passwordIsNotStrong) {
      return;
    }

    try {
      await locator<SupabaseClient>()
          .auth
          .signUp(email: email, password: password);

      await setUpApp();

      await locator<UserService>().populateNewUser(name: name);
      AppNavigation.router.go(homePath);
    } on AuthException catch (error) {
      setState(() {
        _errorLogginIn = 'Error: ${error.message}';
      });
    } catch (error) {
      setState(() {
        _errorLogginIn = '$error';
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
              title: 'Sign up with email',
              backButtonClicked: () => _backButtonClicked(context),
            ),
            if (_nameIsEmpty)
              Column(
                children: [
                  ErrorMessageCard(text: 'Please enter a name.'),
                  SizedBox(height: gridbaseline * 2),
                ],
              ),
            if (_emailInvalid)
              Column(
                children: [
                  ErrorMessageCard(text: 'Please enter a valid email.'),
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
            if (!_errorLogginIn.isEmpty)
              Column(
                children: [
                  ErrorMessageCard(text: _errorLogginIn),
                  SizedBox(height: gridbaseline * 2),
                ],
              ),
            Wrap(
              runSpacing: gridbaseline * 2,
              children: [
                ToastieTextFieldWithController(
                  label: 'Name',
                  floatingLabel: 'Enter name',
                  showStickyFloatingLabel: false,
                  hintText: 'Enter name',
                  controller: nameController,
                ),
                ToastieTextFieldWithController(
                  label: 'Email',
                  floatingLabel: 'Enter email',
                  showStickyFloatingLabel: false,
                  hintText: 'Enter email',
                  controller: emailController,
                  inputType: TextInputType.emailAddress,
                  textCapitalization: TextCapitalization.none,
                ),
                ToastieTextFieldWithController(
                  label: 'Password',
                  floatingLabel: 'Enter password',
                  showStickyFloatingLabel: false,
                  hintText: 'Enter password',
                  obscureText: true,
                  controller: passwordController,
                  textCapitalization: TextCapitalization.none,
                ),
                GradientButton(
                  actionHandler: () => _signUpWithEmail(context),
                  fullWidth: true,
                  gradient: gradientButtonMain,
                  text: 'Sign up',
                  withTopPadding: false,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
