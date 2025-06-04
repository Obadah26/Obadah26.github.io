import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color kPrimaryTextLight = Color(0xFF212121);
const Color kSecondaryTextLight = Color(0xFF757575);
const Color kPrimaryTextDark = Color(0xFFFFFFFF);

// UI Colors
const Color kLightPrimaryColor = Color(0xFF00a674);
const Color kPrimaryColor = Color(0xFF009995);
const Color kDarkPrimaryColor = Color(0xFF008aad);
const Color kSecondaryColor = Color(0xFF4caf50);
const Color kMainBorderColor = Color.fromRGBO(76, 175, 80, 0.5);
const Color kSecondaryBorderColor = Color.fromRGBO(76, 175, 80, 0.3);
const Color kBackgroundColor = Color(0xFFFAFAFA);
TextStyle get kHeading1Text => GoogleFonts.elMessiri(
  color: kPrimaryTextLight,
  fontSize: 32,
  fontWeight: FontWeight.w700,
);

TextStyle get kHeading2Text => GoogleFonts.elMessiri(
  color: kPrimaryTextLight,
  fontSize: 24,
  fontWeight: FontWeight.w700,
);

TextStyle get kBodyLargeText => GoogleFonts.cairo(
  color: kPrimaryTextLight,
  fontSize: 18,
  fontWeight: FontWeight.w400,
);

TextStyle get kBodyRegularText => GoogleFonts.cairo(
  color: kPrimaryTextLight,
  fontSize: 16,
  fontWeight: FontWeight.w400,
);

TextStyle get kBodySmallText => GoogleFonts.cairo(
  color: kPrimaryTextLight,
  fontSize: 14,
  fontWeight: FontWeight.w400,
);

TextStyle get kSecondaryText => GoogleFonts.cairo(
  color: kSecondaryTextLight,
  fontSize: 16,
  fontWeight: FontWeight.w500,
);

TextStyle get kHeading1TextDark => GoogleFonts.elMessiri(
  color: kPrimaryTextDark,
  fontSize: 32,
  fontWeight: FontWeight.w700,
);

TextStyle get kHeading2TextDark => GoogleFonts.elMessiri(
  color: kPrimaryTextDark,
  fontSize: 24,
  fontWeight: FontWeight.w600,
);

TextStyle get kBodyLargeTextDark => GoogleFonts.cairo(
  color: kPrimaryTextDark,
  fontSize: 18,
  fontWeight: FontWeight.w400,
);

TextStyle get kBodyRegularTextDark => GoogleFonts.cairo(
  color: kPrimaryTextDark,
  fontSize: 16,
  fontWeight: FontWeight.w400,
);

TextStyle get kBodySmallTextDark => GoogleFonts.cairo(
  color: kPrimaryTextDark,
  fontSize: 14,
  fontWeight: FontWeight.w400,
);

TextStyle get kSecondaryTextDark => GoogleFonts.cairo(
  color: kSecondaryColor,
  fontSize: 16,
  fontWeight: FontWeight.w500,
);
