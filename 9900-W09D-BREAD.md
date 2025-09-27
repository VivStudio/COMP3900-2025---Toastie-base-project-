# 3900-WO9D-Bread - Magic trackers v2

# Magic trackers v2
Directory: Toastie/client/lib/features/assistant ---> pretty much all code should go here unless you create a shared component
Entrypoint on home page: Toastie/client/lib/pages/home/magic_tracker.dart
Tests: Toastie/client/test/features/assistant (UI and unit tests)
Colors: Toastie/client/lib/themes/colors.dart
Text: Toastie/client/lib/themes/text/text.dart

# Supabase 
Supabase integration: Toastie/client/lib/services/supabase/key.dart

Entity: Database structure
- Toastie/client/lib/entities
Repository: Database communication (read, write) - no business logic
- Toastie/client/lib/repositories
Client: Uploading photos - no business logic
- Toastie/client/lib/clients
Service: Business logic & call repositories, clients, other services etc.
- Toastie/client/lib/services

# Main
Toastie/client/lib/main.dart

# Gallery
See how the existing card components and how to use them.
Toastie/client/lib/gallery.dart

# Developer options
If you don't want to re-authenticate everytime you use the app, you can do this:
- runActualApp: false
- shouldAuthenticateWithToastie: true
Toastie/client/lib/developer_mode.dart

Add test account login details Toastie/client/lib/services/test_account.dart
