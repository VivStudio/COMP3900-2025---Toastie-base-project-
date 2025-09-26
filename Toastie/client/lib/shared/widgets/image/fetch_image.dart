import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:toastie/utils/grid.dart';

class FetchImage extends StatelessWidget {
  FetchImage({
    required this.fetchCall,
    required this.color,
    this.fallbackImage,
  });

  final Future<Uint8List?> fetchCall;
  final MaterialColor color;
  // If no fallback image is provided, show the unsupported icon.
  final Widget? fallbackImage;

  Widget LoadingImage() {
    return Container(
      width: gridbaseline * 12,
      height: gridbaseline * 12,
      color: color[100],
      child: Center(
        child: CircularProgressIndicator(
          color: color[400],
        ),
      ),
    );
  }

  Widget FallbackImage() {
    return Container(
      width: gridbaseline * 12,
      height: gridbaseline * 12,
      color: fallbackImage != null ? Colors.transparent : Colors.white,
      child: fallbackImage != null
          ? fallbackImage
          : Icon(
              Icons.image_not_supported,
              color: color[400],
              size: gridbaseline * 4,
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: FutureBuilder<Uint8List?>(
        future: fetchCall,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingImage();
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return FallbackImage();
          }

          return Image.memory(
            snapshot.data!,
            fit: BoxFit.cover,
            width: gridbaseline * 12,
            height: gridbaseline * 12,
          );
        },
      ),
    );
  }
}
