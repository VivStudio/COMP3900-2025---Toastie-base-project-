import 'package:flutter/material.dart';
import 'package:toastie/components/button/button.dart';
import 'package:toastie/components/button/gradient_button.dart';
import 'package:toastie/components/card/clickable_card/clickable_card_with_leading_image_asset.dart';
import 'package:toastie/components/header/header_title_centered.dart';
import 'package:toastie/navigation/app_navigation.dart';
import 'package:toastie/navigation/app_navigation_utils.dart';
import 'package:toastie/services/location_storage_utils.dart';
import 'package:toastie/themes/linear_gradient_colors.dart';
import 'package:toastie/themes/text/text.dart';
import 'package:toastie/utils/grid.dart';
import 'package:toastie/utils/layout/padding.dart';
import 'package:toastie/features/settings/widgets/account_card.dart';
import 'package:toastie/services/authentication/authentication_service.dart';
import 'package:toastie/services/services.dart';
import 'package:toastie/services/user_service.dart';
import 'package:toastie/themes/colors.dart';
import 'package:toastie/themes/theme.dart';
import 'package:toastie/utils/responsive_utils.dart';
import 'package:toastie/features/settings/widgets/customise_home.dart';
import 'package:toastie/features/settings/widgets/feedback.dart';

void main() async {
  await setUpApp();
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
      home: SettingsScreen(),
    );
  }
}

Future showSettingsModal({required BuildContext context}) async {
  await showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    useSafeArea: true,
    isDismissible: true,
    enableDrag: true,
    shape: RoundedRectangleBorder(
      borderRadius: topBorderRadius,
    ),
    builder: (BuildContext context) {
      return Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SettingsScreen(),
      );
    },
  );
}

class SettingsScreen extends StatefulWidget {
  SettingsScreen();

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isEditState = false;
  late AccountCard _AccountCard;

  @override
  void initState() {
    super.initState();
    _create();
  }

  void updateEditState(bool editState) {
    setState(() {
      isEditState = editState;
    });
    _create();
  }

  void _create() {
    _AccountCard = AccountCard(
      isEditState: isEditState,
      updateEditState: updateEditState,
    );
  }

  Future _clearAppStateForUser({required bool deleteUser}) async {
    clearCache();

    // This is required to ensure that the user will be logged out.
    // await locator<SupabaseClient>().auth.refreshSession();

    if (deleteUser) {
      await locator<UserService>().deleteUser();
    } else {
      await locator<AuthenticationService>().signOut();
    }

    await resetServices();
  }

  void _logOutClicked(BuildContext context) async {
    await _clearAppStateForUser(deleteUser: false);
    AppNavigation.instance.clearStackAndNavigate(startScreenPath);
  }

  void _closeDialog(BuildContext context) {
    Navigator.of(context).pop();
  }

  void _deleteAccountClicked(BuildContext context) async {
    await _clearAppStateForUser(deleteUser: true);
    AppNavigation.router.go(startScreenPath);
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              'Confirm account deletion',
              style: titleMediumTextWithColor(
                context: context,
                color: primary[600]!,
              ),
            ),
          ),
          content: Wrap(
            children: [
              Text(
                'Are you really sure you want to delete your account? This action cannot be undone. All your health data will be gone forever, and you cannot create a new account using the same email. \n\nToastie will be sad to see you go 🥺🍞',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Padding(
                padding: topPadding,
                child: Center(
                  child: Image(
                    height: authenticationLogoSize(context),
                    image: AssetImage('assets/toastieTrash.png'),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            GradientButton(
              text: 'Keep on toasting 💖',
              gradient: gradientButtonMain,
              actionHandler: () => _closeDialog(context),
              withTopPadding: false,
            ),
            Align(
              alignment: Alignment.center,
              child: Button(
                buttonType: ButtonType.TextButton,
                text: 'I\'m bready to leave',
                color: primary,
                actionHandler: () => _deleteAccountClicked(context),
              ),
            ),
          ],
        );
      },
    );
  }

  // Light grey icons for the "log out" and "delete account" buttons.
  Widget _LightIconTextButton(BuildContext context, Widget child) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (Rect bounds) {
        return RadialGradient(
          colors: <Color>[
            neutral[300]!,
            neutral[300]!,
          ],
        ).createShader(bounds);
      },
      child: child,
    );
  }

  void _contactUsClicked(BuildContext context) async {
    Navigator.of(context).pop();
    await showFeedbackModal(context: context);
  }

  void _customiseHomeScreenClicked({required BuildContext context}) async {
    Navigator.of(context).pop();
    await showCustomiseHomeModal(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: cardLargeInnerPadding.vertical / 2,
                  right: cardLargeInnerPadding.horizontal / 2,
                  left: cardHeaderPadding.horizontal / 2,
                  bottom: shouldAdaptForAccessibility(context: context)
                      ? cardHeaderPadding.horizontal / 2
                      : 0,
                ),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    HeaderTitleCentered(
                      title: 'Settings',
                    ),
                    Column(
                      children: [
                        _AccountCard,
                        if (!isEditState)
                          Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: gridbaseline),
                                child: ClickableCardWithLeadingImageAsset(
                                  assetName:
                                      'assets/icons/settings/customise_home.png',
                                  title: 'Customise trackers',
                                  color: primary,
                                  cardAction: () => _customiseHomeScreenClicked(
                                    context: context,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: gridbaseline),
                                child: ClickableCardWithLeadingImageAsset(
                                  assetName:
                                      'assets/icons/settings/feedback.png',
                                  title: 'Send feedback',
                                  color: primary,
                                  cardAction: () => _contactUsClicked(context),
                                ),
                              ),
                              Wrap(
                                direction: Axis.horizontal,
                                children: [
                                  _LightIconTextButton(
                                    context,
                                    Button(
                                      buttonType: ButtonType.TextButton,
                                      text: 'Delete account',
                                      color: neutral,
                                      actionHandler: () =>
                                          _showDeleteAccountDialog(context),
                                      icon: Icons.delete_outline,
                                    ),
                                  ),
                                  _LightIconTextButton(
                                    context,
                                    Button(
                                      buttonType: ButtonType.TextButton,
                                      text: 'Log out',
                                      color: neutral,
                                      actionHandler: () =>
                                          _logOutClicked(context),
                                      icon: Icons.logout_outlined,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              if (isEditState)
                Container(
                  color: primary[300],
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Image(
                        image: AssetImage('assets/settings.png'),
                        fit: BoxFit.fitHeight,
                      ),
                      SizedBox(height: gridbaseline * 3),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
