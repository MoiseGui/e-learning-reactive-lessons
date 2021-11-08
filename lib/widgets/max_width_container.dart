import 'package:flutter/material.dart';

class MaxWidthContainer extends StatelessWidget {
  final Widget? child;
  final double maxWidth;

  const MaxWidthContainer({
    Key? key,
    @required this.child,
    this.maxWidth = 1400,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth,
        ),
        child: child,
      ),
    );
  }
}
