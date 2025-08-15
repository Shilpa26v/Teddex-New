import 'package:flutter/material.dart';

class DotsIndicator extends StatelessWidget {
  final int selectedIndex;
  final int itemCount;
  final Color? color;
  final Color? unselectedColor;
  final double _selectedHeight;
  final double _height;
  final double _selectedWidth;
  final double _width;
  final double gap;

  const DotsIndicator({
    Key? key,
    required this.itemCount,
    required this.selectedIndex,
    double? selectedHeight,
    double? height,
    double? selectedWidth,
    double? width,
    this.color,
    this.unselectedColor,
    this.gap = 4,
  })  : assert(itemCount > 0),
        assert(selectedIndex >= 0 && selectedIndex < itemCount),
        assert(gap >= 0),
        assert(selectedWidth == null || selectedWidth > 0),
        assert(width == null || width > 0),
        assert(selectedHeight == null || selectedHeight > 0),
        assert(height == null || height > 0),
        _selectedHeight = selectedHeight ?? height ?? 12,
        _height = height ?? selectedHeight ?? 12,
        _selectedWidth = selectedWidth ?? width ?? 32,
        _width = width ?? 12,
        super(key: key);

  const DotsIndicator.circle({
    Key? key,
    required this.itemCount,
    required this.selectedIndex,
    double selectedRadius = 6,
    double radius = 4,
    this.color,
    this.unselectedColor,
    this.gap = 4,
  })  : assert(itemCount > 0),
        assert(selectedIndex >= 0 && selectedIndex < itemCount),
        assert(gap >= 0),
        assert(radius > 0),
        assert(selectedRadius > 0),
        _selectedHeight = selectedRadius * 2,
        _height = radius * 2,
        _selectedWidth = selectedRadius * 2,
        _width = radius * 2,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var selectedColor = color ?? Theme.of(context).primaryColor;
    var unselectedColor = this.unselectedColor ?? selectedColor.withOpacity(.2);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        itemCount,
        (index) {
          bool isSelected = selectedIndex == index;
          return AnimatedContainer(
            curve: Curves.elasticOut,
            width: isSelected ? _selectedWidth : _width,
            height: isSelected ? _selectedHeight : _height,
            duration: const Duration(milliseconds: 500),
            margin: EdgeInsets.symmetric(horizontal: isSelected ? gap : gap / 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: isSelected ? selectedColor : unselectedColor,
            ),
          );
        },
      ),
    );
  }
}
