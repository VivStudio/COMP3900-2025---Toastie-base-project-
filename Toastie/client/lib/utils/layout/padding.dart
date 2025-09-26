import 'package:flutter/material.dart';
import 'package:toastie/utils/layout/grid.dart';
import 'package:toastie/utils/responsive_utils.dart';

// Used for adding delete button on images (eg. Magic tracker, meal tracker)
Widget paddingForAddingDeleteButton({required Widget child}) {
  return Padding(
    padding: EdgeInsets.only(
      top: gridbaseline * 2,
      right: gridbaseline * 2,
    ),
    child: child,
  );
}

const EdgeInsets donationButtonPadding = EdgeInsets.only(
  top: gridbaseline * 2,
  left: gridbaseline * 4,
  right: gridbaseline * 4,
);

// TODO: Deprecate when card v3 has been deprecated.
const EdgeInsets cardPadding = EdgeInsets.symmetric(
  vertical: gridbaseline * 2,
  horizontal: gridbaseline * 4,
);
const EdgeInsets cardInnerPadding = EdgeInsets.symmetric(
  vertical: gridbaseline,
  horizontal: gridbaseline * 2,
);
// Eg. Home magic tracker, summary card, summary module cards.
const EdgeInsets cardLargeInnerPadding = EdgeInsets.symmetric(
  vertical: gridbaseline * 2,
  horizontal: gridbaseline * 2,
);

const EdgeInsets chatInputBarPadding = EdgeInsets.symmetric(
  vertical: gridbaseline,
  horizontal: gridbaseline * 2,
);

const EdgeInsets pillInnerPadding = EdgeInsets.symmetric(
  vertical: gridbaseline / 2,
  horizontal: gridbaseline * 1.5,
);

const EdgeInsets radioCardInnerPadding = EdgeInsets.only(
  left: gridbaseline,
  right: gridbaseline * 2,
  top: gridbaseline,
  bottom: gridbaseline,
);

EdgeInsets cardEditorLargeInnerPadding({required BuildContext context}) {
  return EdgeInsets.only(
    top: scaleBySystemFont(context: context, size: gridbaseline * 4),
    right: gridbaseline * 2,
    bottom: gridbaseline * 4,
    left: gridbaseline * 2,
  );
}

const EdgeInsets chatInnerPadding = EdgeInsets.symmetric(
  vertical: gridbaseline,
  horizontal: gridbaseline * 2,
);

const EdgeInsets cardRightPadding = EdgeInsets.only(right: gridbaseline * 2);

const EdgeInsets cardWithImagePadding = EdgeInsets.all(gridbaseline * 2);

const EdgeInsets cardOuterEditStatePadding = EdgeInsets.only(
  top: gridbaseline * 2,
  bottom: gridbaseline * 2,
  right: gridbaseline,
);

const EdgeInsets cardOuterPadding = EdgeInsets.symmetric(
  vertical: gridbaseline / 2,
);

const EdgeInsets cardHeaderPadding = EdgeInsets.symmetric(
  vertical: gridbaseline * 1.25,
  horizontal: gridbaseline * 2,
);

const EdgeInsets uniformedPadding = EdgeInsets.all(gridbaseline);

const EdgeInsets topPadding = EdgeInsets.only(
  top: gridbaseline * 2,
);

// Padding in between the toggle cards.
const EdgeInsets toggleCardBottomPadding =
    EdgeInsets.only(bottom: gridbaseline);

const EdgeInsets textCardPadding = EdgeInsets.symmetric(
  vertical: gridbaseline * 2,
  horizontal: gridbaseline * 3,
);

const EdgeInsets largeCardPadding = EdgeInsets.symmetric(
  vertical: gridbaseline * 4,
  horizontal: gridbaseline * 3,
);

const double textBoxContentPaddingHorizontal = gridbaseline * 2;
const double textBoxContentPaddingVertical = gridbaseline;
