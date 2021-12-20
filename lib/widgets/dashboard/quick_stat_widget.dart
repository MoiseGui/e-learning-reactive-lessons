part of '../widgets.dart';

class QuickLinkWidget extends StatelessWidget {
  final IconData? icon;
  final String value;
  final String text;
  final Color? color;

  const QuickLinkWidget({Key? key, this.icon, required this.value, required this.text, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(5.0)),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          color: const Color(0xFF222222),
        ),
        // color: const Color(0xFF222222),
        width: Responsive.isDesktop(context) ? 200 : 150,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              Icon(
                icon ?? LineIcons.school,
                size: 35.0,
                color: Colors.white,
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                value,
                style: TextStyle(fontSize: 22, color: color ?? Colors.green),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    text,
                    style: const TextStyle(fontSize: 15),
                  ),
                  const Icon(
                    LineIcons.chevronCircleRight,
                    size: 25.0,
                    color: Colors.blue,
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}