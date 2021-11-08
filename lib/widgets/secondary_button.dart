part of 'widgets.dart';

class SecondaryButton extends StatelessWidget {
  final title;
  bool? focus;
  final icon;
  final color;
  void Function()? onPress;
  final backgroundColor;
  final radius;
  double size;

  SecondaryButton({
    Key? key,
    this.title,
    this.focus,
    this.color,
    this.backgroundColor,
    this.icon,
    this.onPress,
    this.radius,
    this.size = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPress,
      icon: icon,
      autofocus: focus,
      label: Text(title),
      style: TextButton.styleFrom(
        primary: color,
        alignment: Alignment.centerLeft,
        backgroundColor: backgroundColor,
        padding: EdgeInsets.symmetric(vertical: size, horizontal: size),
        shape: RoundedRectangleBorder(
          borderRadius: radius,
        ),
      ),
    );
  }
}
