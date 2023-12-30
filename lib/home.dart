// ignore_for_file: sort_child_properties_last

import 'package:appdevproj/controllers/courseController.dart';
import 'package:appdevproj/providers/homeProvider.dart';
import 'package:appdevproj/providers/profileProvider.dart';
import 'package:appdevproj/providers/themeProvider.dart';
import 'package:appdevproj/providers/courseProvider.dart';
import 'package:appdevproj/controllers/homeController.dart';
import 'package:appdevproj/services/db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final homeController = ref.read(HomeController);
      homeController.getUserCourses();
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = ref.watch(ThemeProvider);
    final homeProvider = ref.watch(HomeProvider);
    final homeController = ref.read(HomeController);
    final courseProvider = ref.read(CourseProvider);
    final courseController = ref.read(CourseController);
    final profileProvider = ref.watch(ProfileProvider);
    final db = ref.read(DB);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: themeProvider.fawn,
      body: Center(
        child: Stack(
          children: [
            Positioned(
              top: 0.1 * MediaQuery.of(context).size.height,
              left: 0,
              right: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: "Hi ",
                        style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w300,
                            height: 1,
                            color: themeProvider.grey),
                        children: [
                          TextSpan(
                            text: db.userName(),
                            style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w600,
                                height: 1,
                                color: themeProvider.black),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        profileProvider.setEmailEdit(false);
                        profileProvider.setNameEdit(false);

                        context.goNamed('profile');
                      },
                      child: Container(
                        height: 24,
                        width: 23,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/icons/profile.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 36),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                top: 0.1 * MediaQuery.of(context).size.height,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.only(
                      left: 36,
                      right: 36,
                      bottom: 0.05 * MediaQuery.of(context).size.height,
                    ),
                    alignment: Alignment.center,
                    child: RichText(
                      text: TextSpan(
                        text: "Lets ",
                        style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.w400,
                            height: 1,
                            color: themeProvider.grey),
                        children: [
                          TextSpan(
                            text: "maximize your scores ",
                            style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.w600,
                                height: 1,
                                color: themeProvider.black),
                          ),
                          TextSpan(
                            text: "& ",
                            style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.w400,
                                height: 1,
                                color: themeProvider.grey),
                          ),
                          TextSpan(
                            text: "minimize the stress!",
                            style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.w600,
                                height: 1,
                                color: themeProvider.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 0.48 * MediaQuery.of(context).size.height,
                    alignment: Alignment.topLeft,
                    child: FutureBuilder<List<DisplayedCourseListModel>>(
                      future: homeProvider.displayedCourseList,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          List<DisplayedCourseListModel> _courses =
                              snapshot.data ?? [];

                          return ListView.builder(
                            key: PageStorageKey<String>('coursesList'),
                            scrollDirection: Axis.horizontal,
                            itemCount: _courses.length,
                            controller: scrollController,
                            itemBuilder: (context, index) {
                              return CourseCard(
                                key: ValueKey(_courses[index]),
                                index: index,
                                course: _courses[index],
                                maxLength: _courses.length,
                                parentHomeController: homeController,
                                parentThemeProvider: themeProvider,
                                parentCourseProvider: courseProvider,
                                parentCourseController: courseController,
                              );
                            },
                          );
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CourseCard extends ConsumerStatefulWidget {
  final int index;
  final int maxLength;
  final DisplayedCourseListModel course;
  final homeController parentHomeController;
  final themeProvider parentThemeProvider;
  final courseProvider parentCourseProvider;
  final courseController parentCourseController;

  const CourseCard(
      {Key? key,
      required this.index,
      required this.course,
      required this.maxLength,
      required this.parentHomeController,
      required this.parentCourseProvider,
      required this.parentCourseController,
      required this.parentThemeProvider})
      : super(key: key);

  @override
  _CourseCardState createState() => _CourseCardState();
}

class _CourseCardState extends ConsumerState<CourseCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: widget.index == 0 ? 36 : 0,
        right: widget.index == widget.maxLength - 1 ? 36 : 24,
      ),
      height: 0.48 * MediaQuery.of(context).size.height,
      width: 0.68 * MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(30.0),
        ),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(30.0),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.course.img),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(24),
              child: ElevatedButton(
                onPressed: () {
                  if (!widget.course.subscribed) {
                    widget.parentHomeController.subscribe(widget.course.id);
                  } else {
                    widget.parentHomeController.unsubscribe(widget.course.id);
                  }
                },
                style: ElevatedButton.styleFrom(
                  shadowColor: Colors.transparent,
                  primary: widget.course.subscribed
                      ? widget.parentThemeProvider.peach
                      : widget.parentThemeProvider.blue,
                  onPrimary: widget.course.subscribed
                      ? widget.parentThemeProvider.peach
                      : widget.parentThemeProvider.blue,
                  foregroundColor: widget.parentThemeProvider.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                  textStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      height: 1,
                      color: widget.parentThemeProvider.black),
                ),
                child: Text(
                    widget.course.subscribed ? 'Unsubscribe' : 'Subscribe'),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: GestureDetector(
                      onTap: () {
                        widget.parentCourseProvider
                            .setSelectedCourse(widget.course);
                        widget.parentCourseProvider.resetMeter();
                        widget.parentCourseController.getSubjects();
                        widget.parentCourseController.getStats();
                        context.goNamed('course');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "View",
                            style: TextStyle(
                                color: widget.parentThemeProvider.white,
                                fontWeight: FontWeight.w300,
                                fontSize: 14,
                                height: 1),
                          ),
                          Icon(Icons.chevron_right,
                              color: widget.parentThemeProvider.white),
                        ],
                      ),
                    ),
                    padding: EdgeInsets.only(bottom: 24),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      widget.course.name,
                      style: TextStyle(
                          color: widget.parentThemeProvider.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 40,
                          height: 1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
