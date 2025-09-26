import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastie/entities/user/user_entity.dart';
import 'package:toastie/services/services.dart';
import 'package:toastie/services/user_service.dart';

final String nameCacheKey = 'name';
final String emailCacheKey = 'email';
final String supabaseSessionKey = 'supabase_session';
final String didRecoverSessionKey = 'did_recover_supabase_session';

void clearCache() {
  locator<SharedPreferences>().clear();
}

Future<void> addSessionToCache() async {
  String? sessionString =
      locator<SupabaseClient>().auth.currentSession?.persistSessionString;
  if (sessionString == null) {
    return;
  }

  await locator<SharedPreferences>().setString(
    supabaseSessionKey,
    sessionString,
  );
}

Future<bool?> getDidRecoverSession() async {
  return locator<SharedPreferences>().getBool(didRecoverSessionKey);
}

// Get name from cache, if it doesn't exist, get from supabase and add to cache.
Future<String> getNameFromCache() async {
  if (!locator.isRegistered<SharedPreferences>() ||
      !locator.isRegistered<UserService>()) {
    return '';
  }

  String? cacheName = locator<SharedPreferences>().getString(nameCacheKey);
  if (cacheName != null) {
    return cacheName;
  }

  String name;
  UserEntity? userEntity = await locator<UserService>().getUserDetails();
  name = userEntity?.name ?? '';
  if (name.isNotEmpty) {
    locator<SharedPreferences>().setString(nameCacheKey, name);
    return name;
  }

  return locator<SupabaseClient>().auth.currentUser!.userMetadata?['name'] ??
      '';
}

// Get email from cache, if it doesn't exist, get from supabase and add to cache.
Future<String> getEmailFromCache() async {
  String? cacheEmail = locator<SharedPreferences>().getString(emailCacheKey);
  if (cacheEmail != null) {
    return cacheEmail;
  }

  String? email = locator<SupabaseClient>().auth.currentUser?.email;
  if (email != null) {
    locator<SharedPreferences>().setString(emailCacheKey, email);
  }
  return email ?? '';
}
