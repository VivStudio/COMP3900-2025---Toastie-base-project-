import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase_package;
import 'package:toastie/services/services.dart';

class LifecycleHandler extends StatefulWidget {
  LifecycleHandler({required this.child});

  final Widget child;

  @override
  State<LifecycleHandler> createState() => _LifecycleHandlerState();
}

class _LifecycleHandlerState extends State<LifecycleHandler>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    locator<supabase_package.SupabaseClient>()
        .auth
        .onAuthStateChange
        .listen((data) async {});
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {}

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
