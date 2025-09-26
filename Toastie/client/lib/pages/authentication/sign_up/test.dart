import 'package:supabase_flutter/supabase_flutter.dart';

void main(List<String> args) async {
  await Supabase.initialize(
    url: 'https://ljumoqywmjdjqamsjgdg.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxqdW1vcXl3bWpkanFhbXNqZ2RnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDcwMDIzNjUsImV4cCI6MjAyMjU3ODM2NX0.iuYMwViO7-6pgGtWtulveB50kuJroz4qiC2dze9kbMU',
  );

  final supabase = Supabase.instance.client;

  try {
    await supabase.auth
        .signInWithPassword(email: 'hello@toastie.au', password: '0910lAVl!');
    final id = supabase.auth.currentUser!.id;
    final res = await supabase.from('users').select();
    // print('result: $res $id');

    //   Future<void> _getDeviceVersion() async {
    //   try {
    //     DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    //     if (Theme.of(context).platform == TargetPlatform.android) {
    //       AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    //       setState(() {
    //         deviceVersion = androidInfo.version.release;
    //       });
    //     } else if (Theme.of(context).platform == TargetPlatform.iOS) {
    //       IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    //       setState(() {
    //         deviceVersion = iosInfo.systemVersion;
    //       });
    //     }
    //   } catch (e) {
    //     print('Error getting device version: $e');
    //   }
    // }

    Map<String, dynamic> updateValues = {
      // 'user_id': id,
      // 'name': 'hello',
      // 'sign_up_date': DateTime.now().millisecondsSinceEpoch ~/ 1000,
      // 'device': 'IOS',
      'version': 16.1,
    };
    // await supabase.from('users').insert(updateValues);
    await supabase.from('users').update(updateValues).eq('user_id', id);
  } catch (error) {
    print('$error');
  }
}
