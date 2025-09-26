import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toastie/components/button/icon_button.dart';
import 'package:toastie/components/dialog.dart';
import 'package:toastie/components/snackbar.dart';
import 'package:toastie/utils/layout/grid.dart';
import 'package:toastie/utils/layout/padding.dart';
import 'package:permission_handler/permission_handler.dart';

/** Create card for image sources (eg. upload photo from camera, gallery). */
class PhotoPicker extends StatelessWidget {
  PhotoPicker({
    required this.type,
    required this.iconColor,
    required this.addPhotoToUpload,
    required this.context,
    this.enableImageMultiSelectInGallery = true,
  }) {
    _picker = ImagePicker();
  }

  final ImageSource type;
  final Color iconColor;
  final Function addPhotoToUpload;
  final bool enableImageMultiSelectInGallery;
  final BuildContext context;
  late final ImagePicker _picker;

  void _setAllPermissionCallbackToSettings({required BuildContext context}) {
    Function() showDialog = () => openDialog(
          context: context,
          title: 'Camera or gallery permission disabled',
          subtitle:
              'Camera or gallery access is currently disabled. To use this feature, please enable camera or gallery permissions in your settings.',
          // Apple rejected us because of this - we fight them next update.
          // buttonText: 'Go to settings',
          // actionHandler: () => openAppSettings(),
        );

    // The permissions check run similar to a singleton class (ie. camera.onGrantedCallback and storage.onGrantedCallback are the same).
    // This means you should only need to set the callback to showSettings for only one type of permissions.
    Permission.camera.onDeniedCallback(showDialog);
    Permission.camera.onPermanentlyDeniedCallback(showDialog);
    Permission.camera.onProvisionalCallback(showDialog);
    Permission.camera.onRestrictedCallback(showDialog);

    // The following callbacks will get over-written to call a more specific callback (eg. open camera / open gallery).
    Permission.camera.onGrantedCallback(showDialog);
    Permission.camera.onLimitedCallback(showDialog);
  }

  Future requestGalleryPermission() async {
    if (Platform.isIOS || await _isAndroid13OrAbove()) {
      await Permission.photos.request();
      return;
    }

    await Permission.storage.request();
  }

  Future<bool> _isAndroid13OrAbove() async {
    if (!Platform.isAndroid) return false;
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    return androidInfo.version.sdkInt >= 33;
  }

  Future<void> _pickImage({
    required ImageSource type,
  }) async {
    // Must initialise permissions separately. It's a singleton class (ie. camera.onGrantedCallback will be overwritten by storage.onGrantedCallback if it is initialised later).
    switch (type) {
      case ImageSource.camera:
        _initialiseCameraPermissions();
        await Permission.camera.request();
      case ImageSource.gallery:
        _initialiseGalleryPermissions();
        await requestGalleryPermission();
    }
  }

  void _initialiseCameraPermissions() {
    // Show camera when permission is granted or has limited access.
    Function() showCamera = () => _addSingleImage(type: ImageSource.camera);
    Permission.camera.onGrantedCallback(showCamera);
    Permission.camera.onLimitedCallback(showCamera);
  }

  void _initialiseGalleryPermissions() {
    // NOTE: iOS and Android 13+ uses photos. Android <13 uses storage.

    // Show camera when permission is granted or has limited access.
    Function() showGallery = () =>
        (type == ImageSource.gallery && enableImageMultiSelectInGallery)
            ? _addImagesFromGallery()
            : _addSingleImage(type: ImageSource.gallery);
    Permission.photos.onGrantedCallback(showGallery);
    Permission.photos.onLimitedCallback(showGallery);
    Permission.storage.onGrantedCallback(showGallery);
    Permission.storage.onLimitedCallback(showGallery);
  }

  // Upload single photo from image source.
  void _addSingleImage({
    required ImageSource type,
  }) async {
    try {
      XFile? pickedFile = await _picker.pickImage(
        source: type,
      );

      if (pickedFile != null) {
        File selectedImage = File(pickedFile.path);
        addPhotoToUpload(selectedImage);
      }
    } catch (error) {
      ToastieSnackBar.showWithCloseIcon(
        type: SnackBarType.error,
        context: context,
        message:
            'Oops! This image is not supported. Please try with a different image.',
      );
    }
  }

  // Multi-select images to upload from gallery.
  void _addImagesFromGallery() async {
    try {
      List<XFile> pickedFiles = await _picker.pickMultiImage();

      if (pickedFiles.length > 0) {
        pickedFiles.forEach((file) {
          File image = File(file.path);
          addPhotoToUpload(image);
        });
      }
    } catch (error) {
      ToastieSnackBar.showWithCloseIcon(
        type: SnackBarType.error,
        context: context,
        message: 'Oops! One of the images is not supported. Please try again.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    _setAllPermissionCallbackToSettings(context: context);

    return paddingForAddingDeleteButton(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(gridbaseline),
        child: Container(
          height: photoDimensions(size: size),
          width: photoDimensions(size: size),
          color: Colors.white,
          child: ToastieIconButton(
            iconType: type == ImageSource.camera
                ? IconType.PhotoCamera
                : IconType.PhotoGallery,
            iconColor: iconColor,
            iconButtonType: IconButtonType.DefaultButton,
            actionHandler: () async {
              await _pickImage(type: type);
            },
          ),
        ),
      ),
    );
  }
}
