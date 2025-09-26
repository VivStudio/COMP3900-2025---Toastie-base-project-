import 'package:flutter/material.dart';
import 'package:toastie/components/drop_down_menu.dart';
import 'package:toastie/components/header/header_title_centered.dart';
import 'package:toastie/components/snackbar.dart';
import 'package:toastie/components/text_field.dart';
import 'package:toastie/entities/feedback/feedback_entity.dart';
import 'package:toastie/services/feedback_service.dart';
import 'package:toastie/services/services.dart';
import 'package:toastie/shared/widgets/button/gradient_button_with_saving_state.dart';
import 'package:toastie/themes/colors.dart';
import 'package:toastie/themes/text/text.dart';
import 'package:toastie/utils/grid.dart';
import 'package:toastie/utils/layout/padding.dart';
import 'package:toastie/utils/responsive_utils.dart';

Future showFeedbackModal({required BuildContext context}) async {
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
        child: Feedback(),
      );
    },
  );
}

class Feedback extends StatefulWidget {
  Feedback({super.key});

  @override
  State<Feedback> createState() => _FeedbackState();
}

class _FeedbackState extends State<Feedback> {
  bool _isSaving = false;
  final GlobalKey<DropDownMenuState> dropDownKey =
      GlobalKey<DropDownMenuState>();
  String _selectedFeedbackType = 'General inquiry';
  late final List<String> _feedbackTypes = [
    'Bug (something isn\'t working in the app)',
    'Feature request',
    'General inquiry',
  ];
  final TextEditingController _feedbackController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();

  FeedbackType _getFeedbackTypeFromString(String feedbackString) {
    switch (feedbackString) {
      case 'Bug (something isn\'t working in the app)':
        return FeedbackType.bug;
      case 'Feature request':
        return FeedbackType.featureRequest;
      case 'General inquiry':
      default:
        return FeedbackType.general;
    }
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  Future _submitFeedback({required BuildContext context}) async {
    setState(() {
      _isSaving = true;
    });

    try {
      await locator<FeedbackService>().createFeedback(
        type: _getFeedbackTypeFromString(_selectedFeedbackType),
        details: _feedbackController.text,
        contact: _contactController.text,
      );
    } catch (e) {
      showGenericToastieSnackBar(context: context);
    } finally {
      setState(() {
        _isSaving = false;
      });
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                  title: 'Send Feedback',
                ),
                Column(
                  children: [
                    Padding(
                      padding: cardLargeInnerPadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Let us know what you\'re here for',
                            style: titleMediumTextWithColor(
                              context: context,
                              color: primary[900]!,
                            ),
                          ),
                          SizedBox(height: gridbaseline),
                          DropDownMenu(
                            color: primary,
                            selected: _selectedFeedbackType,
                            options: _feedbackTypes,
                            onChanged: (newValue) {
                              setState(() {
                                _selectedFeedbackType = newValue!;
                              });
                            },
                          ),
                          SizedBox(height: gridbaseline * 2),
                          Text(
                            'Add details here!',
                            style: titleMediumTextWithColor(
                              context: context,
                              color: primary[900]!,
                            ),
                          ),
                          ToastieTextFieldWithController(
                            controller: _feedbackController,
                            color: primary,
                            hintText: 'Add details here',
                            inputType: TextInputType.multiline,
                            minLines: 3,
                          ),
                          SizedBox(height: gridbaseline * 2),
                          Text(
                            '[Optional] What is your email?',
                            style: titleMediumTextWithColor(
                              context: context,
                              color: primary[900]!,
                            ),
                          ),
                          SizedBox(height: gridbaseline),
                          Text(
                            'Add your contact information so we can let you know when your inquiry has been addressed OR if we need to contact you for more information',
                            style: bodyMediumTextWithColor(
                              context: context,
                              color: primary[900]!,
                            ),
                          ),
                          ToastieTextFieldWithController(
                            controller: _contactController,
                            color: primary,
                            hintText: 'Add email contact here',
                          ),
                          GradientButtonWithSavingState(
                            context: context,
                            isSaving: _isSaving,
                            buttonText: 'Send',
                            onPressed: () => _submitFeedback(context: context),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
