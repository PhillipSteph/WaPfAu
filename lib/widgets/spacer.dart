import 'package:flutter/material.dart';

class SpacerWidget extends StatelessWidget {
  final double height; // optional height parameter

  const SpacerWidget({super.key, this.height = 16}); // default height 16

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: double.infinity),
      child: SizedBox(height: height),
    );
  }
}
