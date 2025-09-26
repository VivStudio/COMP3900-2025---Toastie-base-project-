import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastie/components/button/gradient_button.dart';
import 'package:toastie/shared/widgets/layout/page_container.dart';
import 'package:toastie/components/snackbar.dart';
import 'package:toastie/navigation/app_navigation.dart';
import 'package:toastie/navigation/app_navigation_utils.dart';
import 'package:toastie/services/location_storage_utils.dart';
import 'package:toastie/services/services.dart';
import 'package:toastie/themes/colors.dart';
import 'package:toastie/themes/gradient_background_colors.dart';
import 'package:toastie/themes/linear_gradient_colors.dart';
import 'package:toastie/themes/theme.dart';
import 'package:toastie/utils/grid.dart';
import 'package:toastie/utils/layout/padding.dart';

void main() async {
  await setUpApp();
  runApp(ToastieApp());
}

class ToastieApp extends StatelessWidget {
  ToastieApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toastie',
      theme: ToastieTheme.defaultTheme,
      home: OurStory(),
    );
  }
}
/** END. */

class OurStory extends StatefulWidget {
  OurStory({super.key});

  @override
  State<OurStory> createState() => _OurStoryState();
}

class _OurStoryState extends State<OurStory> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    await _didRecoverSession();
  }

  void _navigateToStartScreen(BuildContext context) {
    AppNavigation.router.push(startScreenPath);
  }

  Future _didRecoverSession() async {
    bool? didRecoverSession = await getDidRecoverSession();
    if (didRecoverSession == null) {
      return;
    }

    if (!didRecoverSession) {
      ToastieSnackBar.showWithCloseIcon(
        type: SnackBarType.error,
        context: context,
        message:
            'Oops! We were unable to recover your session. Please log in to continue.',
      );

      // Clear cached values after the first error to prevent repeated error toasts.
      await locator<SharedPreferences>().remove(supabaseSessionKey);
      await locator<SharedPreferences>().remove(didRecoverSessionKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageContainer(
      sizeType: PageSizeType.Narrow,
      color: primaryAndSecondaryGradientBackground,
      childInFactionallySizedBox: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image(
                  height: authenticationLogoSize(context),
                  image: AssetImage('assets/logo.png'),
                ),
                Text(
                  'toastie',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                Container(
                  margin: EdgeInsets.only(top: gridbaseline * 2),
                  padding: textCardPadding,
                  decoration: BoxDecoration(
                    color: primary[100],
                    borderRadius: borderRadius,
                  ),
                  child: Stack(
                    children: [
                      RichText(
                        text: TextSpan(
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    height: 1.1,
                                  ),
                          children: [
                            TextSpan(
                              text:
                                  'Hi 👋 We\'re two indie developers that created Toastie as a fun and easy way to manage our chronic illnesses!\n\n',
                            ),
                            TextSpan(
                              text:
                                  'Thank you for trying us out, we hope you enjoy the app as much as we enjoyed building it 🌱✨\n\n\n',
                            ),
                            TextSpan(text: '— Viv & Anna 💖'),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: ClipOval(
                          child: Transform.scale(
                            scale: 1.4,
                            child: Image(
                              height: gridbaseline * 6,
                              width: gridbaseline * 6,
                              image: AssetImage('assets/team.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                GradientButton(
                  actionHandler: () => _navigateToStartScreen(context),
                  gradient: gradientButtonOurStory,
                  text: "I'm bready 🍞",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
