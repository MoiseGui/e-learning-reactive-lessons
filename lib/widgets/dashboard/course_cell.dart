part of '../widgets.dart';

class CourseCell extends StatelessWidget {
  final Course course;

  final onTap;

  const CourseCell({
    Key? key, required this.course,
    // @required this.landmark,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Material(
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 2.0,
            ),
            onTap: (){
              onTap();
            },
            leading: course.image != null ? Image.network(course.image!)
            : Image.network(
              'https://image.freepik.com/free-photo/close-up-image-programer-working-his-desk-office_1098-18707.jpg',
              width: 30.0,
            ),
            title: Text(course.title),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: const <Widget>[
                Icon(
                  Icons.arrow_forward_ios,
                  size: 15.0,
                  color: Color(0xFFD3D3D3),
                ),
              ],
            ),
          ),
        ),
        const Divider(
          height: 1,
          indent: 16.0,
        ),
      ],
    );
  }
}