import 'package:flutter/material.dart';

class DancingDotsLoader extends StatefulWidget {
  const DancingDotsLoader({super.key, this.size = 10});

  final double size;

  @override
  State<DancingDotsLoader> createState() => _DancingDotsLoaderState();
}

class _DancingDotsLoaderState extends State<DancingDotsLoader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final List<Color> colors = const [
    Color(0xFF4CAF50),
    Color(0xFF2196F3),
    Color(0xFFFFC107),
    Color(0xFFE91E63),
    Color(0xFF9C27B0),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (_, __) {
            final progress = (_controller.value + index * 0.15) % 1;
            final double translateY = -8 * (1 - (progress - 0.5).abs() * 2).clamp(0.0, 1.0);

            return Transform.translate(
              offset: Offset(0, translateY),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  color: colors[index],
                  shape: BoxShape.circle,
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
