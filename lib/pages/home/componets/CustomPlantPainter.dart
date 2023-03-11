import 'dart:math';
import 'package:flutter/material.dart';

class TemperatureCircle extends StatefulWidget {
  final double temperature;

  const TemperatureCircle({Key? key, required this.temperature})
      : super(key: key);

  @override
  _TemperatureCircleState createState() => _TemperatureCircleState();
}

class _TemperatureCircleState extends State<TemperatureCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    _animation =
        Tween<double>(begin: 0, end: widget.temperature).animate(_controller)
          ..addListener(() {
            setState(() {});
          });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _TemperaturePainter(_animation.value),
      child: Center(
        child: Text(
          '${_animation.value.toInt()}°',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _TemperaturePainter extends CustomPainter {
  final double temperature;

  _TemperaturePainter(this.temperature);

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = min(centerX, centerY);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..color = _getTemperatureColor();

    canvas.drawArc(
      Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
      -pi / 2,
      2 * pi * (temperature / 100),
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_TemperaturePainter oldDelegate) {
    return oldDelegate.temperature != temperature;
  }

  Color _getTemperatureColor() {
    if (temperature <= 25) {
      return Colors.blue;
    } else if (temperature <= 50) {
      return Colors.green;
    } else if (temperature <= 75) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}
