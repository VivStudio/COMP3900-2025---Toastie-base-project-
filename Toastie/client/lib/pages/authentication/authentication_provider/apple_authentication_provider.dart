import 'package:flutter/material.dart';
import 'package:toastie/pages/authentication/authentication_button.dart';
import 'package:toastie/pages/authentication/authentication_provider/authentication_provider_utils.dart';
import 'package:toastie/utils/layout/grid.dart';

class AppleAuthenticationProvider extends StatelessWidget {
  AppleAuthenticationProvider({
    required this.type,
  });

  final AuthenticationType type;

  Future _logIn() async {
    // TODO: Implement me.
  }

  @override
  Widget build(BuildContext context) {
    return AuthenticationButton(
      providerImage: Image(
        image: AssetImage('assets/icons/appleIcon.png'),
        height: gridbaseline * 3,
      ),
      text: 'Continue with Apple',
      actionHandler: () async {
        await _logIn();
      },
    );
  }
}
