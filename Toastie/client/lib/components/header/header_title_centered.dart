import 'package:flutter/material.dart';
import 'package:toastie/components/header/header_title.dart';

class HeaderTitleCentered extends StatelessWidget {
  HeaderTitleCentered({
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: HeaderTitle(title: title),
        ),
      ],
    );
  }
}
