import 'package:toastie/navigation/app_navigation.dart';
import 'package:toastie/navigation/app_navigation_utils.dart';
import 'package:toastie/pages/authentication/authentication_provider/authentication_provider_utils.dart';
import 'package:toastie/services/services.dart';
import 'package:toastie/services/user_service.dart';

Future<void> authenticateUser({required AuthenticationType type}) async {
  await setUpApp();

  if (type == AuthenticationType.signUp) {
    await locator<UserService>().populateNewUser();
  }

  AppNavigation.router.go(homePath);
}
