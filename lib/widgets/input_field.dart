part of 'widgets.dart';

class InputField extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final TextEditingController? userInputController;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool secure;
  final String? Function(String?)? validator;
  final void Function(String?)? savedValue;
  final double marginTop;
  final keyboardType;
  final maxLines;
  final minLines;

  const InputField({
    Key? key,
    this.hintText,
    this.labelText,
    this.userInputController,
    this.prefixIcon,
    this.suffixIcon,
    this.secure = false,
    this.validator,
    this.savedValue,
    this.marginTop = 16,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.minLines = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      margin: EdgeInsets.only(top: marginTop),
      child: TextFormField(
        keyboardType: keyboardType,
        minLines: minLines,
        maxLines: maxLines,
        controller: userInputController,
        validator: validator,
        onSaved: savedValue,
        cursorColor: whiteColor,
        obscureText: secure,
        style: whiteTextFont.copyWith(),
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          hintText: hintText,
          hintStyle: greyTextFont,
          labelText: labelText,
          labelStyle: greyTextFont.copyWith(),
          errorStyle: TextStyle(color: errorColor),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: errorColor,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: errorColor,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: whiteColor,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: successColor,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
