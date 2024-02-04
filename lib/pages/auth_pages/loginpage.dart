import 'dart:ffi';

import 'package:cryptocoin/pages/auth_pages/signuppage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/firebase_auth_methods.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:sizer/sizer.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isVisible = true;

  void loginUser() async {
    context.read<FirebaseAuthMethods>().loginWithEmail(
          email: emailController.text.trim(),
          password: passwordController.text,
          context: context,
        );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      left: true,
      right: true,
      child: Scaffold(
        backgroundColor: const Color(0xFFC7BBF2),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 95.0),
              child: Container(
                height: 85.h,
                decoration: const BoxDecoration(
                    color: Color(0xFF413372),
                    borderRadius:
                        BorderRadius.only(topLeft: Radius.circular(80))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 55),
                      child: Text(
                        "Login",
                        style: GoogleFonts.aleo(
                          color: const Color(0xFFffffFF),
                          fontSize: 50,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 50.0),
                          child: SizedBox(
                            width: 80.w,
                            child: TextField(
                              controller: emailController,
                              onChanged: (value) {
                                setState(() {});
                              },
                              style: GoogleFonts.aleo(
                                color: const Color(0xFFffffFF),
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: InputDecoration(
                                isDense: true,
                                filled: true,
                                fillColor: Color(0XffC7BBF2).withOpacity(0.21),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                // icon: Icon(Icons.mail),
                                suffixIcon: emailController.text.isEmpty
                                    ? const Text('')
                                    : GestureDetector(
                                        onTap: () {
                                          emailController.clear();
                                        },
                                        child: const Icon(
                                          Icons.close,
                                          color: Color(0xFFFFFFFF),
                                        )),
                                hintText: 'exemplo@mail.com',
                                hintStyle: GoogleFonts.aleo(
                                  color: const Color(0xFFffffFF),
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                                labelText: 'Email',
                                labelStyle: GoogleFonts.aleo(
                                  color: const Color(0xFFffffFF),
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(13),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 2.5.h,
                        ),
                        SizedBox(
                          width: 80.w,
                          child: TextField(
                            obscureText: isVisible,
                            controller: passwordController,
                            onChanged: (value) {},
                            style: GoogleFonts.aleo(
                              color: const Color(0xFFffffFF),
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                              isDense: true,
                              filled: true,
                              fillColor: Color(0XffC7BBF2).withOpacity(0.21),
                              floatingLabelBehavior: FloatingLabelBehavior.never,
                              // icon: Icon(Icons.mail),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  isVisible = !isVisible;
                                  setState(() {});
                                },
                                child: Icon(
                                  isVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Color(0xFFFFFFFF),
                                ),
                              ),
                              hintText: 'type your password',
                              hintStyle: GoogleFonts.aleo(
                                color: const Color(0xFFffffFF),
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w500,
                              ),
                              labelText: 'Password',
                              labelStyle: GoogleFonts.aleo(
                                color: const Color(0xFFffffFF),
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w500,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(13),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        loginUser();
                      },
                      child: SizedBox(
                        width: 80.w,
                        height: 5.8.h,
                        child: Container(
                          decoration: BoxDecoration(
                              color: const Color(0xFF251A4B),
                              borderRadius: BorderRadius.circular(13)),
                          child: Center(
                            child: Text(
                              "Login",
                              style: GoogleFonts.aleo(
                                color: const Color(0xFFffffFF),
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 7.h,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Don’t have an account?',
                            style: GoogleFonts.aleo(
                              color: const Color(0xFFffffFF),
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    maintainState: false,
                                    builder: (context) => const SignUpPage()),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Color(0xFF251A4B),
                                  borderRadius: BorderRadius.circular(6)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 6.0, horizontal: 10.0),
                                child: Text(
                                  'Sign Up',
                                  style: GoogleFonts.aleo(
                                    color: const Color(0xFFffffFF),
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
