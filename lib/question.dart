// ignore_for_file: sort_child_properties_last

import 'dart:math';

import 'package:appdevproj/controllers/chapterController.dart';
import 'package:appdevproj/controllers/questionController.dart';
import 'package:appdevproj/models/questionModel.dart';
import 'package:appdevproj/providers/chapterProvider.dart';
import 'package:appdevproj/providers/courseProvider.dart';
import 'package:appdevproj/providers/questionProvider.dart';
import 'package:appdevproj/providers/subjectProvider.dart';
import 'package:appdevproj/providers/themeProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scroll_shadow/flutter_scroll_shadow.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class QuestionScreen extends ConsumerStatefulWidget {
  const QuestionScreen({Key? key}) : super(key: key);

  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends ConsumerState<QuestionScreen> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = ref.watch(ThemeProvider);
    final questionProvider = ref.watch(QuestionProvider);
    final chapterProvider = ref.watch(ChapterProvider);
    final questionController = ref.read(QuestionController);
    final chapterController = ref.read(ChapterController);
    final subjectProvider = ref.read(SubjectProvider);
    final courseProvider = ref.read(CourseProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: themeProvider.fawn,
      body: WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: questionProvider.iswhat == isWhat.question
            ? Center(
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
                            onTap: () => {
                              questionProvider.resetSelectedAnswer(),
                              context.goNamed('chapter')
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
                                "${courseProvider.selectedCourse.name} / ${subjectProvider.selectedSubject.name}",
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
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.topRight,
                            margin: EdgeInsets.only(bottom: 8),
                            child: Text(
                              '${questionProvider.index} of ${chapterProvider.attemptedQuestions.length + chapterProvider.notAttemptedQuestions.length}',
                              style: TextStyle(
                                color: themeProvider.black,
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                height: 1,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(bottom: 32),
                            child: Text(
                              questionProvider
                                  .selectedQuestion.question.content,
                              style: TextStyle(
                                fontSize: 20,
                                height: 1.2,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topCenter,
                            constraints: BoxConstraints(
                              maxHeight:
                                  0.45 * MediaQuery.of(context).size.height,
                            ),
                            child: ScrollShadow(
                              color: Color.fromARGB(95, 155, 155, 155),
                              child: ListView.builder(
                                padding: EdgeInsets.all(0),
                                scrollDirection: Axis.vertical,
                                itemCount: questionProvider
                                    .selectedQuestion.question.answers.length,
                                itemBuilder: (context, index) {
                                  return AnswerCard(
                                    index: index,
                                    question: questionProvider
                                        .selectedQuestion.question,
                                    parentThemeProvider: themeProvider,
                                    maxLength: questionProvider.selectedQuestion
                                        .question.answers.length,
                                    parentQuestionProvider: questionProvider,
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: MediaQuery.of(context).size.height - 72,
                        child: ElevatedButton(
                          onPressed: () async {
                            questionController.attemptQuestion();
                            await chapterController.getQuestions();
                            questionProvider.setIsWhat(isWhat.answer);
                            final temp = questionProvider.selectedQuestion;
                            temp.answer =
                                questionProvider.selectedAnswer ?? temp.answer;
                            questionProvider.setSelectedQuestion(temp);
                            questionProvider.resetSelectedAnswer();
                          },
                          style: ElevatedButton.styleFrom(
                            shadowColor: Colors.transparent,
                            primary: questionProvider.selectedAnswer != null
                                ? themeProvider.black
                                : themeProvider.neutral,
                            onPrimary: themeProvider.black,
                            foregroundColor: themeProvider.fawn,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 14, horizontal: 32),
                            textStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                height: 1,
                                color: themeProvider.fawn),
                          ),
                          child: Text('Submit'),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : questionProvider.iswhat == isWhat.answer
                ? Container(
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
                              onTap: () => {context.goNamed('chapter')},
                              child: Icon(
                                Icons.chevron_left,
                                color: themeProvider.black,
                                size: 24,
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                  "${courseProvider.selectedCourse.name} / ${subjectProvider.selectedSubject.name}",
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
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              alignment: Alignment.topRight,
                              margin: EdgeInsets.only(bottom: 8),
                              child: Text(
                                '${questionProvider.index} of ${chapterProvider.attemptedQuestions.length + chapterProvider.notAttemptedQuestions.length}',
                                style: TextStyle(
                                  color: themeProvider.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  height: 1,
                                ),
                              ),
                            ),
                            Container(
                              width: 140,
                              height: 140,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: questionProvider.selectedQuestion
                                              .question.correct ==
                                          questionProvider
                                              .selectedQuestion.answer
                                      ? AssetImage(
                                          'assets/icons/right-light.png')
                                      : AssetImage(
                                          'assets/icons/wrong-light.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.topCenter,
                              padding: EdgeInsets.only(bottom: 32),
                              child: Text(
                                questionProvider
                                    .selectedQuestion.question.content,
                                style: TextStyle(
                                  fontSize: 20,
                                  height: 1.2,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.topCenter,
                              padding: EdgeInsets.only(bottom: 32),
                              child: Text(
                                questionProvider
                                    .selectedQuestion.question.explanation,
                                style: TextStyle(
                                  fontSize: 16,
                                  height: 1.2,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: MediaQuery.of(context).size.height - 72,
                          child: ElevatedButton(
                              onPressed: () async {
                                if (questionProvider.index !=
                                    chapterProvider.attemptedQuestions.length +
                                        chapterProvider
                                            .notAttemptedQuestions.length) {
                                  int quesLen = chapterProvider
                                      .notAttemptedQuestions.length;
                                  int randomIndex = Random().nextInt(quesLen);
                                  DisplayedQuestionModel ranQues =
                                      chapterProvider
                                          .notAttemptedQuestions[randomIndex];
                                  questionProvider.setSelectedQuestion(
                                    DisplayedQuestionModel(
                                        answer: ranQues.answer,
                                        question: QuestionModel(
                                            id: ranQues.question.id,
                                            answers: ranQues.question.answers,
                                            chapter: ranQues.question.chapter,
                                            content: ranQues.question.content,
                                            correct: ranQues.question.correct,
                                            explanation:
                                                ranQues.question.explanation)),
                                  );
                                  questionProvider
                                      .setIndex(questionProvider.index + 1);
                                  questionProvider.setIsWhat(isWhat.question);
                                } else {
                                  context.goNamed('chapter');
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                shadowColor: Colors.transparent,
                                primary: themeProvider.black,
                                onPrimary: themeProvider.black,
                                foregroundColor: themeProvider.fawn,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: 14, horizontal: 32),
                                textStyle: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    height: 1,
                                    color: themeProvider.fawn),
                              ),
                              child: Text(questionProvider.index ==
                                      chapterProvider
                                              .attemptedQuestions.length +
                                          chapterProvider
                                              .notAttemptedQuestions.length
                                  ? 'Finish'
                                  : 'Continue')),
                        ),
                      ],
                    ),
                  )
                : Container(
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
                              onTap: () => {context.goNamed('chapter')},
                              child: Icon(
                                Icons.chevron_left,
                                color: themeProvider.black,
                                size: 24,
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                  "${courseProvider.selectedCourse.name} / ${subjectProvider.selectedSubject.name}",
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
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              alignment: Alignment.topRight,
                              margin: EdgeInsets.only(bottom: 8),
                              child: Text(
                                '${questionProvider.index} of ${chapterProvider.attemptedQuestions.length + chapterProvider.notAttemptedQuestions.length}',
                                style: TextStyle(
                                  color: themeProvider.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  height: 1,
                                ),
                              ),
                            ),
                            Container(
                              width: 140,
                              height: 140,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: questionProvider.selectedQuestion
                                              .question.correct ==
                                          questionProvider
                                              .selectedQuestion.answer
                                      ? AssetImage(
                                          'assets/icons/right-light.png')
                                      : AssetImage(
                                          'assets/icons/wrong-light.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.topCenter,
                              padding: EdgeInsets.only(bottom: 32),
                              child: Text(
                                questionProvider
                                    .selectedQuestion.question.content,
                                style: TextStyle(
                                  fontSize: 20,
                                  height: 1.2,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.topCenter,
                              padding: EdgeInsets.only(bottom: 32),
                              child: Text(
                                questionProvider
                                    .selectedQuestion.question.explanation,
                                style: TextStyle(
                                  fontSize: 16,
                                  height: 1.2,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: MediaQuery.of(context).size.height - 72,
                          child: ElevatedButton(
                              onPressed: () async {
                                if (questionProvider.index <
                                    chapterProvider.attemptedQuestions.length) {
                                  DisplayedQuestionModel ranQues =
                                      chapterProvider.attemptedQuestions[
                                          questionProvider.index];
                                  questionProvider.setSelectedQuestion(
                                    DisplayedQuestionModel(
                                        answer: ranQues.answer,
                                        question: QuestionModel(
                                            id: ranQues.question.id,
                                            answers: ranQues.question.answers,
                                            chapter: ranQues.question.chapter,
                                            content: ranQues.question.content,
                                            correct: ranQues.question.correct,
                                            explanation:
                                                ranQues.question.explanation)),
                                  );
                                  questionProvider
                                      .setIndex(questionProvider.index + 1);
                                } else {
                                  int quesLen = chapterProvider
                                      .notAttemptedQuestions.length;
                                  int randomIndex = Random().nextInt(quesLen);
                                  DisplayedQuestionModel ranQues =
                                      chapterProvider
                                          .notAttemptedQuestions[randomIndex];
                                  questionProvider.setSelectedQuestion(
                                      DisplayedQuestionModel(
                                    answer: ranQues.answer,
                                    question: QuestionModel(
                                        id: ranQues.question.id,
                                        answers: ranQues.question.answers,
                                        chapter: ranQues.question.chapter,
                                        content: ranQues.question.content,
                                        correct: ranQues.question.correct,
                                        explanation:
                                            ranQues.question.explanation),
                                  ));
                                  questionProvider.setIsWhat(isWhat.question);
                                  questionProvider
                                      .setIndex(questionProvider.index + 1);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                shadowColor: Colors.transparent,
                                primary: themeProvider.black,
                                onPrimary: themeProvider.black,
                                foregroundColor: themeProvider.fawn,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: 14, horizontal: 32),
                                textStyle: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    height: 1,
                                    color: themeProvider.fawn),
                              ),
                              child: Text(questionProvider.index ==
                                      chapterProvider
                                              .attemptedQuestions.length +
                                          chapterProvider
                                              .notAttemptedQuestions.length
                                  ? 'Finish'
                                  : 'Continue')),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}

class AnswerCard extends ConsumerStatefulWidget {
  final int index;
  final int maxLength;
  final QuestionModel question;
  final themeProvider parentThemeProvider;
  final questionProvider parentQuestionProvider;

  const AnswerCard(
      {Key? key,
      required this.index,
      required this.maxLength,
      required this.question,
      required this.parentQuestionProvider,
      required this.parentThemeProvider})
      : super(key: key);

  @override
  _AnswerCardState createState() => _AnswerCardState();
}

class _AnswerCardState extends ConsumerState<AnswerCard> {
  @override
  Widget build(BuildContext context) {
    String label = String.fromCharCode('a'.codeUnitAt(0) + widget.index);
    String answerText = widget.question.answers[label] ?? '';

    return GestureDetector(
      onTap: () {
        widget.parentQuestionProvider.setSelectedAnswer(label);
      },
      child: Container(
        width: 0.8 * MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(
            bottom: widget.index == widget.maxLength - 1 ? 0 : 16),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black),
          // color: Colors.transparent,
          color: widget.parentQuestionProvider.selectedAnswer == label
              ? widget.parentThemeProvider.yellow.withOpacity(0.25)
              : Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 20,
              margin: EdgeInsets.only(right: 16),
              child: Text(
                label.toUpperCase(),
                style: TextStyle(
                    height: 1,
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: widget.parentThemeProvider.peach),
              ),
            ),
            Expanded(
              child: Text(
                answerText,
                style: TextStyle(
                    height: 1.143,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: widget.parentThemeProvider.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
