import 'package:flutter/material.dart';

class MusicPlayerDetailScreen extends StatefulWidget {
  final int index;
  const MusicPlayerDetailScreen({super.key, required this.index});

  @override
  State<MusicPlayerDetailScreen> createState() =>
      _MusicPlayerDetailScreenState();
}

class _MusicPlayerDetailScreenState extends State<MusicPlayerDetailScreen>
    with TickerProviderStateMixin {
  final _defaultPlayDuration = 60;
  late final AnimationController _progressController = AnimationController(
    vsync: this,
    duration: Duration(seconds: _defaultPlayDuration),
  )..repeat(reverse: true);

  late final AnimationController _marqueeController = AnimationController(
    vsync: this,
    duration: const Duration(
      seconds: 10,
    ),
  )..repeat(reverse: true);

  late final Animation<Offset> _marqueeTween = Tween<Offset>(
    begin: const Offset(0.1, 0),
    end: const Offset(-1.6, 0),
  ).animate(_marqueeController);

  late final AnimationController _playPauseController = AnimationController(
    vsync: this,
    duration: const Duration(
      milliseconds: 500,
    ),
  );

  late final AnimationController _menuController = AnimationController(
    vsync: this,
    duration: const Duration(
      seconds: 1,
    ),
  );

  final Curve _menuCurve = Curves.easeInOutCubic;

  late final Animation<double> _screenScale = Tween(
    begin: 1.0,
    end: 0.7,
  ).animate(
    CurvedAnimation(
      parent: _menuController,
      curve: Interval(
        0,
        0.5,
        curve: _menuCurve,
      ),
    ),
  );

  late final Animation<Offset> _screenOffeset = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(20 / 70, 0),
  ).animate(
    CurvedAnimation(
      parent: _menuController,
      curve: Interval(
        0.5,
        1,
        curve: _menuCurve,
      ),
    ),
  );

  List<String> _timeFormatter({required int seconds}) {
    final duration = Duration(seconds: seconds);
    final min = duration.toString().split('.').first.substring(2, 4);
    final sec = duration.toString().split('.').first.substring(5);

    final remainingDuration = Duration(seconds: _defaultPlayDuration - seconds);
    final remainingMin =
        remainingDuration.toString().split('.').first.substring(2, 4);
    final remainingSec =
        remainingDuration.toString().split('.').first.substring(5);

    return ['$min:$sec', '$remainingMin:$remainingSec'];
  }

  void _togglePlay() {
    if (_playPauseController.isCompleted) {
      _playPauseController.reverse();
    } else {
      _playPauseController.forward();
    }
  }

  bool _dragging = false;
  void _toggleDragging(dynamic _) {
    setState(() {
      _dragging = !_dragging;
    });
  }

  final ValueNotifier<double> _volume = ValueNotifier(0);
  late final size = MediaQuery.of(context).size;

  void _onVolumeDragUpdate(DragUpdateDetails details) {
    _volume.value += details.delta.dx;
    _volume.value = _volume.value.clamp(0, size.width - 80);
  }

  void _openMenu() {
    _menuController.forward();
  }

  void _closeMenu() {
    _menuController.reverse();
  }

  @override
  void dispose() {
    _progressController.dispose();
    _marqueeController.dispose();
    _playPauseController.dispose();
    _menuController.dispose();
    super.dispose();
  }

  final List<Map<String, dynamic>> _menus = [
    {
      'icon': Icons.person,
      'text': 'Profile',
    },
    {
      'icon': Icons.notifications,
      'text': 'Notifications',
    },
    {
      'icon': Icons.settings,
      'text': 'Settings',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            leading: IconButton(
              onPressed: _closeMenu,
              icon: const Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                const SizedBox(height: 30),
                for (var menu in _menus) ...[
                  Row(
                    children: [
                      Icon(
                        menu['icon'],
                        color: Colors.grey.shade200,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        menu['text'],
                        style: TextStyle(
                          color: Colors.grey.shade200,
                          fontSize: 18,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
                const Spacer(),
                const Row(
                  children: [
                    Icon(
                      Icons.logout,
                      color: Colors.red,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Log out',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 100,
                )
              ],
            ),
          ),
        ),
        SlideTransition(
          position: _screenOffeset,
          child: ScaleTransition(
            scale: _screenScale,
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Yeonjae'),
                actions: [
                  IconButton(
                    onPressed: _openMenu,
                    icon: const Icon(Icons.menu),
                  ),
                ],
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
                  AnimatedBuilder(
                    animation: _progressController,
                    builder: (context, child) {
                      return CustomPaint(
                        size: Size(size.width - 80, 5),
                        painter: ProgressBar(
                          progressValue: _progressController.value,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                    ),
                    child: DefaultTextStyle(
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      child: AnimatedBuilder(
                        animation: _progressController,
                        builder: (context, child) {
                          final progress =
                              _progressController.value * _defaultPlayDuration;
                          final time =
                              _timeFormatter(seconds: progress.round());

                          return Row(
                            children: [
                              Text(time[0]),
                              const Spacer(),
                              Text(time[1]),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Yeonjae',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  SlideTransition(
                    position: _marqueeTween,
                    child: const Text(
                      'Many of life’s failures are people who did not realize how close they were to success when they gave up.– Thomas A. Edison',
                      style: TextStyle(fontSize: 18),
                      maxLines: 1,
                      overflow: TextOverflow.visible,
                      softWrap: false,
                    ),
                  ),
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap: _togglePlay,
                    child: AnimatedIcon(
                      icon: AnimatedIcons.play_pause,
                      progress: _playPauseController,
                      size: 60,
                    ),
                  ),
                  const SizedBox(height: 30),
                  GestureDetector(
                    onHorizontalDragUpdate: _onVolumeDragUpdate,
                    onHorizontalDragStart: _toggleDragging,
                    onHorizontalDragEnd: _toggleDragging,
                    child: AnimatedScale(
                      scale: _dragging ? 1.05 : 1,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.bounceOut,
                      child: Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ValueListenableBuilder(
                          valueListenable: _volume,
                          builder: (context, value, child) {
                            return CustomPaint(
                              size: Size(size.width - 80, 50),
                              painter: VolumePaint(volume: value),
                            );
                          },
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ProgressBar extends CustomPainter {
  final double progressValue;

  ProgressBar({required this.progressValue});
  @override
  void paint(Canvas canvas, Size size) {
    final progress = size.width * progressValue;
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
      progress,
      size.height,
      const Radius.circular(10),
    );

    canvas.drawRRect(progresskRect, progresskPaint);

    // thumb
    canvas.drawCircle(
      Offset(progress, size.height / 2),
      10,
      progresskPaint,
    );
  }

  @override
  bool shouldRepaint(covariant ProgressBar oldDelegate) {
    return oldDelegate.progressValue != progressValue;
  }
}

class VolumePaint extends CustomPainter {
  final double volume;

  VolumePaint({required this.volume});

  @override
  void paint(Canvas canvas, Size size) {
    // bg
    final bgPaint = Paint()..color = Colors.grey.shade300;
    final bgRect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(bgRect, bgPaint);

    // volume
    final volumePaint = Paint()..color = Colors.grey.shade500;
    final volumeRect = Rect.fromLTWH(0, 0, volume, size.height);
    canvas.drawRect(volumeRect, volumePaint);
  }

  @override
  bool shouldRepaint(covariant VolumePaint oldDelegate) {
    return oldDelegate.volume != volume;
  }
}
