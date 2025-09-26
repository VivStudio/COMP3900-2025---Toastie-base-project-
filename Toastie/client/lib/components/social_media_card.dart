import 'package:flutter/material.dart';
import 'package:toastie/utils/responsive_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:toastie/utils/grid.dart';

class SocialMediaCard extends StatelessWidget {
  SocialMediaCard({
    required this.iconName,
    required this.text,
    required this.urlLink,
  });

  final String iconName;
  final String text;
  final String urlLink;

  void _openURL(BuildContext context) async {
    if (!await launchUrl(
      Uri.parse(urlLink),
      mode: LaunchMode.inAppWebView,
      webViewConfiguration: WebViewConfiguration(enableJavaScript: true),
    )) {
      throw Exception('Could not launch $urlLink');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openURL(context),
      child: Padding(
        padding: EdgeInsets.all(gridbaseline / 2),
        child: Image(
          image: AssetImage(iconName),
          height: scaleBySystemFont(
            context: context,
            size: gridbaseline * 4,
          ),
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }
}
