import 'package:flutter/material.dart';

class RatingStars extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const RatingStars({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        5,
        (index) => IconButton(
          iconSize: 30,
          onPressed: () => onChanged(index + 1),
          icon: Icon(
            index < value ? Icons.star : Icons.star_border,
            color: Colors.amber,
          ),
        ),
      ),
    );
  }
}
