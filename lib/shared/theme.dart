import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const double horizontalMargin = 24.0;

Color mainColor = Color(0xFF070D0C);
Color secondColor = Color(0xFF4ecdc4);
Color successColor = Color(0xFF00ca71);
Color warningColor = Color(0xFFffe66d);
Color errorColor = Color(0xFFff6b6b);
Color textNumberColor = Color(0xFFffbf69);
Color greyColor = Color(0xFFced4da);
Color bgColor = Color(0xFFf7fff7);
Color blackColor = Colors.black87;

TextStyle blackTextFont = GoogleFonts.raleway(
    color: blackColor, fontWeight: FontWeight.w500, height: 1.6);
TextStyle whiteTextFont = GoogleFonts.raleway(
    color: Colors.white, fontWeight: FontWeight.w500, height: 1.6);
TextStyle mainTextFont = GoogleFonts.raleway(
    color: mainColor, fontWeight: FontWeight.w500, height: 1.6);
TextStyle greyTextFont = GoogleFonts.raleway(
    color: greyColor, fontWeight: FontWeight.w500, height: 1.6);
TextStyle successTextFont = GoogleFonts.raleway(
    color: successColor, fontWeight: FontWeight.w500, height: 1.6);

TextStyle whiteNumberFont =
GoogleFonts.raleway(color: Colors.white, height: 1.6);
TextStyle yellowNumberFont =
GoogleFonts.raleway(color: textNumberColor, height: 1.6);