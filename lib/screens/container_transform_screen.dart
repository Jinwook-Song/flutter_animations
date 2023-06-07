import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class ContainerTransformScreen extends StatefulWidget {
  const ContainerTransformScreen({super.key});

  @override
  State<ContainerTransformScreen> createState() =>
      _ContainerTransformScreenState();
}

class _ContainerTransformScreenState extends State<ContainerTransformScreen> {
  bool _isGrid = false;

  void _toggleGrid() {
    setState(() {
      _isGrid = !_isGrid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Container Transform',
        ),
        actions: [
          IconButton(
            onPressed: _toggleGrid,
            icon: const Icon(
              Icons.grid_4x4,
            ),
          )
        ],
      ),
      body: _isGrid
          ? GridView.builder(
              itemCount: 20,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 1 / 1.5,
              ),
              itemBuilder: (context, index) => OpenContainer(
                transitionDuration: const Duration(seconds: 1),
                closedBuilder: (context, action) => Image.asset(
                  'assets/images/covers/yeonjae0${index % 10}.jpeg',
                  fit: BoxFit.cover,
                ),
                openBuilder: (context, action) => DetailScreen(
                  imageIndex: index,
                ),
              ),
            )
          : ListView.separated(
              itemBuilder: (context, index) => OpenContainer(
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
              separatorBuilder: (context, index) => const SizedBox(height: 20),
              itemCount: 20),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final int imageIndex;
  const DetailScreen({super.key, required this.imageIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Screen',
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/covers/yeonjae0${imageIndex % 10}.jpeg'),
          const SizedBox(height: 20),
          const Text(
            'Yeonjae',
            style: TextStyle(fontSize: 20),
          )
        ],
      ),
    );
  }
}
