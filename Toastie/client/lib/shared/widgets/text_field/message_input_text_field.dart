import 'package:flutter/material.dart';
import 'package:toastie/themes/colors.dart';
import 'package:toastie/themes/text/text.dart';

class MessageInputTextField extends StatelessWidget {
  MessageInputTextField({
    required this.textController,
    required this.scrollController,
    required this.focusNode,
    required this.showHintText,
    required this.hintText,
  });

  final TextEditingController textController;
  final ScrollController scrollController;
  final FocusNode focusNode;
  final bool showHintText;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textController,
      scrollController: scrollController,
      focusNode: focusNode,
      // Hack: Hard coded to be 4 to accomodate for dynamic text on the 'Ask Toastie' screen.
      maxLines: 4,
      minLines: 1,
      textInputAction: TextInputAction.newline,
      decoration: InputDecoration(
        hintText: showHintText ? hintText : '',
        hintStyle: bodyMediumTextWithColor(
          context: context,
          color: neutral[600] as Color,
        ),
        border: InputBorder.none,
        contentPadding: EdgeInsets.zero,
      ),
      style: bodyMediumTextWithColor(
        context: context,
        color: neutral[900] as Color,
      ),
      cursorColor: neutral,
    );
  }
}
