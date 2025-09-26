import 'package:flutter/material.dart';
import 'package:toastie/components/button/button.dart';
import 'package:toastie/themes/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsButton extends StatelessWidget {
  ContactUsButton();

  void _contactUsClicked(BuildContext context) async {
    Uri contactUsLink = Uri.parse('https://forms.gle/MC6AB5yi1jphFgUd9');
    if (!await launchUrl(
      contactUsLink,
      mode: LaunchMode.inAppWebView,
      webViewConfiguration: WebViewConfiguration(enableJavaScript: true),
    )) {
      throw Exception('Could not launch $contactUsLink');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Button(
      buttonType: ButtonType.TextButton,
      text: 'Send feedback 🐛🔨',
      color: primary,
      actionHandler: () => _contactUsClicked(context),
      fullWidth: false,
    );
  }
}
