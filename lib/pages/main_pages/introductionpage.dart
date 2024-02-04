import 'package:cryptocoin/pages/auth_pages/loginpage.dart';
import 'package:cryptocoin/pages/auth_pages/signuppage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

class Introduction extends StatefulWidget {
  const Introduction({super.key});

  @override
  State<Introduction> createState() => _IntroductionState();
}

class _IntroductionState extends State<Introduction> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFFFFFFF), // #FFFFFF
            Color(0xFFB09AFF), // #B09AFF
            Color(0xFF8361FF), // #8361FF
            Color(0xFF9679FF), // #9679FF
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
       children: [
        Padding(
          padding: const EdgeInsets.only(top: 38.0, left: 10, right: 10),
          child: Text("Track your favourite crypto currency with CRYPTOCOIN",
          textAlign: TextAlign.center,
              style: GoogleFonts.aleo(
                fontSize: 35,
                color: Color(0xFF413372),
                decoration: TextDecoration.none,
              )),
        ),
        SvgPicture.asset(
          "assets/cryptocurrency.svg",
          fit: BoxFit.fitHeight,
          height: 500,
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  maintainState: false,
                  builder: (context) => const LoginPage()),
            );
          },
          child: Container(
            width: 90.w,
            decoration: BoxDecoration(
                color: Color(0xFF413372),
                borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
              child: Text('Get started',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.aleo(
                    fontSize: 25,
                    color: Colors.white,
                    decoration: TextDecoration.none,
                  )),
            ),
          ),
        )
      ]),
    );
  }
}
