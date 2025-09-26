import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:toastie/utils/grid.dart';

class LoadingAnimation extends StatelessWidget {
  LoadingAnimation();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: gridbaseline * 10,
      child: Lottie.network(
        'https://lottie.host/fbfc7981-c0f8-4d57-b6b9-2396755da0f0/LHbvPctsRX.json',
      ),
    );
  }
}
