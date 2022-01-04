part of 'widgets.dart';

class CustomDialog extends StatefulWidget {
  final msg;
  final loading;
  const   CustomDialog({Key? key, this.msg, this.loading = false}) : super(key: key);

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 200,
          child: widget.loading ? Image.asset('assets/loading.gif')
              : const FlareActor(
            'assets/Success-Check.flr',
            animation: 'Untitled',
          ),
        ),
        const SizedBox(height: 10),
        Text(
          '${widget.msg}',
          textAlign: TextAlign.center,
          style: whiteTextFont.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
