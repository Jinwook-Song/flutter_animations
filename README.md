# Flutter animations

| 프로젝트 기간 | 23.05.17                                           |
| ------------- | -------------------------------------------------- |
| 프로젝트 목적 | flutter로 다양한 애니메이션 구현                   |
| Github        | https://github.com/Jinwook-Song/flutter_animations |

[Animation Decision Tree](https://docs.flutter.dev/ui/animations)

![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/35e564f0-838c-4cdd-8347-ec6a30181ecf/Untitled.png)

---

- Implicit Animations
  애니메이션에 대해서 코드를 작성할 필요가 없다. 플러터가 알아서 다 해준다.
  `Animated`로 시작하는 위젯이 이에 해당된다. ([dcos](https://docs.flutter.dev/ui/widgets/animation))
  - AnimatedContainer: 어떤것이든 transition 효과를 준다
  ```dart
  AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: size.width * 0.4,
                height: size.width * 0.4,
                transform: Matrix4.rotationZ(_visible ? 1 / 2 * pi : 0),
                transformAlignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _visible ? Colors.pink : Colors.amber,
                  borderRadius: BorderRadius.circular(_visible ? 10 : 100),
                ),
              ),
  ```
  - Curves ([docs](https://api.flutter.dev/flutter/animation/Curves-class.html))
  - TweenAnimationBuilder
    나만의 implicit animation 위젯을 만들 수 있다
    내장된 AnimatedWidget이 없는 경우 사용할 수 있다
    tween: from ~ to 사이의 값으로 transition 효과를 줌
    value: currently animated value
    ```dart
    TweenAnimationBuilder(
                  tween: ColorTween(
                    begin: Colors.amber,
                    end: Colors.purple,
                  ),
                  curve: Curves.bounceInOut,
                  duration: const Duration(seconds: 5),
                  builder: (context, value, child) {
                    return Image.network(
                      'https://upload.wikimedia.org/wikipedia/commons/4/4f/Dash%2C_the_mascot_of_the_Dart_programming_language.png',
                      color: value,
                      colorBlendMode: BlendMode.hue,
                    );
                  },
                ),
    ```
- Explicit Animations
  여러 위젯을 animation 하고싶은 경우,
  animation에 더 많은 통제를 하고싶은 경우(loop, pause, reverse, etc…)

  - SingleTickerProviderStateMixin
    Ticker: call its callback once per animation frame
    SingleTickerProviderStateMixin: only tick while the current tree is enabled
    → 빠른 rebuild를 위해 Ticker를 사용하고, enable 상태에서만 활성화하도록

  ```dart
  import 'package:flutter/material.dart';

     class ExplicitAnimationsScreen extends StatefulWidget {
       const ExplicitAnimationsScreen({super.key});

       @override
       State<ExplicitAnimationsScreen> createState() =>
           _ExplicitAnimationsScreenState();
     }

     class _ExplicitAnimationsScreenState extends State<ExplicitAnimationsScreen>
         with SingleTickerProviderStateMixin {
       late final AnimationController _animationController = AnimationController(
         vsync: this,
         duration: const Duration(
           seconds: 10,
         ),
         lowerBound: 50.0,
         upperBound: 100.0,
       )
         // Called when the animation value changes
         // 하지만 전체를 rebuild하기 때문에 매우 부적합하다
         ..addListener(() {
           setState(() {});
         });

       void _play() {
         _animationController.forward();
       }

       void _pause() {
         _animationController.stop();
       }

       void _rewind() {
         _animationController.reverse();
       }

       @override
       void initState() {
         super.initState();
       }

       @override
       Widget build(BuildContext context) {
         return Scaffold(
           appBar: AppBar(
             title: const Text('Explicit Animations'),
           ),
           body: Center(
             child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 Text(
                   _animationController.value.toStringAsFixed(3),
                   style: const TextStyle(fontSize: 40),
                 ),
                 const SizedBox(
                   height: 20,
                 ),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     ElevatedButton(
                       onPressed: _play,
                       child: const Text(
                         'Play',
                       ),
                     ),
                     ElevatedButton(
                       onPressed: _pause,
                       child: const Text(
                         'Pause',
                       ),
                     ),
                     ElevatedButton(
                       onPressed: _rewind,
                       child: const Text(
                         'Rewind',
                       ),
                     ),
                   ],
                 )
               ],
             ),
           ),
         );
       }
     }
  ```

  - AnimatedBuilder
    animation이 바뀌는 부분만 새롭게 render
    ```dart
    AnimatedBuilder(
                       animation: _animationController,
                       builder: (context, child) {
                         return Text(
                           _animationController.value.toStringAsFixed(3),
                           style: const TextStyle(fontSize: 40),
                         );
                       },
                     ),
    ```
  - Explicit Animations

    ```dart
    // Connect Tween and AnimationController
         late final Animation<Decoration> _decorationAnimation = DecorationTween(
           begin: BoxDecoration(
             color: Colors.amber,
             borderRadius: BorderRadius.circular(120),
           ),
           end: BoxDecoration(
             color: Colors.purple,
             borderRadius: BorderRadius.circular(20),
           ),
         ).animate(_animationController);

         late final Animation<double> _rotationAnimation = Tween(
           begin: 0.0,
           end: 1 / 8,
         ).animate(_animationController);

         late final Animation<double> _scaleAnimation = Tween(
           begin: 1.0,
           end: 0.5,
         ).animate(_animationController);

         late final Animation<Offset> _offsetAnimation = Tween(
           begin: Offset.zero,
           end: const Offset(0, -1),
         ).animate(_animationController);

       SlideTransition(
                     position: _offsetAnimation,
                     child: ScaleTransition(
                       scale: _scaleAnimation,
                       child: RotationTransition(
                         turns: _rotationAnimation,
                         child: DecoratedBoxTransition(
                           decoration: _decorationAnimation,
                           child: const SizedBox(
                             width: 200,
                             height: 200,
                           ),
                         ),
                       ),
                     ),
                   ),
    ```

  - Curve
    ```dart
    late final AnimationController _animationController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 2),
        reverseDuration: const Duration(seconds: 1),
      );
      late final CurvedAnimation _curvedAnimation = CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
        reverseCurve: Curves.elasticIn,
      );
    ```
  - ValueNotifier & ValueListenableBuilder
    animation 진행 상황을 render할때, setState를 이용하지 않고,
    ValueNotifier의 값을 변경하고, 이 변화된 값을 렌더해주는 ValueListenableBuilder를 이용하여 최적화 할 수 있다

    ```dart
    late final AnimationController _animationController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 2),
        reverseDuration: const Duration(seconds: 1),
      )..addListener(() {
          _progress.value = _animationController.value;
        });

    final ValueNotifier<double> _progress = ValueNotifier(0.0);

      void _onChanged(double value) {
        _progress.value = value;
        _animationController.value = value;
      }

    ValueListenableBuilder(
                  valueListenable: _progress,
                  builder: (context, value, child) {
                    return Slider(
                      value: value,
                      onChanged: _onChanged,
                    );
                  },
                )
    ```

  - AnimationStatus
    `foward`, `completed`, `reverse`, `dismissed` 에 따라 animation을 컨트롤 할 수 있다

    ```dart
    late final AnimationController _animationController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 2),
        reverseDuration: const Duration(seconds: 1),
      )
        ..addListener(() {
          _progress.value = _animationController.value;
        })
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            _rewind();
          } else if (status == AnimationStatus.dismissed) {
            _play();
          }
        });

    bool _looping = false;

      void _toggleLooping() {
        if (_looping) {
          _animationController.stop();
        } else {
          _animationController.repeat(reverse: true);
        }
        setState(() {
          _looping = !_looping;
        });
      }
    ```

- Apple Watch
  animate custom painter

  ```dart
  import 'dart:math';

  import 'package:flutter/material.dart';

  class AppleWatchScreen extends StatefulWidget {
    const AppleWatchScreen({super.key});

    @override
    State<AppleWatchScreen> createState() => _AppleWatchScreenState();
  }

  class _AppleWatchScreenState extends State<AppleWatchScreen>
      with SingleTickerProviderStateMixin {
    late final AnimationController _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
      lowerBound: 0.001 * pi,
      upperBound: 2.0 * pi,
    );

    void _animateValues() {
      _animationController.repeat();
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            ),
          ),
          title: const Text('Apple Watch'),
        ),
        body: Center(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return CustomPaint(
                painter: AppleWatchPainter(
                  progress: _animationController.value,
                ),
                size: const Size(400, 400),
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _animateValues,
          child: const Icon(Icons.refresh),
        ),
      );
    }
  }

  class AppleWatchPainter extends CustomPainter {
    final double progress;

    AppleWatchPainter({required this.progress});
    @override
    void paint(Canvas canvas, Size size) {
      final raidus = size.width / 2;
      final redRadius = raidus * 0.9;
      final greenRadius = raidus * 0.65;
      final blueRadius = raidus * 0.4;
      const double strokeWidth = 45;
      const startingAngle = -1 / 2 * pi;

      final center = Offset(raidus, raidus);

      // Background Circls
      final redCirclePaint = Paint()
        ..color = Colors.pink.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;
      canvas.drawCircle(center, redRadius, redCirclePaint);

      final greenCirclePaint = Paint()
        ..color = Colors.lightGreen.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;
      canvas.drawCircle(center, greenRadius, greenCirclePaint);

      final blueCirclePaint = Paint()
        ..color = Colors.cyan.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;
      canvas.drawCircle(center, blueRadius, blueCirclePaint);

      // Arc
      final redArcRect = Rect.fromCircle(center: center, radius: redRadius);
      final redArcPaint = Paint()
        ..color = Colors.pink
        ..style = PaintingStyle.stroke
        ..strokeWidth = 45
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(
        redArcRect,
        startingAngle,
        progress,
        false,
        redArcPaint,
      );

      final greenArcRect = Rect.fromCircle(center: center, radius: greenRadius);
      final greenArcPaint = Paint()
        ..color = Colors.lightGreen
        ..style = PaintingStyle.stroke
        ..strokeWidth = 45
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(
        greenArcRect,
        startingAngle,
        progress,
        false,
        greenArcPaint,
      );

      final blueArcRect = Rect.fromCircle(center: center, radius: blueRadius);
      final blueArcPaint = Paint()
        ..color = Colors.lightBlue
        ..style = PaintingStyle.stroke
        ..strokeWidth = 45
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(
        blueArcRect,
        startingAngle,
        progress,
        false,
        blueArcPaint,
      );
    }

    @override
    bool shouldRepaint(covariant AppleWatchPainter oldDelegate) {
      return oldDelegate.progress != progress;
    }
  }
  ```

- Swiping Cards

  ```dart
  import 'package:flutter/material.dart';

  class SwipingCardsScreen extends StatefulWidget {
    const SwipingCardsScreen({super.key});

    @override
    State<SwipingCardsScreen> createState() => _SwipingCardsScreenState();
  }

  class _SwipingCardsScreenState extends State<SwipingCardsScreen> {
    double _posX = 0;

    void _onHorizontalDragUpdate(DragUpdateDetails details) {
      setState(() {
        _posX += details.delta.dx;
      });
    }

    void _onHorizontalDragEnd(DragEndDetails details) {
      setState(() {
        _posX = 0;
      });
    }

    @override
    Widget build(BuildContext context) {
      final size = MediaQuery.of(context).size;
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Swiping Cards',
          ),
        ),
        body: Stack(children: [
          Align(
            alignment: Alignment.topCenter,
            child: GestureDetector(
              onHorizontalDragUpdate: _onHorizontalDragUpdate,
              onHorizontalDragEnd: _onHorizontalDragEnd,
              child: Transform.translate(
                offset: Offset(_posX, 0),
                child: Material(
                  elevation: 20,
                  color: Colors.red.shade100,
                  child: SizedBox(
                    width: size.width * 0.8,
                    height: size.height * 0.5,
                  ),
                ),
              ),
            ),
          )
        ]),
      );
    }
  }
  ```

  - interpolation
    `transform`: Tween값을 lowerBound, uppderBound의 값의 범위로 바꿔준다.

    ```dart
    late final AnimationController _animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 2000),
        lowerBound: -size.width,
        upperBound: size.width,
        value: 0,
      );

      late final Tween<double> _rotation = Tween(
        begin: -15,
        end: 15,
      );

    final angle = _rotation.transform(
                (_animationController.value + size.width / 2) / size.width,
              );
    ```

- Music Player

  - Album PageViewBuilder: _viewportFraction_: 0.8 값을 조정해 앞 뒤의 page도 보이도록

    ```dart
    import 'package:flutter/material.dart';

    class MusicPlaterScreen extends StatefulWidget {
      const MusicPlaterScreen({super.key});

      @override
      State<MusicPlaterScreen> createState() => _MusicPlaterScreenState();
    }

    class _MusicPlaterScreenState extends State<MusicPlaterScreen> {
      final PageController _pageController = PageController(
        initialPage: 0,
        viewportFraction: 0.8,
      );
      @override
      Widget build(BuildContext context) {
        return Scaffold(
          body: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: 10,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 350,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(
                              'assets/images/covers/yeonjae0$index.jpeg',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'yeonjae',
                        style: TextStyle(
                          fontSize: 26,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'home',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  );
                },
              )
            ],
          ),
        );
      }
    }
    ```

  - AnimatedSwitcher: Animate between old child and new child
    Container는 변경되지 않고 그 속성만 변하기 때문에 animation효과가 나타나지 않는다
    따라서 key를 부여하여 다른 child임을 명시할 수 있다
    ```dart
    AnimatedSwitcher(
                duration: const Duration(
                  milliseconds: 500,
                ),
                child: Container(
                  key: ValueKey(_currentPage),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(
                        'assets/images/covers/yeonjae0$_currentPage.jpeg',
                      ),
                    ),
                  ),
                ),
              ),
    ```
  - BackdropFilter
    ```dart
    child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 15,
                      sigmaY: 15,
                    ),
                    child: Container(color: Colors.black.withOpacity(0.5)),
                  ),
    ```
  - ValueNotifier & ValueListenableBuilder
    page정보를 값으로 저장하고, index와 비교를 통해 scale 조정

    ```dart
    final ValueNotifier<double> _scroll = ValueNotifier(0);

      @override
      void initState() {
        super.initState();
        _pageController.addListener(() {
          if (_pageController.page == null) return;
          _scroll.value = _pageController.page!;
        });
      }

    ValueListenableBuilder(
                        valueListenable: _scroll,
                        builder: (context, scroll, child) {
                          final difference = (scroll - index).abs();
                          final scale = 1 - difference * 0.1;
                          return Transform.scale(
                            scale: scale,
                            child: Container(
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
                                    'assets/images/covers/yeonjae0$index.jpeg',
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
    ```

  - AnimatedIcon
    ```dart
    AnimatedIcon(
                  icon: AnimatedIcons.pause_play,
                  progress: _playPauseController,
                  size: 60,
                ),
    ```
  - Lottie
    `flutter pub add lottie`
    ```dart
    Lottie.asset(
                      'assets/animations/play-lottie.json',
                      controller: _playPauseController,
                      onLoaded: (composition) {
                        _playPauseController.duration = composition.duration;
                        // ..forward();
                      },
                      width: 200,
                      height: 200,
                    ),
    ```

- CoveredMenu

  - staggered animation: 애니메이션이 동시에 실행되지 않고 순차적으로 실행 ([docs](https://docs.flutter.dev/ui/animations/staggered-animations))

  ```dart
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
  ```

- Rive (Library)
  `flutter pub add rive`
  [docs](https://rive.app/)

  ```dart
  import 'package:flutter/material.dart';
  import 'package:rive/rive.dart';

  class RiveScreen extends StatefulWidget {
    const RiveScreen({super.key});

    @override
    State<RiveScreen> createState() => _RiveScreenState();
  }

  class _RiveScreenState extends State<RiveScreen> {
    late final StateMachineController _stateMachineController;

    void _onInit(Artboard artboard) {
      _stateMachineController = StateMachineController.fromArtboard(
        artboard,
        'State Machine 1',
      )!;
      // artboard is just a canvas
      artboard.addController(_stateMachineController);
    }

    void _togglePanel() {
      final input = _stateMachineController.findInput<bool>('panelActive')!;

      input.change(!input.value);
    }

    @override
    void dispose() {
      _stateMachineController.dispose();
      super.dispose();
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Rive'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                height: 400,
                child: RiveAnimation.asset(
                  'assets/animations/sample-rive.riv',
                  artboard: 'Dwarf Panel',
                  stateMachines: const ['State Machine 1'],
                  onInit: _onInit,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _togglePanel,
                child: const Text('Go!'),
              )
            ],
          ),
        ),
      );
    }
  }
  ```

- Material Animations
  `flutter pub add animations`
  - OpenContainer
    - closedBuilder, openBuilder
      ```dart
      OpenContainer(
                          closedElevation: 0,
                          openElevation: 0,
                          transitionDuration: const Duration(seconds: 1),
                          closedBuilder: (context, action) => ListTile(
                            leading: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage(
                                      'assets/images/covers/yeonjae0${index % 10}.jpeg'),
                                ),
                              ),
                            ),
                            title: const Text('Dune sound track'),
                            subtitle: const Text('Hans zimmer'),
                            trailing: const Icon(Icons.arrow_forward_ios),
                          ),
                          openBuilder: (context, action) => DetailScreen(
                            imageIndex: index,
                          ),
                        ),
      ```
  - PageTransitionSwitcher-SharedAxisTransition
    ```dart
    PageTransitionSwitcher(
              transitionBuilder: (child, primaryAnimation, secondaryAnimation) =>
                  SharedAxisTransition(
                animation: primaryAnimation,
                secondaryAnimation: secondaryAnimation,
                transitionType: SharedAxisTransitionType.horizontal,
                child: child,
              ),
              child: AspectRatio(
                key: ValueKey(_currentImage),
                aspectRatio: 1,
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    'assets/images/covers/yeonjae0${_currentImage % 10}.jpeg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
    ```
  - PageTransitionSwitcher-FadeThroughTransition
    ```dart
    PageTransitionSwitcher(
            duration: const Duration(seconds: 1),
            transitionBuilder: (child, primaryAnimation, secondaryAnimation) =>
                FadeThroughTransition(
              animation: primaryAnimation,
              secondaryAnimation: secondaryAnimation,
              child: child,
            ),
            child: [
              const NavigationPage(
                  key: ValueKey('Profile'), text: 'Profile', icon: Icons.person),
              const NavigationPage(
                  key: ValueKey('Notifications'),
                  text: 'Notifications',
                  icon: Icons.notifications),
              const NavigationPage(
                  key: ValueKey('Settings'),
                  text: 'Settings',
                  icon: Icons.settings),
            ][_navIndex],
          ),
    ```
