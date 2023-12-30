// ignore_for_file: sort_child_properties_last
import 'dart:math';

import 'package:appdevproj/controllers/chapterController.dart';
import 'package:appdevproj/controllers/subjectController.dart';
import 'package:appdevproj/models/questionModel.dart';
import 'package:appdevproj/providers/questionProvider.dart';
import 'package:appdevproj/providers/themeProvider.dart';
import 'package:flutter/material.dart';
import 'package:appdevproj/components/meter.dart';
import 'package:flutter_scroll_shadow/flutter_scroll_shadow.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appdevproj/providers/chapterProvider.dart';
import 'package:appdevproj/providers/courseProvider.dart';
import 'package:appdevproj/providers/subjectProvider.dart';
import 'package:go_router/go_router.dart';

class ChapterScreen extends ConsumerStatefulWidget {
  const ChapterScreen({Key? key}) : super(key: key);

  @override
  _ChapterScreenState createState() => _ChapterScreenState();
}

class _ChapterScreenState extends ConsumerState<ChapterScreen> {
  ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = ref.watch(ThemeProvider);
    final chapterProvider = ref.watch(ChapterProvider);
    final subjectController = ref.watch(SubjectController);
    final subjectProvider = ref.watch(SubjectProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: themeProvider.fawn,
      body: WillPopScope(
        onWillPop: () async {
          chapterProvider.setAttemptedQuestionsList([]);
          chapterProvider.setNotattemptedQuestionsList([]);
          chapterProvider.setQuestionsList([]);
          subjectProvider.resetMeter();
          subjectController.getStats();
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
                        chapterProvider.setAttemptedQuestionsList([]),
                        chapterProvider.setNotattemptedQuestionsList([]),
                        chapterProvider.setQuestionsList([]),
                        subjectProvider.resetMeter(),
                        subjectController.getStats(),
                        context.goNamed('subject')
                      },
                      child: Icon(
                        Icons.chevron_left,
                        color: themeProvider.black,
                        size: 24,
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          "${ref.watch(CourseProvider).selectedCourse.name} / ${ref.watch(SubjectProvider).selectedSubject.name}",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            height: 1,
                          ),
                        ),
                        Text(
                          "${chapterProvider.selectedChapter.name}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            height: 1,
                          ),
                        ),
                      ],
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
                        score: chapterProvider.meterCompleteness,
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
                        score: chapterProvider.meterAccuracy,
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
                          'Questions',
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
                        child: FutureBuilder<List<DisplayedQuestionModel>>(
                          future: chapterProvider.questions,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              List<DisplayedQuestionModel> _questions =
                                  snapshot.data ?? [];
                              return ScrollShadow(
                                color: Color.fromARGB(95, 155, 155, 155),
                                child: GridView.builder(
                                  key: PageStorageKey<String>('questionList'),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                    childAspectRatio: 1.0,
                                  ),
                                  padding: EdgeInsets.all(0),
                                  itemCount: _questions.length,
                                  controller: scrollController,
                                  itemBuilder: (context, index) {
                                    return QuestionCard(
                                      key: ValueKey(_questions[index]),
                                      index: index,
                                      question: _questions[index],
                                      parentThemeProvider: themeProvider,
                                      div: chapterProvider
                                          .attemptedQuestions.length,
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

class QuestionCard extends ConsumerStatefulWidget {
  final int index;
  final DisplayedQuestionModel question;
  final int div;
  final themeProvider parentThemeProvider;
  final chapterProvider parentChapterProvider;

  const QuestionCard(
      {Key? key,
      required this.index,
      required this.question,
      required this.div,
      required this.parentChapterProvider,
      required this.parentThemeProvider})
      : super(key: key);

  @override
  _QuestionCardState createState() => _QuestionCardState();
}

class _QuestionCardState extends ConsumerState<QuestionCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ref.watch(QuestionProvider).setIndex(widget.index + 1);
        if (widget.index == widget.div) {
          int quesLen =
              widget.parentChapterProvider.notAttemptedQuestions.length;
          int randomIndex = Random().nextInt(quesLen);
          DisplayedQuestionModel ranQues =
              widget.parentChapterProvider.notAttemptedQuestions[randomIndex];
          ref.watch(QuestionProvider).setSelectedQuestion(
                DisplayedQuestionModel(
                  answer: ranQues.answer,
                  question: QuestionModel(
                      id: ranQues.question.id,
                      answers: ranQues.question.answers,
                      chapter: ranQues.question.chapter,
                      content: ranQues.question.content,
                      correct: ranQues.question.correct,
                      explanation: ranQues.question.explanation),
                ),
              );
          ref.watch(QuestionProvider).setIsWhat(isWhat.question);
          context.goNamed('question');
        } else if (widget.index < widget.div) {
          DisplayedQuestionModel ranQues =
              widget.parentChapterProvider.attemptedQuestions[widget.index];
          ref.watch(QuestionProvider).setSelectedQuestion(
                DisplayedQuestionModel(
                  answer: ranQues.answer,
                  question: QuestionModel(
                      id: ranQues.question.id,
                      answers: ranQues.question.answers,
                      chapter: ranQues.question.chapter,
                      content: ranQues.question.content,
                      correct: ranQues.question.correct,
                      explanation: ranQues.question.explanation),
                ),
              );
          ref.watch(QuestionProvider).setIsWhat(isWhat.review);
          context.goNamed('question');
        }
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: widget.parentThemeProvider.white,
          border: Border.all(
            color: widget.question.answer != "none" &&
                    widget.question.answer != widget.question.question.correct
                ? widget.parentThemeProvider.err
                : Colors.transparent,
            width: 1.0, // You can adjust the border width
          ),
        ),
        child: Text(
          (widget.index + 1).toString(),
          style: TextStyle(
              height: 1,
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: widget.index < widget.div
                  ? widget.parentThemeProvider.yellow
                  : widget.index > widget.div
                      ? widget.parentThemeProvider.blue
                      : widget.parentThemeProvider.peach),
        ),
      ),
    );
  }
}
