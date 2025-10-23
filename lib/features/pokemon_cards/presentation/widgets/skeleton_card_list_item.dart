import 'package:flutter/material.dart';

/// Un widget que muestra un placeholder con la forma de un [PokemonCardListItem].
/// Utiliza un gradiente animado para dar una sensación de carga.
class SkeletonCardListItem extends StatefulWidget {
  const SkeletonCardListItem({super.key});

  @override
  State<SkeletonCardListItem> createState() => _SkeletonCardListItemState();
}

class _SkeletonCardListItemState extends State<SkeletonCardListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;
        final baseColor = isDarkMode ? Colors.grey[800]! : Colors.grey[300]!;
        final highlightColor = isDarkMode ? Colors.grey[700]! : Colors.grey[100]!;

        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [baseColor, highlightColor, baseColor],
              stops: [
                _controller.value - 0.5,
                _controller.value,
                _controller.value + 0.5
              ],
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcATop,
          child: const Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SizedBox(height: 124), // Altura similar al item real
          ),
        );
      },
    );
  }
}