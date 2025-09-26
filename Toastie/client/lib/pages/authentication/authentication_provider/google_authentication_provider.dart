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
    const List<String> scopes = <String>[
      'email',
      'profile',
      'https://www.googleapis.com/auth/contacts.readonly',
    ];

    // Google sign in on Android will work without providing the Android
    // Client ID registered on Google Cloud.
    String oauthClientId = oauthIosClientId;
    if (kIsWeb) {
    } else if (Platform.isAndroid) {
      oauthClientId = oauthWebClientId;
    } else if (Platform.isIOS || Platform.isMacOS) {
      oauthClientId = oauthIosClientId;
    }

    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: oauthClientId,
      serverClientId: oauthWebClientId,
      scopes: scopes,
    );

    final googleUser = await googleSignIn.signIn();
    final googleAuth = await googleUser!.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null) {
      throw 'No Access Token found.';
    }
    if (idToken == null) {
      throw 'No ID Token found.';
    }

    await locator<SupabaseClient>().auth.signInWithIdToken(
          provider: Provider.google,
          idToken: idToken,
          accessToken: accessToken,
        );
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
