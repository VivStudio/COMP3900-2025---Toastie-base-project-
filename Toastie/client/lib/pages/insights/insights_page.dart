import 'package:flutter/material.dart';
import 'package:toastie/components/card/clickable_card/clickable_card_with_leading_icon.dart';
import 'package:toastie/components/card/clickable_card/clickable_card_with_leading_image_asset.dart';
import 'package:toastie/components/header/header_title.dart';
import 'package:toastie/components/header/header_title_centered.dart';
import 'package:toastie/shared/widgets/layout/page_container.dart';
import 'package:toastie/navigation/app_navigation.dart';
import 'package:toastie/services/services.dart';
import 'package:toastie/themes/colors.dart';
import 'package:toastie/themes/theme.dart';
import 'package:toastie/utils/grid.dart';
import 'package:toastie/utils/tracker_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Now safe to use plugins or async initialization.

  oneTimeSupabaseInitialisation(); // VERY IMPORTANT - THIS INITIALISES OUR SUPABASE

  await setUpApp();
  AppNavigation.instance;
  runApp(ToastieApp());
}

class ToastieApp extends StatelessWidget {
  ToastieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toastie',
      theme: ToastieTheme.defaultTheme,
      debugShowCheckedModeBanner: false,
      home: InsightsPage(),
    );
  }
}

class InsightsPage extends StatelessWidget {
  InsightsPage();

  final List<TrackerCategory> categories = [
    TrackerCategory.symptom,
    TrackerCategory.stool,
    TrackerCategory.period,
    TrackerCategory.weight,
  ];

  Widget Cards({
    required BuildContext context,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: gridbaseline * 2),
        Padding(
          padding: EdgeInsets.only(top: gridbaseline),
          child: ClickableCardWithLeadingIcon(
            leadingIcon: Icons.auto_awesome,
            title: 'Ask Toastie',
            cardAction: () {},
          ),
        ),
        Text('TODO: 3900-F09B-BANANA Implement Doctor Summary'),
        Padding(
          padding: EdgeInsets.only(top: gridbaseline),
          child: ClickableCardWithLeadingImageAsset(
            title: 'Lab report',
            color: info,
            assetName: 'assets/icons/labReportIcon.png',
            cardAction: () => {},
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: gridbaseline),
          child: Wrap(
            runSpacing: gridbaseline,
            children: [
              ...categories.map(
                (category) => ClickableCardWithLeadingImageAsset(
                  title: category.name,
                  color: getColorFromTrackerCategory(category: category),
                  assetName: getImageAssetNameFromTrackerCategory(
                    category: category,
                  ),
                  cardAction: () {},
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageContainer(
      childInFactionallySizedBox: SingleChildScrollView(
        child: Column(
          children: [
            HeaderTitleCentered(
              title: 'Insights',
            ),
            SizedBox(height: gridbaseline * 2),
            Cards(context: context),
          ],
        ),
      ),
    );
  }
}
