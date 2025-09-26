import 'dart:ui';

enum DeviceType {
  Phone,
  Tablet,
}

DeviceType getDeviceType() {
  FlutterView view = PlatformDispatcher.instance.views.first;

  double physicalWidth = view.physicalSize.width;
  double devicePixelRatio = view.devicePixelRatio;
  double screenWidth = physicalWidth / devicePixelRatio;

  final deviceType = screenWidth < 550 ? DeviceType.Phone : DeviceType.Tablet;
  return deviceType;
}
