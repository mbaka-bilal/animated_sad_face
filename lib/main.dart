import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SadFace(),
    );
  }
}

class SadFace extends StatefulWidget {
  const SadFace({Key? key}) : super(key: key);

  @override
  State<SadFace> createState() => _SadFaceState();
}

class _SadFaceState extends State<SadFace> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    //Begin animation for blinking eyes.
    _animationController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 2),
        reverseDuration: const Duration(seconds: 2));
    _animation = Tween<double>(begin: 3.0, end: 30.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          //If completed restart the animation
          _animationController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          //If not not completed start the animation
          _animationController.forward();
        }
        setState(() {});
      });
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Stack(
            children: [
              Container(
                width: 200,
                height: 200,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black45,
                          spreadRadius: 10,
                          blurRadius: 5,
                          blurStyle: BlurStyle.solid,
                          offset: Offset(0, -40))
                    ]),
              ),
              Positioned.fill(
                child: Align(
                  // widthFactor: 0,
                  // heightFactor: 0,
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ClipOval(
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 500),
                                width: 30,
                                height: _animation.value,
                                decoration:
                                const BoxDecoration(color: Colors.white),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            ClipOval(
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 500),
                                width: 30,
                                height: _animation.value,
                                decoration:
                                const BoxDecoration(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                left: 50,
                right: 50,
                top: 130,
                child: CustomPaint(
                  painter: SadMouthPainter(),
                  child: Container(),
                ),
              )
            ],
          ),
        ));
  }
}

class SadMouthPainter extends CustomPainter {
  //Paint a sad mouth.
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    /*
      1. The rect is what the full oval would be inscribed within.
      2. The startAngle is the location on the oval that the line starts
      drawing from. An angle of 0 is at the right side. Angles are in
      radians, not degrees. The top is at 3π/2 (or -π/2), the left at π,
      and the bottom at π/2.
      3. The sweepAngle is how much of the oval is included in the arc.
      Again, angles are in radians. A value of 2π would draw the entire oval.
      4. If you set useCenter to true, then there will be a straight line
      from both sides of the arc to the center.

      source:
      https://stackoverflow.com/questions/50376727/flutter-drawarc-method-draws-full-circle-not-just-arc

    */

    canvas.drawArc(const Rect.fromLTRB(0, 0, 100, 100), math.pi + 0.4,
        math.pi - 0.8, false, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
