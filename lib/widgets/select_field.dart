part of 'widgets.dart';

class SelectField extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String?)? savedValue;
  final double marginTop;
  final void Function(String?)? onChange;
  final String value;
  final List<dynamic> categories;

  SelectField(
      {Key? key,
      this.labelText,
      this.prefixIcon,
      this.suffixIcon,
      this.validator,
      this.savedValue,
      this.marginTop = 10,
      required this.categories,
      this.onChange,
      required this.value,
      this.hintText});

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      builder: (FormFieldState<String> state) {
        return InputDecorator(
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: greyTextFont,
            labelText: labelText,
            labelStyle: greyTextFont.copyWith(),
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
          // isEmpty: _currentSelectedValue == '',
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isDense: true,
              onChanged: onChange,
              items: categories.map((value) {
                return DropdownMenuItem<String>(
                  value: value.id,
                  child: Text(value.title),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
