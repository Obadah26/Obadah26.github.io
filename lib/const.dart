import 'package:flutter/material.dart';

// Text Colors
const Color kPrimaryTextLight = Color(0xFF212121); // Almost black
const Color kSecondaryTextLight = Color(0xFF757575); // Gray
const Color kPrimaryTextDark = Color(0xFFFFFFFF); // White on dark backgrounds
const Color kAccentColor = Color(0xFF119DA4); // Accent color
const Color kSecondaryColor = Color(0xFFB3E5FC); // Secondary color

// Text Styles - All const
const TextStyle kHeading1Text = TextStyle(
  color: kPrimaryTextLight,
  fontSize: 32,
  fontWeight: FontWeight.w700,
  height: 1.2,
);

const TextStyle kHeading2Text = TextStyle(
  color: kPrimaryTextLight,
  fontSize: 24,
  fontWeight: FontWeight.w600,
  height: 1.3,
);

const TextStyle kBodyLargeText = TextStyle(
  color: kPrimaryTextLight,
  fontSize: 18,
  fontWeight: FontWeight.w400,
  height: 1.5,
);

const TextStyle kBodyRegularText = TextStyle(
  color: kPrimaryTextLight,
  fontSize: 16,
  fontWeight: FontWeight.w400,
  height: 1.5,
);

const TextStyle kBodySmallText = TextStyle(
  color: kPrimaryTextLight,
  fontSize: 14,
  fontWeight: FontWeight.w400,
  height: 1.5,
);

const TextStyle kSecondaryText = TextStyle(
  color: kSecondaryTextLight,
  fontSize: 16,
  fontWeight: FontWeight.w500,
);

const TextStyle kLinkText = TextStyle(
  color: kAccentColor,
  fontSize: 16,
  fontWeight: FontWeight.w600,
  decoration: TextDecoration.underline,
  decorationColor: kAccentColor,
);

// Dark Mode Variants (also const)
const TextStyle kHeading1TextDark = TextStyle(
  color: kPrimaryTextDark,
  fontSize: 32,
  fontWeight: FontWeight.w700,
  height: 1.2,
);

const TextStyle kHeading2TextDark = TextStyle(
  color: kPrimaryTextDark,
  fontSize: 24,
  fontWeight: FontWeight.w600,
  height: 1.3,
);

const TextStyle kBodyLargeTextDark = TextStyle(
  color: kPrimaryTextDark,
  fontSize: 18,
  fontWeight: FontWeight.w400,
  height: 1.5,
);

const TextStyle kBodyRegularTextDark = TextStyle(
  color: kPrimaryTextDark,
  fontSize: 16,
  fontWeight: FontWeight.w400,
  height: 1.5,
);

const TextStyle kBodySmallTextDark = TextStyle(
  color: kPrimaryTextDark,
  fontSize: 14,
  fontWeight: FontWeight.w400,
  height: 1.5,
);

const TextStyle kSecondaryTextDark = TextStyle(
  color: kSecondaryColor,
  fontSize: 16,
  fontWeight: FontWeight.w500,
);
