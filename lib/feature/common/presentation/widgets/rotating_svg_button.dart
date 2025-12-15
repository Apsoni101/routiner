import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RotatingSvgButton extends StatefulWidget {
  const RotatingSvgButton({
    required this.assetName,
    required this.onTap,
    required this.isRotated,
    super.key,
    this.size = 64,
  });

  final String assetName;
  final VoidCallback onTap;
  final bool isRotated;
  final double size;

  @override
  State<RotatingSvgButton> createState() => _RotatingSvgButtonState();
}

class _RotatingSvgButtonState extends State<RotatingSvgButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _rotation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _rotation = Tween<double>(
      begin: 0,
      end: pi / 4,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void didUpdateWidget(covariant final RotatingSvgButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isRotated) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _rotation,
        builder: (_, final Widget? child) {
          return Transform.rotate(angle: _rotation.value, child: child);
        },
        child: SvgPicture.asset(
          widget.assetName,
          width: widget.size,
          height: widget.size,
        ),
      ),
    );
  }
}
