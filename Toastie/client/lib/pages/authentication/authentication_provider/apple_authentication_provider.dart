// import 'package:flutter/material.dart';
// import 'package:supabase_auth_ui/supabase_auth_ui.dart';
// import 'package:toastie/pages/authentication/authentication_button.dart';
// import 'package:toastie/pages/authentication/authentication_provider/authentication_provider_utils.dart';
// import 'package:toastie/services/services.dart';
// import 'package:toastie/utils/layout/grid.dart';

// class AppleAuthenticationProvider extends StatelessWidget {
//   AppleAuthenticationProvider({
//     required this.type,
//   });

//   final AuthenticationType type;

//   Future _logIn() async {
//     // print('signing in');
//     // await locator<SupabaseClient>().auth.signInWithApple();
//     // print('signed in');

//     // print('session ${locator<SupabaseClient>().auth.currentSession}');

//     // User? user = locator<SupabaseClient>().auth.currentSession?.user;
//     // print('user $user');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AuthenticationButton(
//       providerImage: Image(
//         image: AssetImage('assets/icons/appleIcon.png'),
//         height: gridbaseline * 3,
//       ),
//       text: 'Continue with Apple',
//       actionHandler: () async {
//         await _logIn();
//       },
//     );
//   }
// }
