import 'package:flutter/material.dart';
import 'package:toastie/themes/text/text.dart';
import 'package:toastie/utils/grid.dart';
import 'package:toastie/utils/layout/padding.dart';
import 'package:provider/provider.dart';
import 'package:toastie/features/settings/providers/home_customization_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:toastie/components/header/header_title_centered.dart';
import 'package:toastie/themes/colors.dart';

Future showCustomiseHomeModal({required BuildContext context}) async {
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
        child: CustomiseHome(),
      );
    },
  );
}

class CustomiseHome extends StatelessWidget {
  const CustomiseHome({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: cardLargeInnerPadding.vertical / 2,
              right: cardLargeInnerPadding.horizontal / 2,
              left: cardHeaderPadding.horizontal / 2,
              bottom: gridbaseline * 2,
            ),
            child: Column(
              children: [
                HeaderTitleCentered(
                  title: 'Customise trackers',
                ),
                Padding(
                  padding: EdgeInsets.only(top: gridbaseline),
                  child: Text(
                    'Choose which trackers to show on your home page',
                    style: bodyMediumTextWithColor(
                      context: context,
                      color: neutral[900] as Color,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: cardHeaderPadding.horizontal / 2,
                      bottom: gridbaseline / 2,
                    ),
                    child: Consumer<HomeCustomizationProvider>(
                      builder: (context, provider, child) {
                        return TextButton(
                          onPressed: () {
                            provider.enableAllOptions();
                          },
                          child: Text(
                            'Show all trackers',
                            style: TextStyle(color: primary[600] as Color),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Consumer<HomeCustomizationProvider>(
                  builder: (context, provider, child) {
                    return Column(
                      children: provider.options.map((option) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: gridbaseline),
                          child: ListTile(
                            leading: Image(
                              image: AssetImage(option.iconAssetPath),
                              height: gridbaseline * 3,
                              fit: BoxFit.fitHeight,
                              color: option.isEnabled ? null : neutral,
                              colorBlendMode:
                                  option.isEnabled ? null : BlendMode.modulate,
                            ),
                            tileColor:
                                option.isEnabled ? success[100] : neutral[100],
                            title: Text(
                              option.title,
                              style: TextStyle(
                                color: option.isEnabled
                                    ? success[900]
                                    : neutral[900],
                              ),
                            ),
                            trailing: CupertinoSwitch(
                              value: option.isEnabled,
                              onChanged: (value) {
                                provider.toggleOption(option.id, value);
                              },
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: borderRadius,
                            ),
                            onTap: () {
                              provider.toggleOption(
                                option.id,
                                !option.isEnabled,
                              );
                            },
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
