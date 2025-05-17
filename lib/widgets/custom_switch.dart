import 'package:alhadiqa/const.dart';
import 'package:flutter/material.dart';

class CustomSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomSwitch({super.key, required this.value, required this.onChanged});

  @override
  State<CustomSwitch> createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      value: widget.value ? 1 : 0,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void didUpdateWidget(covariant CustomSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value) {
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
  Widget build(BuildContext context) {
    final double switchWidth = 50;
    final double switchHeight = 28;
    final double knobSize = 24;

    return GestureDetector(
      onTap: () {
        widget.onChanged(!widget.value);
      },
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Container(
            width: switchWidth,
            height: switchHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Color.lerp(
                Colors.grey[400],
                kSecondaryColor,
                _animation.value,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: Align(
                alignment:
                    Alignment.lerp(
                      Alignment.centerLeft,
                      Alignment.centerRight,
                      _animation.value,
                    )!,
                child: Container(
                  width: knobSize,
                  height: knobSize,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
