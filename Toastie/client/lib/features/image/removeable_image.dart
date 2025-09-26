import 'dart:io';
import 'package:flutter/material.dart';
import 'package:toastie/components/button/icon_button.dart';
import 'package:toastie/utils/layout/grid.dart';
import 'package:toastie/utils/layout/padding.dart';

class RemoveableImage extends StatelessWidget {
  RemoveableImage({
    required this.image,
    required this.deleteButtonColor,
    required this.removeImage,
  });

  final File image;
  final Color deleteButtonColor;
  final Function() removeImage;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Stack(
      children: [
        paddingForAddingDeleteButton(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(gridbaseline),
            child: Image.file(
              image,
              fit: BoxFit.cover,
              height: photoDimensions(size: size),
              width: photoDimensions(size: size),
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: ToastieIconButton(
            fillColor: deleteButtonColor,
            iconButtonType: IconButtonType.FilledButton,
            iconType: IconType.Delete,
            iconColor: Colors.white,
            actionHandler: removeImage,
          ),
        ),
      ],
    );
  }
}
