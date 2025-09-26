import 'package:flutter/material.dart';
import 'package:toastie/themes/colors.dart';
import 'package:toastie/themes/text/text.dart';
import 'package:toastie/utils/layout/border_radius.dart';
import 'package:toastie/utils/layout/padding.dart';

class ToastieSearchBar extends StatefulWidget {
  ToastieSearchBar({
    required this.onTextChanged,
    required this.controller,
  });

  final ValueChanged<String> onTextChanged;
  final TextEditingController controller;

  final _ToastieSearchBarState searchBarState = _ToastieSearchBarState();

  void clearSearchBar() {
    searchBarState.clearSearchBar();
  }

  void dispose() {
    searchBarState.dispose();
  }

  @override
  _ToastieSearchBarState createState() => searchBarState;
}

class _ToastieSearchBarState extends State<ToastieSearchBar> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  void clearSearchBar() {
    widget.controller.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          focusNode: _focusNode,
          controller: widget.controller,
          onChanged: widget.onTextChanged,
          textInputAction: TextInputAction.search,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: borderRadius,
              borderSide: BorderSide(
                color: neutral[300]!,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: borderRadius,
              borderSide: BorderSide(
                color: neutral[300]!,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: borderRadius,
              borderSide: BorderSide(
                color: primary,
              ),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(
              horizontal: textBoxContentPaddingHorizontal,
              vertical: textBoxContentPaddingVertical,
            ),
            hintText: 'Search or add',
            hintStyle: titleMediumTextWithColor(
              context: context,
              color: neutral[900] as Color,
            ),
            prefixIcon: IconButton(
              icon: Icon(Icons.search),
              color: _isFocused ? primary : neutral[300],
              onPressed: () {},
            ),
          ),
          minLines: 1,
          maxLines:
              2, // Hard coded value to prevent overflow on dynamic text sizes
          style: titleMediumTextWithColor(
            context: context,
            color: neutral[900] as Color,
          ),
          cursorColor: primary,
        ),
      ],
    );
  }
}
