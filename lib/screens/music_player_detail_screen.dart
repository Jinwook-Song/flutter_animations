import 'package:flutter/material.dart';

class MusicPlayerDetailScreen extends StatefulWidget {
  final int index;
  const MusicPlayerDetailScreen({super.key, required this.index});

  @override
  State<MusicPlayerDetailScreen> createState() =>
      _MusicPlayerDetailScreenState();
}

class _MusicPlayerDetailScreenState extends State<MusicPlayerDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yeonjae'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 30),
          Align(
            alignment: Alignment.center,
            child: Hero(
              tag: '${widget.index}',
              child: Container(
                width: 350,
                height: 350,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 10,
                        spreadRadius: 2,
                        offset: const Offset(0, 8))
                  ],
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(
                      'assets/images/covers/yeonjae0${widget.index}.jpeg',
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 50),
          CustomPaint(
            size: Size(size.width - 80, 5),
            painter: ProgressBar(progressValue: size.width / 2),
          )
        ],
      ),
    );
  }
}

class ProgressBar extends CustomPainter {
  final double progressValue;

  ProgressBar({required this.progressValue});
  @override
  void paint(Canvas canvas, Size size) {
    // track
    final trackPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.fill;

    final RRect trackRect = RRect.fromLTRBR(
      0,
      0,
      size.width,
      size.height,
      const Radius.circular(10),
    );

    canvas.drawRRect(trackRect, trackPaint);

    // progress
    final progresskPaint = Paint()
      ..color = Colors.grey.shade500
      ..style = PaintingStyle.fill;

    final RRect progresskRect = RRect.fromLTRBR(
      0,
      0,
      progressValue,
      size.height,
      const Radius.circular(10),
    );

    canvas.drawRRect(progresskRect, progresskPaint);

    // thumb
    canvas.drawCircle(
      Offset(progressValue, size.height / 2),
      10,
      progresskPaint,
    );
  }

  @override
  bool shouldRepaint(covariant ProgressBar oldDelegate) {
    return false;
  }
}
