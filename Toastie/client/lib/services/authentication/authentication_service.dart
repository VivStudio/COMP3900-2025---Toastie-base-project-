import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastie/services/services.dart';

class AuthenticationService {
  AuthenticationService() {
    _supabaseClient = locator<SupabaseClient>();
  }

  late SupabaseClient _supabaseClient;
  late User user;

  /* Login methods. */

  Future<User?> emailLogIn({
    required String email,
    required String password,
  }) async {
    User? user = null;
    await _supabaseClient.auth
        .signInWithPassword(email: email, password: password)
        .then((response) {
      user = response.user;
    });
    return user;
  }

  Future<User?> OTPLogIn({
    required String email,
    required String token,
    required OtpType type,
  }) async {
    User? user = null;
    await _supabaseClient.auth
        .verifyOTP(email: email, token: token, type: type)
        .then((response) {
      user = response.user;
    });
    return user;
  }

  /* Sign up methods. */

  Future<User?> emailSignUp({
    required String email,
    required String password,
  }) async {
    User? user = null;
    await _supabaseClient.auth
        .signUp(email: email, password: password)
        .then((response) {
      user = response.user;
    });
    return user;
  }

  Future signOut() async {
    await _supabaseClient.auth.signOut();
  }
}

void main() async {}
