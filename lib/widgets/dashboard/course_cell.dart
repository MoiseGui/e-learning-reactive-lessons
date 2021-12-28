part of '../widgets.dart';

class CourseCell extends StatelessWidget {
  // final Landmark landmark;

  const CourseCell({
    Key? key,
    // @required this.landmark,
    // @required this.onTap,
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

            },
            leading: Image.asset(
              'assets/illus/Education Illustration Kit-06.png',
              width: 50.0,
            ),
            title: Text("landmark.name"),
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