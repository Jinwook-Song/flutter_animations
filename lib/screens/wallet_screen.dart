import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

List<Color> colors = [
  Colors.pink,
  Colors.black,
  Colors.purple,
];

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  bool _isExpanded = false;

  void _onExpand() {
    setState(() {
      _isExpanded = true;
    });
  }

  void _onShrink(DragEndDetails _) {
    setState(() {
      _isExpanded = false;
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
              for (var index in [0, 1, 2])
                Hero(
                  tag: '$index',
                  child: CreditCard(
                    index: index,
                    isExpanded: _isExpanded,
                  )
                      .animate(delay: 3.seconds, target: _isExpanded ? 0 : 1)
                      .flipV(end: 10 / 180)
                      .slideY(
                          begin: 0, end: -0.8 * index, curve: Curves.easeOut),
                ),
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

class CreditCard extends StatefulWidget {
  final int index;
  final bool isExpanded;
  const CreditCard({
    super.key,
    required this.index,
    required this.isExpanded,
  });

  @override
  State<CreditCard> createState() => _CreditCardState();
}

class _CreditCardState extends State<CreditCard> {
  void _onTap() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CardDetailScreen(index: widget.index),
            fullscreenDialog: true));
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: AbsorbPointer(
        absorbing: !widget.isExpanded,
        child: GestureDetector(
          onTap: _onTap,
          child: Container(
            width: double.maxFinite,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: colors[widget.index],
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
          ),
        ),
      ),
    );
  }
}

class CardDetailScreen extends StatelessWidget {
  final int index;
  const CardDetailScreen({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transactions')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          Hero(
            tag: '$index',
            child: CreditCard(
              index: index,
              isExpanded: false,
            ),
          ),
          ...[
            for (var _ in [1, 2, 3, 4, 5])
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  tileColor: Colors.grey.shade200,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                    10,
                  )),
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.orange,
                    ),
                    child: const Icon(
                      Icons.shopping_bag_outlined,
                      color: Colors.white,
                    ),
                  ),
                  title: const Text(
                    'Nike',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Text(
                    'Gangnam',
                    style: TextStyle(
                      color: Colors.grey.shade800,
                    ),
                  ),
                  trailing: const Text('\$123,456',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                ),
              )
          ]
              .animate(interval: 300.ms)
              .fadeIn(duration: 300.ms, curve: Curves.easeOut)
              .slideY(begin: -0.5, end: 0, duration: 300.ms)
              .flipV(begin: 1 / 2, end: 0, duration: 300.ms),
        ]),
      ),
    );
  }
}
