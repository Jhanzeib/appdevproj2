// ignore_for_file: sort_child_properties_last

import 'package:appdevproj/controllers/subjectController.dart';
import 'package:appdevproj/models/subjectModel.dart';
import 'package:appdevproj/providers/courseProvider.dart';
import 'package:appdevproj/providers/themeProvider.dart';
import 'package:flutter/material.dart';
import 'package:appdevproj/components/meter.dart';
import 'package:flutter_scroll_shadow/flutter_scroll_shadow.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appdevproj/providers/subjectProvider.dart';
import 'package:go_router/go_router.dart';

class CourseScreen extends ConsumerStatefulWidget {
  CourseScreen({Key? key}) : super(key: key) {}

  @override
  _CourseScreenState createState() => _CourseScreenState();
}

class _CourseScreenState extends ConsumerState<CourseScreen> {
  bool _isPractice = true;
  double _toggleButtonHeight = 40;
  double _toggleButtonWidth = 96;
  ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = ref.watch(ThemeProvider);
    final courseProvider = ref.watch(CourseProvider);
    final subjectController = ref.watch(SubjectController);
    final subjectProvider = ref.watch(SubjectProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: themeProvider.fawn,
      body: WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: Center(
          child: Container(
            margin: EdgeInsets.symmetric(
                vertical: 0.1 * MediaQuery.of(context).size.height,
                horizontal: 36),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => {context.goNamed('home')},
                      child: Icon(
                        Icons.chevron_left,
                        color: themeProvider.black,
                        size: 24,
                      ),
                    ),
                    Text(
                      courseProvider.selectedCourse.name,
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
                // Stack(
                //   children: [
                //     Center(
                //       child: Container(
                //         height: _toggleButtonHeight,
                //         width: 2 * _toggleButtonWidth,
                //         child: AnimatedContainer(
                //           curve: Curves.easeInOut,
                //           margin: EdgeInsets.only(
                //               left: _isPractice ? 0 : _toggleButtonWidth,
                //               right: _isPractice ? _toggleButtonWidth : 0),
                //           duration: Duration(milliseconds: 250),
                //           height: _toggleButtonHeight,
                //           decoration: BoxDecoration(
                //             border: Border.all(color: Colors.black),
                //             borderRadius: BorderRadius.circular(8),
                //           ),
                //         ),
                //       ),
                //     ),
                //     Row(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       crossAxisAlignment: CrossAxisAlignment.center,
                //       children: [
                //         GestureDetector(
                //           onTap: () {
                //             setState(() {
                //               _isPractice = true;
                //             });
                //           },
                //           child: Container(
                //             alignment: Alignment.center,
                //             height: _toggleButtonHeight,
                //             width: _toggleButtonWidth,
                //             color: Colors.transparent,
                //             child: Text(
                //               "Practice",
                //               style: TextStyle(
                //                   fontSize: 16,
                //                   fontWeight: FontWeight.w400,
                //                   height: 1,
                //                   color: themeProvider.black),
                //             ),
                //           ),
                //         ),
                //         GestureDetector(
                //           onTap: () {
                //             setState(() {
                //               _isPractice = false;
                //             });
                //           },
                //           child: Container(
                //             alignment: Alignment.center,
                //             height: _toggleButtonHeight,
                //             width: _toggleButtonWidth,
                //             color: Colors.transparent,
                //             child: Text(
                //               "Mocks",
                //               style: TextStyle(
                //                   fontSize: 16,
                //                   fontWeight: FontWeight.w400,
                //                   height: 1,
                //                   color: themeProvider.black),
                //             ),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ],
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                        top: 10,
                        bottom: 10,
                        right: 0.044 * MediaQuery.of(context).size.width,
                      ),
                      child: Meter(
                        score: courseProvider.meterCompleteness,
                        label: 'completed',
                        fillColor: themeProvider.yellow,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        top: 10,
                        bottom: 10,
                        left: 0.044 * MediaQuery.of(context).size.width,
                      ),
                      child: Meter(
                        score: courseProvider.meterAccuracy,
                        label: 'accurate',
                        fillColor: themeProvider.blue,
                      ),
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.topLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 8),
                        child: Text(
                          'Subjects',
                          style: TextStyle(
                            color: themeProvider.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            height: 1,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.topCenter,
                        constraints: BoxConstraints(
                          maxHeight: 0.32 * MediaQuery.of(context).size.height,
                        ),
                        child: FutureBuilder<List<SubjectModel>>(
                          future: courseProvider.subjects,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              List<SubjectModel> _subjects =
                                  snapshot.data ?? [];
                              return ScrollShadow(
                                color: Color.fromARGB(95, 155, 155, 155),
                                child: ListView.builder(
                                  key: PageStorageKey<String>('subjectList'),
                                  scrollDirection: Axis.vertical,
                                  padding: EdgeInsets.all(0),
                                  itemCount: _subjects.length,
                                  controller: scrollController,
                                  itemBuilder: (context, index) {
                                    return SubjectCard(
                                      key: ValueKey(_subjects[index]),
                                      index: index,
                                      subject: _subjects[index],
                                      maxLength: _subjects.length,
                                      parentThemeProvider: themeProvider,
                                      parentSubjectController:
                                          subjectController,
                                      parentSubjectProvider: subjectProvider,
                                    );
                                  },
                                ),
                              );
                            }
                          },
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
    );
  }
}

class SubjectCard extends ConsumerStatefulWidget {
  final int index;
  final SubjectModel subject;
  final int maxLength;
  final themeProvider parentThemeProvider;
  final subjectController parentSubjectController;
  final subjectProvider parentSubjectProvider;

  const SubjectCard(
      {Key? key,
      required this.index,
      required this.subject,
      required this.parentThemeProvider,
      required this.parentSubjectController,
      required this.parentSubjectProvider,
      required this.maxLength})
      : super(key: key);

  @override
  _SubjectCardState createState() => _SubjectCardState();
}

class _SubjectCardState extends ConsumerState<SubjectCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.parentSubjectProvider.setSelectedSubject(widget.subject);
        widget.parentSubjectProvider.resetMeter();
        widget.parentSubjectController.getChapters();
        widget.parentSubjectController.getStats();
        context.goNamed('subject');
      },
      child: Container(
        width: 0.8 * MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(
            bottom: widget.index == widget.maxLength - 1 ? 0 : 16),
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: widget.parentThemeProvider.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.subject.name,
              style: TextStyle(
                height: 1,
                fontSize: 23,
                fontWeight: FontWeight.w400,
                color: widget.parentThemeProvider.black,
              ),
            ),
            Container(
              height: 32,
              width: 30,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.subject.img),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
