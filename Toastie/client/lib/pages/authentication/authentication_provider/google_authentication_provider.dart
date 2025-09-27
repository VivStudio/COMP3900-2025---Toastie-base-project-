import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastie/pages/authentication/authentication_button.dart';
import 'package:toastie/pages/authentication/authentication_provider/authentication_provider_utils.dart';
import 'package:toastie/services/services.dart';
import 'package:toastie/services/supabase/key.dart';
import 'package:toastie/utils/layout/grid.dart';

class GoogleAuthenticationProvider extends StatelessWidget {
  GoogleAuthenticationProvider({
    required this.type,
  });

  final AuthenticationType type;

  Future<void> _logIn() async {
    // TODO: Implement me.
  }

  @override
  Widget build(BuildContext context) {
    return AuthenticationButton(
      providerImage: Image(
        image: AssetImage('assets/icons/googleIcon.png'),
        height: gridbaseline * 3,
      ),
      text: 'Continue with Google',
      actionHandler: () async {
        await _logIn();
      },
    );
  }
}
