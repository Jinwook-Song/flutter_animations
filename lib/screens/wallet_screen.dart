import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  bool _expanded = false;

  void _onExpand() {
    setState(() {
      _expanded = true;
    });
  }

  void _onShrink(DragEndDetails _) {
    setState(() {
      _expanded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wallet')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GestureDetector(
          onVerticalDragEnd: _onShrink,
          onTap: _onExpand,
          child: Column(
            children: [
              const CreditCard(bgColor: Colors.pink)
                  .animate(delay: 3.seconds, target: _expanded ? 0 : 1)
                  .flipV(end: 10 / 180),
              const CreditCard(bgColor: Colors.black)
                  .animate(delay: 3.seconds, target: _expanded ? 0 : 1)
                  .flipV(end: 10 / 180)
                  .slideY(begin: 0, end: -0.8, curve: Curves.easeOut),
              const CreditCard(bgColor: Colors.purple)
                  .animate(delay: 3.seconds, target: _expanded ? 0 : 1)
                  .flipV(end: 10 / 180)
                  .slideY(begin: 0, end: -0.8 * 2, curve: Curves.easeOut),
            ]
                .animate(interval: 1.seconds)
                .slideX(
                    begin: -1,
                    end: 0,
                    duration: 1.seconds,
                    curve: Curves.easeOut)
                .fadeIn(duration: 1.seconds, curve: Curves.easeOut),
          ),
        ),
      ),
    );
  }
}

class CreditCard extends StatelessWidget {
  final Color bgColor;
  const CreditCard({
    super.key,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: bgColor,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 40,
        ),
        child: Column(
          children: [
            const SizedBox(height: 100),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nomad Conders',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '**** **** **26',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 20,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.amber,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
