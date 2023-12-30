// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:appdevproj/providers/themeProvider.dart';
import 'package:appdevproj/services/db.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final double boxWidth = 0.8;
  final double maxBoxWidth = 500;

  final GlobalKey<FormState> _signupFormKey = GlobalKey<FormState>();
  TextEditingController _signupEmailController = TextEditingController();
  TextEditingController _signupPasswordController = TextEditingController();
  TextEditingController _signupConfirmPasswordController =
      TextEditingController();

  final GlobalKey<FormState> _signupEnterNameKey = GlobalKey<FormState>();
  TextEditingController _signupEnterNameController = TextEditingController();

  final _msg = StateProvider<String?>((ref) => null);
  final _enterName = StateProvider<bool>((ref) => false);

  @override
  Widget build(BuildContext context) {
    final themeProvider = ref.watch(ThemeProvider);
    final db = ref.read(DB);

    void _submitSignupForm() async {
      if (_signupFormKey.currentState!.validate()) {
        ref.watch(_msg.notifier).state = await db.signUpWithEmailAndPassword(
          _signupEmailController.text,
          _signupConfirmPasswordController.text,
        );
        if (ref.watch(_msg) == "Success") {
          ref.watch(_msg.notifier).state = null;
          ref.watch(_enterName.notifier).state = true;
        }
      }
    }

    void _submitSignupEnterNameForm() async {
      if (_signupEnterNameKey.currentState!.validate()) {
        ref.watch(_msg.notifier).state =
            db.updateUserName(_signupEnterNameController.text);
        if (ref.watch(_msg) == "Success") {
          context.goNamed('home');
        }
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: themeProvider.fawn,
      body: Center(
        child: !ref.watch(_enterName)
            ? Form(
                key: _signupFormKey,
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          child: Text(
                            'Create Account',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              height: 1,
                              color: themeProvider.black,
                            ),
                          ),
                          padding: EdgeInsets.only(bottom: 8),
                        ),
                        Container(
                          child: Text(
                            'to get started now!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w400,
                                height: 1,
                                color: themeProvider.black),
                          ),
                          padding: EdgeInsets.only(bottom: 28),
                        ),
                        Container(
                          width: boxWidth * MediaQuery.of(context).size.width,
                          constraints: BoxConstraints(
                            maxWidth: maxBoxWidth,
                          ),
                          child: TextFormField(
                            controller: _signupEmailController,
                            textAlign: TextAlign.left,
                            textAlignVertical: TextAlignVertical.center,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              height: 1,
                              color: themeProvider.grey,
                            ),
                            decoration: InputDecoration(
                              errorStyle: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.w500,
                                height: 1,
                                color: themeProvider.err,
                              ),
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 14),
                              fillColor: themeProvider.white,
                              hoverColor: themeProvider.white,
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              hintText: 'Email',
                              hintStyle: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                height: 1,
                                color: themeProvider.grey,
                              ),
                            ),
                            cursorColor: themeProvider.grey,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter an email';
                              }
                              if (!RegExp(
                                      r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
                                  .hasMatch(value)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          padding: EdgeInsets.only(bottom: 12),
                        ),
                        Container(
                          width: boxWidth * MediaQuery.of(context).size.width,
                          constraints: BoxConstraints(
                            maxWidth: maxBoxWidth,
                          ),
                          child: TextFormField(
                            controller: _signupPasswordController,
                            textAlign: TextAlign.left,
                            obscureText: true,
                            textAlignVertical: TextAlignVertical.center,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              height: 1,
                              color: themeProvider.grey,
                            ),
                            decoration: InputDecoration(
                              errorStyle: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.w500,
                                height: 1,
                                color: themeProvider.err,
                              ),
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 14),
                              fillColor: themeProvider.white,
                              hoverColor: themeProvider.white,
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              hintText: 'Password',
                              hintStyle: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                height: 1,
                                color: themeProvider.grey,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a password';
                              } else {
                                if (value.trim().isEmpty) {
                                  return 'Please enter a password';
                                } else {
                                  if (value.length < 8) {
                                    return 'Min Password length is 8';
                                  }
                                }
                              }
                              return null;
                            },
                            cursorColor: themeProvider.grey,
                          ),
                          padding: EdgeInsets.only(bottom: 12),
                        ),
                        Container(
                          width: boxWidth * MediaQuery.of(context).size.width,
                          constraints: BoxConstraints(
                            maxWidth: maxBoxWidth,
                          ),
                          child: TextFormField(
                            controller: _signupConfirmPasswordController,
                            textAlign: TextAlign.left,
                            obscureText: true,
                            textAlignVertical: TextAlignVertical.center,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              height: 1,
                              color: themeProvider.grey,
                            ),
                            decoration: InputDecoration(
                              errorStyle: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.w500,
                                height: 1,
                                color: themeProvider.err,
                              ),
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 14),
                              fillColor: themeProvider.white,
                              hoverColor: themeProvider.white,
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              hintText: 'Confirm Password',
                              hintStyle: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                height: 1,
                                color: themeProvider.grey,
                              ),
                            ),
                            cursorColor: themeProvider.grey,
                            validator: (value) {
                              if (_signupPasswordController.text.isEmpty ||
                                  _signupPasswordController.text.length < 8) {
                                return null;
                              } else {
                                if (value == null || value.isEmpty) {
                                  return 'Please confirm password';
                                } else {
                                  if (value.trim().isEmpty) {
                                    return 'Please confirm password';
                                  } else {
                                    if (value !=
                                        _signupPasswordController.text) {
                                      return 'Passwords do not match';
                                    }
                                  }
                                }
                              }
                              return null;
                            },
                          ),
                          padding: EdgeInsets.only(bottom: 18),
                        ),
                        if (ref.watch(_msg) != null &&
                            ref.watch(_msg) != "Success")
                          Container(
                            width: boxWidth * MediaQuery.of(context).size.width,
                            padding: EdgeInsets.only(bottom: 8),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              ref.watch(_msg) ?? "",
                              style: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.w500,
                                height: 1,
                                color: themeProvider.err,
                              ),
                            ),
                          ),
                        Container(
                          width: boxWidth * MediaQuery.of(context).size.width,
                          constraints: BoxConstraints(
                            maxWidth: maxBoxWidth,
                          ),
                          child: ElevatedButton(
                            onPressed: _submitSignupForm,
                            style: ElevatedButton.styleFrom(
                              shadowColor: Colors.transparent,
                              primary: themeProvider.peach,
                              onPrimary: themeProvider.peach,
                              foregroundColor: themeProvider.fawn,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 32),
                              textStyle: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  height: 1,
                                  color: themeProvider.fawn),
                            ),
                            child: Text('Sign Up'),
                          ),
                          padding: EdgeInsets.only(bottom: 28),
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        width: boxWidth * MediaQuery.of(context).size.width,
                        alignment: Alignment.center,
                        constraints: BoxConstraints(
                          maxWidth: maxBoxWidth,
                        ),
                        child: TextButton(
                          style: ButtonStyle(
                            overlayColor:
                                MaterialStateProperty.all(Colors.transparent),
                          ),
                          onPressed: () {
                            context.goNamed('login');
                          },
                          child: RichText(
                            text: TextSpan(
                              text: "Already have an accouny?",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  height: 1,
                                  color: themeProvider.neutral),
                              children: [
                                TextSpan(
                                  text: " Login",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      height: 1,
                                      color: themeProvider.neutral),
                                ),
                              ],
                            ),
                          ),
                        ),
                        padding: EdgeInsets.only(bottom: 28),
                      ),
                    ),
                  ],
                ),
              )
            : Form(
                key: _signupEnterNameKey,
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: boxWidth * MediaQuery.of(context).size.width,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Enter Your Name',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              height: 1,
                              color: themeProvider.black,
                            ),
                          ),
                          padding: EdgeInsets.only(bottom: 28),
                        ),
                        Container(
                          width: boxWidth * MediaQuery.of(context).size.width,
                          constraints: BoxConstraints(
                            maxWidth: maxBoxWidth,
                          ),
                          child: TextFormField(
                            controller: _signupEnterNameController,
                            textAlign: TextAlign.left,
                            textAlignVertical: TextAlignVertical.center,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              height: 1,
                              color: themeProvider.grey,
                            ),
                            decoration: InputDecoration(
                              errorStyle: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.w500,
                                height: 1,
                                color: themeProvider.err,
                              ),
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 14),
                              fillColor: themeProvider.white,
                              hoverColor: themeProvider.white,
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              hintText: 'Name',
                              hintStyle: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                height: 1,
                                color: themeProvider.grey,
                              ),
                            ),
                            cursorColor: themeProvider.grey,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
                              }
                              if (!RegExp(r'^[a-zA-Z\s\-]+$').hasMatch(value)) {
                                return 'Please enter a valid name';
                              }
                              return null;
                            },
                          ),
                          padding: EdgeInsets.only(bottom: 18),
                        ),
                        if (ref.watch(_msg) != null &&
                            ref.watch(_msg) != "Success")
                          Container(
                            width: boxWidth * MediaQuery.of(context).size.width,
                            padding: EdgeInsets.only(bottom: 8),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              ref.watch(_msg) ?? "",
                              style: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.w500,
                                height: 1,
                                color: themeProvider.err,
                              ),
                            ),
                          ),
                        Container(
                          width: boxWidth * MediaQuery.of(context).size.width,
                          constraints: BoxConstraints(
                            maxWidth: maxBoxWidth,
                          ),
                          child: ElevatedButton(
                            onPressed: _submitSignupEnterNameForm,
                            style: ElevatedButton.styleFrom(
                              shadowColor: Colors.transparent,
                              primary: themeProvider.peach,
                              onPrimary: themeProvider.peach,
                              foregroundColor: themeProvider.fawn,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 32),
                              textStyle: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  height: 1,
                                  color: themeProvider.fawn),
                            ),
                            child: Text('Continue'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
