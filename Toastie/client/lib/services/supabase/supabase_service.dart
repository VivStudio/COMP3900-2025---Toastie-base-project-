import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastie/services/supabase/key.dart';

class SupabaseService {
  Future initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseKey,
    );
  }
}
