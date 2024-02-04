import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void showCustomFlushBar(
    BuildContext context, String _customTextMessage, IconData _customIcon) {
  Flushbar(
    flushbarPosition: FlushbarPosition.TOP,
    margin: const EdgeInsets.all(14),
    borderRadius: BorderRadius.circular(12),
    icon: Padding(
      padding: const EdgeInsets.only(left: 9.0),
      child: Icon(
        _customIcon,
        color: Color(0xFF413372),
        size: 24,
      ),
    ),
    backgroundColor: const Color(0xFFffffff),
    duration: const Duration(seconds: 4),
    messageText: Text(
      _customTextMessage,
      style: GoogleFonts.inter(
        color: const Color(0xFF413372),
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    ),
  ).show(context);
}