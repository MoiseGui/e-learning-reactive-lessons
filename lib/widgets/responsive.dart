import 'package:flutter/cupertino.dart';


class Responsive extends StatelessWidget {
  final Widget? mobile;
  final Widget? desktop;
  final Widget? tablet;

  Responsive({
    Key? key,
    this.mobile,
    this.desktop,
    this.tablet,
  }) : super(key: key);

  bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 650;

  bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < 1024 &&
      MediaQuery.of(context).size.width >= 650;

  bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1024;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1024) {
          return Container(
            child: desktop,
          );
        } else if (constraints.maxWidth >= 650) {
          return Container(
            child: tablet,
          );
        } else {
          return Container(
            child: mobile,
          );
        }
      },
    );
  }
}