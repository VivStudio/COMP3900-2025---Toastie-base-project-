# Generate entity classes
Run `dart run build_runner build` in the package directory (client/).
OR
Run  `flutter pub run build_runner build`

If you encounter errors with the linter, you can comment out flutter_local_notifications (which depends on custom_lint_core) to get around this temporarily. 