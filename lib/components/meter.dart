import 'package:flutter/material.dart';
import 'package:appdevproj/providers/themeProvider.dart';
import 'dart:math' as math;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Meter extends ConsumerStatefulWidget {
  final int score;
  final String label;
  final Color fillColor;

  const Meter({
    Key? key,
    required this.score,
    required this.label,
    required this.fillColor,
  }) : super(key: key);
  @override
  _MeterState createState() => _MeterState();
}

class _MeterState extends ConsumerState<Meter> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = ref.watch(ThemeProvider);

    return CustomPaint(
      painter: MeterPainter(
        score: widget.score,
        fillColor: widget.fillColor,
      ),
      child: Container(
        width: 128,
        height: 128,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 4),
                constraints: BoxConstraints(
                  maxHeight: 24,
                ),
                child: Text(
                  widget.score > 0 ? '${widget.score}%\n' : "--",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      height: 1,
                      color: themeProvider.black),
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 4),
                constraints: BoxConstraints(
                  maxHeight: 24,
                ),
                child: Text(
                  '${widget.label}',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      height: 1,
                      color: themeProvider.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MeterPainter extends CustomPainter {
  final int score;
  final Color fillColor;

  final double _opacity = 0.2;
  final double _completeness = 1.5;

  MeterPainter({
    required this.score,
    required this.fillColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = fillColor.withOpacity(_opacity)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 13;

    double progressRadians = (_completeness * math.pi * score) / 100;

    canvas.drawArc(
      Rect.fromCenter(
        center: size.center(Offset.zero),
        width: size.width,
        height: size.height,
      ),
      math.pi - (math.pi / 4),
      math.pi * _completeness,
      false,
      paint,
    );

    paint.color = fillColor;
    canvas.drawArc(
      Rect.fromCenter(
        center: size.center(Offset.zero),
        width: size.width,
        height: size.height,
      ),
      math.pi - (math.pi / 4),
      progressRadians,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
