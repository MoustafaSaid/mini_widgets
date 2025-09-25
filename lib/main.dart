import 'dart:ui';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Widget Catalog',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const CatalogHome(),
    );
  }
}

class CatalogHome extends StatelessWidget {
  const CatalogHome({super.key});

  @override
  Widget build(BuildContext context) {
    final demos = <_DemoEntry>[
      _DemoEntry(
        title: 'InteractiveViewer',
        subtitle: 'Panning and zooming a canvas',
        builder: (_) => const InteractiveViewerDemo(),
      ),
      _DemoEntry(
        title: 'DraggableScrollableSheet',
        subtitle: 'Bottom sheet that can be dragged',
        builder: (_) => const DraggableSheetDemo(),
      ),
      _DemoEntry(
        title: 'ListWheelScrollView',
        subtitle: '3D cylindrical list wheel',
        builder: (_) => const ListWheelDemo(),
      ),
      _DemoEntry(
        title: 'ClipPath + CustomClipper',
        subtitle: 'Clip widgets with custom shapes',
        builder: (_) => const ClipPathDemo(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Widget Catalog'),
      ),
      body: ListView.separated(
        itemCount: demos.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final demo = demos[index];
          return ListTile(
            title: Text(demo.title),
            subtitle: Text(demo.subtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: demo.builder),
            ),
          );
        },
      ),
    );
  }
}

class _DemoEntry {
  const _DemoEntry({
    required this.title,
    required this.subtitle,
    required this.builder,
  });

  final String title;
  final String subtitle;
  final WidgetBuilder builder;
}

class InteractiveViewerDemo extends StatelessWidget {
  const InteractiveViewerDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('InteractiveViewer')),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500, maxHeight: 500),
          color: Colors.grey.shade200,
          child: InteractiveViewer(
            minScale: 0.5,
            maxScale: 5,
            boundaryMargin: const EdgeInsets.all(80),
            child: CustomPaint(
              size: const Size(800, 800),
              painter: _GridPainter(),
              child: const Center(
                child: FlutterLogo(size: 120),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint gridPaint = Paint()
      ..color = Colors.black12
      ..strokeWidth = 1;
    const double step = 40;
    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
    final axisPaint = Paint()
      ..color = Colors.indigo
      ..strokeWidth = 2;
    canvas.drawLine(Offset(0, 0), Offset(size.width, 0), axisPaint);
    canvas.drawLine(Offset(0, 0), Offset(0, size.height), axisPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DraggableSheetDemo extends StatelessWidget {
  const DraggableSheetDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DraggableScrollableSheet')),
      body: Stack(
        children: [
          Positioned.fill(
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.indigo, Colors.deepPurple],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.2,
            minChildSize: 0.12,
            maxChildSize: 0.85,
            builder: (context, controller) {
              return Material(
                elevation: 8,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
                clipBehavior: Clip.antiAlias,
                child: SafeArea(
                  top: false,
                  bottom: false,
                  child: ListView.builder(
                    controller: controller,
                    itemCount: 33,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Center(
                          child: Container(
                            width: 40,
                            height: 6,
                            margin: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.black26,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        );
                      }
                      if (index == 1) {
                        return const ListTile(
                          leading: Icon(Icons.drag_handle),
                          title: Text('Recently Played'),
                          subtitle: Text('Drag up for more'),
                        );
                      }
                      if (index == 2) {
                        return const Divider(height: 1);
                      }
                      final trackIndex = index - 2;
                      return ListTile(
                        leading: CircleAvatar(child: Text('$trackIndex')),
                        title: Text('Track $trackIndex'),
                        subtitle: const Text('Artist Name'),
                        trailing: const Icon(Icons.more_vert),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ListWheelDemo extends StatelessWidget {
  const ListWheelDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final items = List.generate(20, (i) => i + 1);
    return Scaffold(
      appBar: AppBar(title: const Text('ListWheelScrollView')),
      body: Center(
        child: SizedBox(
          height: 300,
          child: ListWheelScrollView.useDelegate(
            itemExtent: 60,
            physics: const FixedExtentScrollPhysics(),
            perspective: 0.003,
            diameterRatio: 2.0,
            overAndUnderCenterOpacity: 0.4,
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: items.length,
              builder: (context, index) {
                final value = items[index];
                return Card(
                  color: Colors.indigo.shade100,
                  child: Center(
                    child: Text(
                      'Item $value',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class ClipPathDemo extends StatelessWidget {
  const ClipPathDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ClipPath + CustomClipper')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipPath(
              clipper: _TicketClipper(),
              child: Container(
                color: Colors.amber,
                width: 260,
                height: 120,
                alignment: Alignment.center,
                child: const Text('Admit One',
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 24),
            ClipPath(
              clipper: _WaveClipper(),
              child: Container(
                width: 260,
                height: 120,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.indigo, Colors.cyan],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                alignment: Alignment.center,
                child: const Text('Wavy Card',
                    style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    const radius = 14.0;
    path.addRRect(
        RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(12)));
    // Punch semi-circles on the middle of left and right edges
    final notchPath = Path()
      ..addOval(
          Rect.fromCircle(center: Offset(0, size.height / 2), radius: radius))
      ..addOval(Rect.fromCircle(
          center: Offset(size.width, size.height / 2), radius: radius));
    return Path.combine(PathOperation.difference, path, notchPath);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 30);
    path.quadraticBezierTo(
        size.width * 0.25, size.height, size.width * 0.5, size.height - 30);
    path.quadraticBezierTo(
        size.width * 0.75, size.height - 60, size.width, size.height - 30);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
