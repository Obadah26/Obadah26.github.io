import 'package:alhadiqa/const.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RoundedTextField extends StatefulWidget {
  const RoundedTextField({
    super.key,
    required this.textHint,
    this.icon,
    required this.keyboardType,
    this.width = 350,
    this.height,
    required this.hintColor,
    this.onChanged,
    this.controller,
    required this.textColor,
    this.suffixIcon,
    this.onPressedIcon,
    required this.obscure,
  });

  final String textHint;
  final IconData? icon;
  final IconData? suffixIcon;
  final TextInputType keyboardType;
  final double? width;
  final double? height;
  final Color hintColor;
  final Color textColor;
  final Function(String)? onChanged;
  final Function()? onPressedIcon;
  final TextEditingController? controller;
  final bool obscure;

  @override
  State<RoundedTextField> createState() => _RoundedTextFieldState();
}

class _RoundedTextFieldState extends State<RoundedTextField> {
  late bool _obscureText;
  late IconData _suffixIcon;
  late bool _showSuffixIcon;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscure;
    _suffixIcon = widget.obscure ? Icons.visibility_off : Icons.visibility;
    _showSuffixIcon = widget.keyboardType == TextInputType.visiblePassword;
  }

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
      _suffixIcon = _obscureText ? Icons.visibility_off : Icons.visibility;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: TextField(
          obscureText: _obscureText,
          controller: widget.controller,
          onChanged: widget.onChanged,
          textAlign: TextAlign.center,
          keyboardType: widget.keyboardType,
          style: GoogleFonts.cairo(
            textStyle: TextStyle(color: widget.textColor),
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: kLightPrimaryColor, width: 1.5),
              borderRadius: BorderRadius.circular(8.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: kLightPrimaryColor, width: 2),
              borderRadius: BorderRadius.circular(8.0),
            ),
            prefixIcon: Icon(widget.icon, color: kLightPrimaryColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none,
            ),
            hintText: widget.textHint,
            hintStyle: GoogleFonts.cairo(
              textStyle: TextStyle(color: widget.hintColor),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 12,
            ),
            suffixIcon:
                _showSuffixIcon
                    ? IconButton(
                      icon: Icon(_suffixIcon, color: kLightPrimaryColor),
                      onPressed: _toggleVisibility,
                    )
                    : null,
          ),
        ),
      ),
    );
  }
}
