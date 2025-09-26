import 'package:flutter/material.dart';
import 'package:toastie/components/error_message_card.dart';
import 'package:toastie/components/button/gradient_button.dart';
import 'package:toastie/components/header/header_title_with_back_button.dart';
import 'package:toastie/shared/widgets/layout/page_container.dart';
import 'package:toastie/components/text_field.dart';
import 'package:toastie/themes/linear_gradient_colors.dart';
import 'package:toastie/utils/grid.dart';
import 'package:toastie/pages/authentication/log_in/email/email_login_in.dart';
import 'package:toastie/themes/theme.dart';
import 'package:toastie/utils/utils.dart';

/** For running page in isolation. */
void main() {
  runApp(const ToastieApp());
}

class ToastieApp extends StatelessWidget {
  const ToastieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toastie',
      theme: ToastieTheme.defaultTheme,
      home: Email(),
    );
  }
}
/** END. */

class Email extends StatefulWidget {
  Email({super.key});

  @override
  State<Email> createState() => _EmailState();
}

class _EmailState extends State<Email> {
  TextEditingController controller = TextEditingController();
  bool _validEmail = true;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  _backButtonClicked(BuildContext context) {
    Navigator.of(context).pop();
  }

  _emailLogIn(String email, BuildContext context) {
    setState(() {
      _validEmail = isValidEmail(email);
    });

    if (_validEmail) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => EmailLogIn(email: email)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageContainer(
      childInFactionallySizedBox: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          HeaderTitleWithBackButton(
            title: 'Continue with email',
            backButtonClicked: () => _backButtonClicked(context),
          ),
          if (!_validEmail)
            Column(
              children: [
                ErrorMessageCard(text: 'Please enter a valid email.'),
                SizedBox(height: gridbaseline * 2),
              ],
            ),
          ToastieTextFieldWithController(
            controller: controller,
            label: 'Email',
            floatingLabel: 'example@gmail.com',
            showStickyFloatingLabel: false,
            hintText: 'example@gmail.com',
            textCapitalization: TextCapitalization.none,
            inputType: TextInputType.emailAddress,
          ),
          GradientButton(
            actionHandler: () => _emailLogIn(controller.text, context),
            fullWidth: true,
            gradient: gradientButtonMain,
            text: 'Continue',
          ),
        ],
      ),
    );
  }
}
