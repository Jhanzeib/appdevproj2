// ignore_for_file: sort_child_properties_last

import 'package:appdevproj/providers/themeProvider.dart';
import 'package:appdevproj/services/db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final double boxWidth = 0.8;
  final double maxBoxWidth = 500;

  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final TextEditingController _loginEmailController = TextEditingController();
  final TextEditingController _loginPasswordController =
      TextEditingController();

  final _msg = StateProvider<String?>((ref) => null);

  @override
  Widget build(BuildContext context) {
    final db = ref.read(DB);
    final themeProvider = ref.watch(ThemeProvider);

    void _submitLoginForm() async {
      if (_loginFormKey.currentState!.validate()) {
        ref.watch(_msg.notifier).state = await db.loginWithEmailAndPassword(
          _loginEmailController.text,
          _loginPasswordController.text,
        );

        if (ref.watch(_msg) == "Success") {
          context.goNamed('home');
        }
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: themeProvider.fawn,
      body: Center(
        child: Form(
          key: _loginFormKey,
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: Text(
                      'Welcome,',
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
                      'Glad to see you!',
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
                      controller: _loginEmailController,
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
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 14),
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
                        if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
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
                      controller: _loginPasswordController,
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
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 14),
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
                      cursorColor: themeProvider.grey,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        } else {
                          if (value.trim().isEmpty) {
                            return 'Please enter a password';
                          }
                        }
                        return null;
                      },
                    ),
                    padding: EdgeInsets.only(bottom: 18),
                  ),
                  if (ref.watch(_msg) != null && ref.watch(_msg) != "Success")
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
                      onPressed: _submitLoginForm,
                      style: ElevatedButton.styleFrom(
                        shadowColor: Colors.transparent,
                        primary: themeProvider.peach,
                        onPrimary: themeProvider.peach,
                        foregroundColor: themeProvider.fawn,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                        textStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            height: 1,
                            color: themeProvider.fawn),
                      ),
                      child: Text('Login'),
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
                      context.goNamed('signup');
                    },
                    child: RichText(
                      text: TextSpan(
                        text: "Don’t have an account?",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            height: 1,
                            color: themeProvider.neutral),
                        children: [
                          TextSpan(
                            text: " Sign Up",
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
        ),
      ),
    );
  }
}
