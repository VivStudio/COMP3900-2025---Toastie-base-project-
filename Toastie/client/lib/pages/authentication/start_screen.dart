import 'package:flutter/material.dart';
import 'package:toastie/components/button/button.dart';
import 'package:toastie/components/button/gradient_button.dart';
import 'package:toastie/shared/widgets/layout/page_container.dart';
import 'package:toastie/navigation/app_navigation.dart';
import 'package:toastie/navigation/app_navigation_utils.dart';
import 'package:toastie/services/services.dart';
import 'package:toastie/themes/colors.dart';
import 'package:toastie/themes/gradient_background_colors.dart';
import 'package:toastie/themes/linear_gradient_colors.dart';
import 'package:toastie/themes/theme.dart';
import 'package:toastie/utils/grid.dart';

/** For running page in isolation. */
void main() async {
  await setUpApp();
  AppNavigation.instance;
  runApp(ToastieApp());
}

class ToastieApp extends StatelessWidget {
  ToastieApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toastie',
      theme: ToastieTheme.defaultTheme,
      home: StartScreen(),
    );
  }
}
/** END. */

class StartScreen extends StatelessWidget {
  StartScreen();

  void _logInClicked(BuildContext context) {
    AppNavigation.router.push(logInPath);
  }

  void _signUpClicked(BuildContext context) {
    AppNavigation.router.push(signUpPath);
  }

  @override
  Widget build(BuildContext context) {
    return PageContainer(
      sizeType: PageSizeType.Narrow,
      color: primaryAndSecondaryGradientBackground,
      childInFactionallySizedBox: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            height: authenticationLogoSize(context),
            image: AssetImage('assets/logo.png'),
          ),
          Text(
            'toastie',
            style: Theme.of(context).textTheme.displayLarge,
          ),
          GradientButton(
            actionHandler: () => _signUpClicked(context),
            gradient: gradientButtonLogIn,
            text: 'Sign up',
          ),
          SizedBox(height: 20),
          Button(
            actionHandler: () => _logInClicked(context),
            buttonType: ButtonType.OutlinedButton,
            color: accentPink,
            text: 'Log in',
          ),
        ],
      ),
    );
  }
}
