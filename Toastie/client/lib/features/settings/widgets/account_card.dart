import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastie/components/button/button.dart';
import 'package:toastie/components/button/gradient_button.dart';
import 'package:toastie/components/button/icon_button.dart';
import 'package:toastie/components/text_field.dart';
import 'package:toastie/entities/user/user_entity.dart';
import 'package:toastie/services/location_storage_utils.dart';
import 'package:toastie/services/services.dart';
import 'package:toastie/services/user_service.dart';
import 'package:toastie/themes/colors.dart';
import 'package:toastie/themes/linear_gradient_colors.dart';
import 'package:toastie/themes/text/text.dart';
import 'package:toastie/themes/theme.dart';
import 'package:toastie/utils/grid.dart';

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
      debugShowCheckedModeBanner: false,
      home: AccountCard(
        isEditState: false,
        updateEditState: (bool) => {},
      ),
    );
  }
}

class AccountCard extends StatefulWidget {
  AccountCard({required this.isEditState, required this.updateEditState});

  final bool isEditState;
  final Function(bool) updateEditState;

  @override
  State<AccountCard> createState() => _AccountCardState();
}

class _AccountCardState extends State<AccountCard> {
  late String _name = '';
  TextEditingController _nameController = TextEditingController();
  late String _email = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchData();
    });
    super.didChangeDependencies();
  }

  void fetchData() async {
    _name = await getNameFromCache();
    _nameController.text = _name;
    _email = await getEmailFromCache();
    setState(() {});
  }

  void _editClicked(BuildContext context) {
    widget.updateEditState(true);
  }

  Widget _Content() {
    return Container(
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              spacing: gridbaseline * 2,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image(
                      height: gridbaseline * 5,
                      image: AssetImage('assets/defaultProfilePicture.png'),
                    ),
                    SizedBox(width: gridbaseline),
                    Expanded(
                      child: Text(
                        _name,
                        style: titleMediumTextWithColor(
                          context: context,
                          color: primary[900]!,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ToastieIconButton(
            iconButtonType: IconButtonType.DefaultButton,
            iconType: IconType.Edit,
            actionHandler: () => _editClicked(context),
          ),
        ],
      ),
    );
  }

  void _discardNameChanges() {
    widget.updateEditState(false);
  }

  void _saveName() {
    _name = _nameController.text;
    locator<UserService>().updateUser(userEntity: UserEntity(name: _name));
    locator<SharedPreferences>().setString(nameCacheKey, _name);

    widget.updateEditState(false);
  }

  Widget _ContentEditor() {
    return Column(
      children: [
        ToastieTextFieldWithController(
          controller: _nameController,
          floatingLabel: 'Nickname',
          hintText: 'Add nickname',
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: gridbaseline),
          child: Row(
            children: [
              Flexible(
                child: Button(
                  actionHandler: _discardNameChanges,
                  buttonType: ButtonType.OutlinedButton,
                  color: primary,
                  text: 'Cancel',
                ),
              ),
              SizedBox(width: gridbaseline),
              Flexible(
                child: GradientButton(
                  withTopPadding: false,
                  actionHandler: _saveName,
                  gradient: gradientButtonMain,
                  child: Text('Save'),
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
    return Padding(
      padding: EdgeInsets.only(
        top: gridbaseline,
        right: gridbaseline,
        left: gridbaseline,
      ),
      child: widget.isEditState ? _ContentEditor() : _Content(),
    );
  }
}
