import 'package:flutter/material.dart';
import 'package:toastie/themes/colors.dart';

/* Gradient for the main CTA buttons. */
LinearGradient gradientButtonMain = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [accentYellow, Color(0xFFFFC945), primary],
  stops: [0, 0.25, 0.7],
);

LinearGradient gradientButtonMainYellowFadeEarlier = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [accentYellow, Color(0xFFFFC945), primary],
  stops: [0, 0.15, 0.7],
);

/* Gradient for the Log in buttons. */
LinearGradient gradientButtonLogIn = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [accentPink, primary],
);

/* Gradient for the button on the Our Story page. */
LinearGradient gradientButtonOurStory = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [accentPink[500]!, primary[600]!],
);

/** Gradient for the disabled button. */
LinearGradient gradientDisabledButton = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    neutral[300] as Color,
    neutral[300] as Color,
  ],
);

/** Gradient with info colors. Used for subscriptions and membership card. */
LinearGradient infoGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    info,
    info[900] as Color,
  ],
);

/** Gradient with success colors. Used for subscriptions and membership card. */
LinearGradient successGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    success,
    success[900] as Color,
  ],
);

/** Gradient with neutral colors. Used for subscriptions and membership card. */
LinearGradient neutralGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    neutral[400] as Color,
    neutral[900] as Color,
  ],
);
