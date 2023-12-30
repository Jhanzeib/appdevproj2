// ignore_for_file: sort_child_properties_last
import 'package:appdevproj/controllers/chapterController.dart';
import 'package:appdevproj/controllers/courseController.dart';
import 'package:appdevproj/models/chapterModel.dart';
import 'package:appdevproj/providers/chapterProvider.dart';
import 'package:appdevproj/providers/subjectProvider.dart';
import 'package:appdevproj/providers/themeProvider.dart';
import 'package:flutter/material.dart';
import 'package:appdevproj/components/meter.dart';
import 'package:flutter_scroll_shadow/flutter_scroll_shadow.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appdevproj/providers/courseProvider.dart';
import 'package:go_router/go_router.dart';

class SubjectScreen extends ConsumerStatefulWidget {
  const SubjectScreen({Key? key}) : super(key: key);

  @override
  _SubjectScreenState createState() => _SubjectScreenState();
}

class _SubjectScreenState extends ConsumerState<SubjectScreen> {
  ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = ref.watch(ThemeProvider);
    final subjectProvider = ref.watch(SubjectProvider);
    final chapterController = ref.watch(ChapterController);
    final chapterProvider = ref.watch(ChapterProvider);
    final courseController = ref.watch(CourseController);
    final courseProvider = ref.watch(CourseProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: themeProvider.fawn,
      body: WillPopScope(
        onWillPop: () async {
          courseProvider.resetMeter();
          courseController.getStats();
          return true;
        },
        child: Center(
          child: Container(
            margin: EdgeInsets.symmetric(
                vertical: 0.1 * MediaQuery.of(context).size.height,
                horizontal: 36),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            // color: themeProvider.blue,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => {
                        courseProvider.resetMeter(),
                        courseController.getStats(),
                        context.goNamed('course')
                      },
                      child: Icon(
                        Icons.chevron_left,
                        color: themeProvider.black,
                        size: 24,
                      ),
                    ),
                    Text(
                      "${ref.watch(CourseProvider).selectedCourse.name} / ${subjectProvider.selectedSubject.name}",
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
                        score: subjectProvider.meterCompleteness,
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
                        score: subjectProvider.meterAccuracy,
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
                          'Chapters',
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
                          maxHeight: 0.44 * MediaQuery.of(context).size.height,
                        ),
                        child: FutureBuilder<List<ChapterModel>>(
                          future: subjectProvider.chapters,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              List<ChapterModel> _chapters =
                                  snapshot.data ?? [];
                              return ScrollShadow(
                                color: Color.fromARGB(95, 155, 155, 155),
                                child: ListView.builder(
                                  key: PageStorageKey<String>('chapterList'),
                                  scrollDirection: Axis.vertical,
                                  padding: EdgeInsets.all(0),
                                  itemCount: _chapters.length,
                                  controller: scrollController,
                                  itemBuilder: (context, index) {
                                    return ChapterCard(
                                      key: ValueKey(_chapters[index]),
                                      index: index,
                                      chapter: _chapters[index],
                                      maxLength: _chapters.length,
                                      parentThemeProvider: themeProvider,
                                      parentChapterController:
                                          chapterController,
                                      parentChapterProvider: chapterProvider,
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

class ChapterCard extends ConsumerStatefulWidget {
  final int index;
  final ChapterModel chapter;
  final int maxLength;
  final themeProvider parentThemeProvider;
  final chapterProvider parentChapterProvider;
  final chapterController parentChapterController;

  const ChapterCard(
      {Key? key,
      required this.index,
      required this.chapter,
      required this.parentThemeProvider,
      required this.parentChapterProvider,
      required this.parentChapterController,
      required this.maxLength})
      : super(key: key);

  @override
  _ChapterCardState createState() => _ChapterCardState();
}

class _ChapterCardState extends ConsumerState<ChapterCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.parentChapterProvider.setSelectedChapter(widget.chapter);
        widget.parentChapterProvider.setAttemptedQuestionsList([]);
        widget.parentChapterProvider.setNotattemptedQuestionsList([]);
        widget.parentChapterProvider.setQuestionsList([]);
        widget.parentChapterProvider.resetMeter();
        widget.parentChapterController.getQuestions();

        context.goNamed('chapter');
      },
      child: Container(
        alignment: Alignment.centerLeft,
        width: 0.8 * MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(
            bottom: widget.index == widget.maxLength - 1 ? 0 : 16),
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: widget.parentThemeProvider.white,
        ),
        child: Text(
          widget.chapter.name,
          style: TextStyle(
            height: 1,
            fontSize: 23,
            fontWeight: FontWeight.w400,
            color: widget.parentThemeProvider.black,
          ),
        ),
      ),
    );
  }
}
