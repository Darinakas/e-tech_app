import 'package:flutter/material.dart';

class HoverAnimatedFilter extends StatefulWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const HoverAnimatedFilter({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<HoverAnimatedFilter> createState() => _HoverAnimatedFilterState();
}

class _HoverAnimatedFilterState extends State<HoverAnimatedFilter>
    with SingleTickerProviderStateMixin {
  double _scale = 1.0;
  bool _isHovered = false;

  void _onTapDown(TapDownDetails _) {
    setState(() {
      _scale = 1.1;
    });
  }

  void _onTapUp(TapUpDetails _) {
    setState(() {
      _scale = 1.0;
    });
  }

  void _onTapCancel() {
    setState(() {
      _scale = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedScale(
          scale: _isHovered ? 1.1 : _scale,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: widget.isSelected ? Colors.deepPurple : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: widget.isSelected ? Colors.deepPurple : Colors.grey.shade400,
              ),
              boxShadow: _isHovered
                  ? [BoxShadow(color: Colors.black12, blurRadius: 8)]
                  : [],
            ),
            child: Text(
              widget.label,
              style: TextStyle(
                color: widget.isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
