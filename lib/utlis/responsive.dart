import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  const Responsive({required this.child, super.key});
  final Widget child;

  @override
  Widget build(
    BuildContext context,
  ) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 600,
        ),
        child: child,
      ),
    );
  }
}
