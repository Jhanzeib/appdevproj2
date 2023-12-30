// ignore_for_file: sort_child_properties_last

import 'dart:developer';

import 'package:appdevproj/providers/profileProvider.dart';
import 'package:appdevproj/providers/themeProvider.dart';
import 'package:appdevproj/services/db.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final GlobalKey<FormState> _profileNameFormKey = GlobalKey<FormState>();
  final TextEditingController _profileNameController = TextEditingController();

  final GlobalKey<FormState> _profileEmailFormKey = GlobalKey<FormState>();
  final TextEditingController _profileEmailController = TextEditingController();

  final GlobalKey<FormState> _profilePasswordFormKey = GlobalKey<FormState>();
  final TextEditingController _profilePasswordController =
      TextEditingController();

  final _msg = StateProvider<String?>((ref) => null);

  @override
  void initState() {
    super.initState();
    final db = ref.read(DB);
    _profileNameController.value = TextEditingValue(text: db.userName());
    _profileEmailController.value = TextEditingValue(text: db.userEmail());
  }

  void _submitNameForm() async {
    if (_profileNameFormKey.currentState!.validate()) {
      // ref.watch(_msg.notifier).state = await _auth.loginWithEmailAndPassword(
      //   _profileNameController.text,
      // );
    }
  }

  void _submitEmailForm() async {
    if (_profileEmailFormKey.currentState!.validate()) {}
  }

  void _submitPasswordForm() async {
    if (_profilePasswordFormKey.currentState!.validate()) {}
  }

  final FocusNode _focusName = FocusNode();
  final FocusNode _focusEmail = FocusNode();

  @override
  Widget build(BuildContext context) {
    final themeProvider = ref.watch(ThemeProvider);
    final profileProvider = ref.watch(ProfileProvider);
    final db = ref.read(DB);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: themeProvider.fawn,
      body: WillPopScope(
          onWillPop: () async {
            return true;
          },
          child: Center(
            child: Container(
              margin: EdgeInsets.only(
                top: 0.1 * MediaQuery.of(context).size.height,
                bottom: 0.05 * MediaQuery.of(context).size.height,
                left: 36,
                right: 36,
              ),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => context.goNamed('home'),
                        child: Icon(
                          Icons.chevron_left,
                          color: themeProvider.black,
                          size: 24,
                        ),
                      ),
                      Text(
                        "Profile",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          height: 1,
                        ),
                      ),
                      Icon(
                        Icons.chevron_left,
                        color: Colors.transparent,
                        size: 16,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Name",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    height: 1,
                                    color: themeProvider.black,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    if (profileProvider.nameEdit) {
                                      db.updateUserName(
                                          _profileNameController.text);
                                      profileProvider.setNameEdit(false);
                                      FocusScope.of(context).unfocus();
                                    } else {
                                      profileProvider.setNameEdit(true);
                                      FocusScope.of(context)
                                          .requestFocus(_focusName);
                                    }
                                  },
                                  child: profileProvider.nameEdit
                                      ? Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 4, horizontal: 6),
                                          child: Text(
                                            "Save",
                                            style: TextStyle(
                                                fontSize: 10,
                                                height: 1,
                                                fontWeight: FontWeight.w600,
                                                color: themeProvider.fawn),
                                          ),
                                          decoration: BoxDecoration(
                                            color: themeProvider.info,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                        )
                                      : Icon(
                                          Icons.edit,
                                          color: themeProvider.peach,
                                          size: 20,
                                        ),
                                ),
                              ],
                            ),
                            Container(
                              child: TextFormField(
                                focusNode: _focusName,
                                controller: _profileNameController,
                                enabled: profileProvider.nameEdit,
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
                                      EdgeInsets.only(top: 16, bottom: 8),
                                  fillColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                cursorColor: themeProvider.grey,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your name';
                                  }
                                  // Update the regular expression to allow letters, spaces, and possibly other characters
                                  if (!RegExp(r'^[a-zA-Z ]+$')
                                      .hasMatch(value)) {
                                    return 'Please enter a valid name';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Divider(
                              height: 1,
                              color: themeProvider.grey,
                              thickness: 1,
                            ),
                          ],
                        ),
                        padding: EdgeInsets.only(bottom: 24),
                      ),
                      Container(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Email",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    height: 1,
                                    color: themeProvider.black,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    if (profileProvider.emailEdit) {
                                      db.updateUserEmail(
                                          _profileEmailController.text);
                                      profileProvider.setEmailEdit(false);
                                      FocusScope.of(context).unfocus();
                                    } else {
                                      profileProvider.setEmailEdit(true);
                                      FocusScope.of(context)
                                          .requestFocus(_focusEmail);
                                    }
                                  },
                                  child: profileProvider.emailEdit
                                      ? Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 4, horizontal: 6),
                                          child: Text(
                                            "Save",
                                            style: TextStyle(
                                                fontSize: 10,
                                                height: 1,
                                                fontWeight: FontWeight.w600,
                                                color: themeProvider.fawn),
                                          ),
                                          decoration: BoxDecoration(
                                            color: themeProvider.info,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                        )
                                      : Icon(
                                          Icons.edit,
                                          color: themeProvider.peach,
                                          size: 20,
                                        ),
                                ),
                              ],
                            ),
                            Container(
                              child: TextFormField(
                                focusNode: _focusEmail,
                                controller: _profileEmailController,
                                enabled: profileProvider.emailEdit,
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
                                      EdgeInsets.only(top: 16, bottom: 8),
                                  fillColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
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
                            ),
                            Divider(
                              height: 1,
                              color: themeProvider.grey,
                              thickness: 1,
                            ),
                          ],
                        ),
                        padding: EdgeInsets.only(bottom: 24),
                      ),
                      Container(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "New Password",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    height: 1,
                                    color: themeProvider.black,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    db.updateUserPassword(
                                        _profilePasswordController.text);
                                    FocusScope.of(context).unfocus();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 6),
                                    child: Text(
                                      "Update",
                                      style: TextStyle(
                                          fontSize: 10,
                                          height: 1,
                                          fontWeight: FontWeight.w600,
                                          color: themeProvider.fawn),
                                    ),
                                    decoration: BoxDecoration(
                                      color: themeProvider.info,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              child: TextFormField(
                                controller: _profilePasswordController,
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
                                      EdgeInsets.only(top: 16, bottom: 8),
                                  fillColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
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
                            ),
                            Divider(
                              height: 1,
                              color: themeProvider.grey,
                              thickness: 1,
                            ),
                          ],
                        ),
                        padding: EdgeInsets.only(bottom: 24),
                      ),
                    ],
                  ),
                  Container(
                    width: MediaQuery.of(context).size.height - 72,
                    child: ElevatedButton(
                      onPressed: () async {
                        await db.logout();

                        context.goNamed('login');
                      },
                      style: ElevatedButton.styleFrom(
                        shadowColor: Colors.transparent,
                        primary: themeProvider.err,
                        onPrimary: themeProvider.err,
                        foregroundColor: themeProvider.fawn,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                        textStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            height: 1,
                            color: themeProvider.fawn),
                      ),
                      child: Text('Logout'),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
