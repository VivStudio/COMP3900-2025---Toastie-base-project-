import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toastie/components/button/icon_button.dart';
import 'package:toastie/themes/colors.dart';
import 'package:toastie/themes/text/text.dart';
import 'package:toastie/utils/grid.dart';
import 'package:toastie/utils/layout/padding.dart';

enum TextFieldType {
  // Styling needed to be adjusted for the magic tracker accordion notes tracker.
  // TODO: remove this enum type once Magic Tracker V2 is released.
  MagicTracker,
  Chat, // Need to have multiline enabled as well with minLines 1 and maxLines null.
  Standard,
}

// DEPRECATED! PLEASE USE shared/widgets/text_field instead
class ToastieTextFieldWithController extends StatefulWidget {
  ToastieTextFieldWithController({
    required this.controller,
    // Hint text on the textfield when the textfield is empty.
    required this.hintText,
    this.color = primary,
    this.inputType = TextInputType.text,
    // Large label on top of text field.
    this.label = '',
    // Floating label on top border of text field.
    this.floatingLabel = '',
    this.showStickyFloatingLabel = true,
    this.inputFormatters = const [],
    this.minLines = 1,
    this.maxLines = 3,
    this.obscureText = false,
    this.createWithFocus = false,
    this.onChanged = emptyFunction,
    this.smallText = false,
    this.border = true,
    // Only false for the magic tracker notes card.
    this.hasPadding = true,
    this.type = TextFieldType.Standard,
    this.textCapitalization = TextCapitalization.sentences,
    this.onSubmitted,
  }) {
    if (obscureText) {
      maxLines = 1;
    }

    if (inputType == TextInputType.multiline) {
      // Only override if min lines is not already provided.
      if (minLines == -1) {
        minLines = textMinMultilines;
      }
      maxLines = null;
      return;
    }

    if (minLines == -1 && maxLines == -1) {
      minLines = textMinLines;
      maxLines = textMinLines;
    }
  }

  static void emptyFunction(String value) {}

  final TextEditingController controller;
  final MaterialColor color;
  final TextInputType inputType;
  final String label;
  final String floatingLabel;
  final bool showStickyFloatingLabel;
  final String hintText;
  final List<TextInputFormatter>? inputFormatters;
  int minLines;
  int? maxLines;
  final bool obscureText;
  final bool createWithFocus;
  final ValueChanged<String> onChanged;
  final bool smallText;
  final bool border;
  final bool hasPadding;
  final TextFieldType type;
  final TextCapitalization textCapitalization;
  final ValueChanged<String>? onSubmitted;

  @override
  State<ToastieTextFieldWithController> createState() =>
      _ToastieTextFieldWithControllerState();
}

class _ToastieTextFieldWithControllerState
    extends State<ToastieTextFieldWithController> {
  final FocusNode focusNode = FocusNode();
  bool _isObscured = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.createWithFocus) {
        focusNode.requestFocus();
      }
    });
    _isObscured = widget.obscureText;
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: gridbaseline),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.label.isNotEmpty)
            Text(
              widget.label,
              style: titleLargeTextWithColor(
                context: context,
                color: widget.color[900]!,
              ),
            ),
          widget.hasPadding
              ? SizedBox(height: gridbaseline)
              : SizedBox.shrink(),
          TextField(
            controller: widget.controller,
            inputFormatters: widget.inputFormatters,
            keyboardType: widget.inputType,
            textCapitalization: widget.textCapitalization,
            minLines: widget.minLines,
            maxLines: widget.maxLines,
            cursorColor: widget.color,
            decoration: InputDecoration(
              contentPadding: widget.hasPadding
                  ? EdgeInsets.symmetric(
                      horizontal: widget.inputType == TextInputType.multiline
                          ? gridbaseline * 2
                          : textBoxContentPaddingHorizontal,
                      vertical: textBoxContentPaddingVertical,
                    )
                  : EdgeInsets.symmetric(
                      horizontal: textBoxContentPaddingHorizontal,
                    ),
              // Floating label
              floatingLabelBehavior: widget.showStickyFloatingLabel
                  ? FloatingLabelBehavior.always
                  : FloatingLabelBehavior.never,
              floatingLabelStyle: TextStyle(color: widget.color[900]),
              labelText: widget.floatingLabel,
              labelStyle: widget.type == TextFieldType.MagicTracker
                  ? bodyMediumTextWithColor(
                      context: context,
                      color: widget.color[600]!,
                    )
                  : Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: widget.color[900]),
              // Hint text
              hintText: widget.hintText,
              hintStyle: widget.type == TextFieldType.MagicTracker
                  ? bodyMediumTextWithColor(
                      context: context,
                      color: widget.color[600]!,
                    )
                  : labelMediumTextWithColor(context, widget.color),
              hintMaxLines:
                  widget.controller.text.isEmpty ? null : textMinLines,
              // Style
              filled: true,
              fillColor: widget.color[100],
              // Borders
              border: widget.border
                  ? OutlineInputBorder(
                      borderRadius: borderRadius,
                      borderSide: BorderSide(color: widget.color[300]!),
                    )
                  : InputBorder.none,
              enabledBorder: widget.border
                  ? OutlineInputBorder(
                      borderRadius: borderRadius,
                      borderSide: BorderSide(color: widget.color[300]!),
                    )
                  : null,
              focusedBorder: widget.border
                  ? OutlineInputBorder(
                      borderRadius: borderRadius,
                      borderSide: BorderSide(color: widget.color),
                    )
                  : null,
              suffixIcon: widget.obscureText
                  ? ToastieIconButton(
                      iconButtonType: IconButtonType.DefaultButton,
                      iconType: _isObscured
                          ? IconType.Visibility
                          : IconType.VisibilityOff,
                      iconColor: primary,
                      actionHandler: () {
                        setState(() {
                          _isObscured = !_isObscured;
                        });
                      },
                    )
                  : null,
            ),
            obscureText: widget.obscureText && _isObscured,
            focusNode: focusNode,
            onChanged: widget.onChanged,
            style: widget.smallText
                ? bodyMediumTextWithColor(
                    context: context,
                    color: widget.color[900] as Color,
                  )
                : titleMediumTextWithColor(
                    context: context,
                    color: widget.color[900]!,
                  ),
            onSubmitted: widget.onSubmitted,
            textInputAction: widget.type == TextFieldType.Chat
                ? TextInputAction.newline
                : TextInputAction.done,
          ),
        ],
      ),
    );
  }
}
