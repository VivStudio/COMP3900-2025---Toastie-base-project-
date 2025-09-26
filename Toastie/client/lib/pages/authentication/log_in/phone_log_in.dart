import 'package:flutter/material.dart';
import 'package:toastie/components/header/header_title_with_back_button.dart';
import 'package:toastie/shared/widgets/layout/page_container.dart';
import 'package:toastie/pages/authentication/log_in/log_in.dart';
import 'package:toastie/services/services.dart';
import 'package:toastie/themes/theme.dart';

/** For running page in isolation. */
void main() {
  setUpApp();
  runApp(const ToastieApp());
}

class ToastieApp extends StatelessWidget {
  const ToastieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toastie',
      theme: ToastieTheme.defaultTheme,
      home: const PhoneLogIn(),
    );
  }
}
/** END. */

class PhoneLogIn extends StatelessWidget {
  const PhoneLogIn({super.key});

  backButtonClicked(BuildContext context) {
    Navigator.of(context).pop();
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => LogIn()));
  }

  @override
  Widget build(BuildContext context) {
    return PageContainer(
      childInFactionallySizedBox: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          HeaderTitleWithBackButton(
            title: 'Verify Code',
            backButtonClicked: () => backButtonClicked(context),
          ),
        ],
      ),
    );
  }
}
