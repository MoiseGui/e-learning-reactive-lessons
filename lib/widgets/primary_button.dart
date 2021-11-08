part of 'widgets.dart';

class PrimaryButton extends StatelessWidget {
  void Function()? onPress;
  var text;
  final double top;
  final double right;

  PrimaryButton(
      {Key? key, required this.onPress, required this.text, this.top = 10, this.right = 10})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var sizeScreen = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(bottom: 0, right: right, left: 10, top: top),
      child: ElevatedButton(
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 10,
          ),
          width: sizeScreen.width * 0.3,
          child: Center(
            child: Text(
              "$text",
              style: whiteTextFont.copyWith(fontSize: 16),
            ),
          ),
        ),
        style: ElevatedButton.styleFrom(
          primary: secondColor,
          elevation: 3.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onPress,
      ),
    );
  }
}
