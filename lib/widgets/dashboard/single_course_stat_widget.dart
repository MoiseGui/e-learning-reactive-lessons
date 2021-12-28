part of '../widgets.dart';

class SingleCourseStatWidget extends StatelessWidget {
  final IconData? icon;
  final String value;
  final String text;
  final Color? color;

  const SingleCourseStatWidget(
      {Key? key,
      this.icon,
      required this.value,
      required this.text,
      this.color})
      : super(key: key);

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
        width: Responsive.isDesktop(context) ? 200 : 130,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const SizedBox(
              //   height: 5,
              // ),
              Icon(
                icon ?? LineIcons.school,
                size: 30.0,
                color: Colors.white,
              ),
              const SizedBox(
                height: 5,
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    value,
                    style: TextStyle(fontSize: 22, color: color ?? Colors.green),
                  ),
                  Text(
                    text,
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),
              // const SizedBox(
              //   height: 5,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
