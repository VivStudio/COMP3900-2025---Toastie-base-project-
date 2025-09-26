import 'package:flutter/material.dart';
import 'package:toastie/components/button/button.dart';
import 'package:toastie/components/button/gradient_button.dart';
import 'package:toastie/components/header/header_title_with_back_button.dart';
import 'package:toastie/shared/widgets/layout/page_container.dart';
import 'package:toastie/components/text_field.dart';
import 'package:toastie/entities/user/user_entity.dart';
import 'package:toastie/features/settings/screens/settings_screen.dart';
import 'package:toastie/services/services.dart';
import 'package:toastie/services/user_service.dart';
import 'package:toastie/themes/colors.dart';
import 'package:toastie/themes/linear_gradient_colors.dart';
import 'package:toastie/themes/theme.dart';
import 'package:toastie/utils/grid.dart';

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
      home: AccountOverview(
        userEntity: UserEntity(name: 'Test name'),
      ),
    );
  }
}

class AccountOverview extends StatefulWidget {
  AccountOverview({required this.userEntity});

  final UserEntity userEntity;

  @override
  State<AccountOverview> createState() => _AccountOverviewState();
}

class _AccountOverviewState extends State<AccountOverview> {
  late final TextEditingController controller;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.userEntity.name);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  // TODO: Is there a way to only update one section (name) on the Settings page without forcing a full fetch, or passing data from child to parent?
  void _backButtonClicked(BuildContext context) {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => SettingsScreen()),);
  }

  void _onTextFieldChanged(String value) {
    setState(() {
      _isEditing = true;
    });
  }

  void _updateName(BuildContext context) {
    setState(() {
      _isEditing = false;
    });
    locator<UserService>()
        .updateUser(userEntity: UserEntity(name: controller.text));
  }

  @override
  Widget build(BuildContext context) {
    return PageContainer(
      image: 'assets/track.png',
      imageRatio: headerImageSize(context),
      childInFactionallySizedBox: SingleChildScrollView(
        child: Column(
          children: [
            HeaderTitleWithBackButton(
              title: 'Account',
              backButtonClicked: () => _backButtonClicked(context),
            ),
            Image(
              height: gridbaseline * 15,
              image: AssetImage('assets/defaultProfilePicture.png'),
            ),
            ToastieTextFieldWithController(
              label: 'Name',
              floatingLabel: widget.userEntity.name.toString(),
              hintText: 'Add name',
              controller: controller,
              onChanged: _onTextFieldChanged,
            ),
            _isEditing
                ? GradientButton(
                    actionHandler: () => _updateName(context),
                    gradient: gradientButtonMain,
                    text: 'Update',
                  )
                : Button(
                    buttonType: ButtonType.SavedButton,
                    text: 'Saved',
                    color: neutral,
                    actionHandler: () => {},
                  ),
          ],
        ),
      ),
    );
  }
}
