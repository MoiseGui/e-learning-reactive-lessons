part of 'widgets.dart';

class CourseCard extends StatelessWidget {
  final Course course;

  const CourseCard({Key? key, required this.course})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var sizeScreen = MediaQuery.of(context).size;
    String title = course.title;
    String description = course.description;
    String? username = course.username;
    String? image = course.image;

    return Card(
      borderOnForeground: true,
      elevation: 5,
      color: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(
          width: 1,
          color: Colors.black26,
        ),
      ),
      child: Container(
        height: 310,
        width: Responsive.isDesktop(context) ? 308 : 400,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: GestureDetector(
                onTap: () {
                  // Get.toNamed(RouteName.classs);
                },
                child: Container(
                  padding: const EdgeInsets.all(15),
                  width: sizeScreen.width,
                  decoration: BoxDecoration(
                    color: linkColor,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(10),
                      topLeft: Radius.circular(10),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(child: RichText(
                            text: TextSpan(text: title.toString(),style: whiteTextFont.copyWith(
                              letterSpacing: 1,
                              fontSize: 18,
                              height: 0.5
                            ),),
                            maxLines: 2,
                            strutStyle: const StrutStyle(fontSize: 18.0),
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                          ),),

                          GestureDetector(
                            onTap: () {
                              // Get.toNamed(RouteName.loginPage);
                            },
                            child: Icon(
                              LineIcons.verticalEllipsis,
                              color: whiteColor,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(username == null ? '' : username.toString()),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                child: Container(
                  decoration:
                      BoxDecoration(color: Colors.black.withOpacity(0.2)),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            description,
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            style: whiteTextFont.copyWith(
                              letterSpacing: 1,
                              fontSize: 14,
                              backgroundColor: Colors.black.withOpacity(0.7),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.black,
                  image: DecorationImage(
                    colorFilter:
                        const ColorFilter.mode(Colors.black, BlendMode.dstATop),
                    alignment: const Alignment(-.2, 0),
                    image: image != null
                        ? NetworkImage(image)
                        : const NetworkImage(
                            'https://image.freepik.com/free-photo/close-up-image-programer-working-his-desk-office_1098-18707.jpg') as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10))),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 20),
                      fixedSize: Responsive.isDesktop(context)
                          ? const Size.fromWidth(308)
                          : const Size.fromWidth(400),
                      primary: mainColor,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10)))),
                  child: const Text("Suivre ce cours"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              CourseDetail(course: course)),
                    );
                    // Get.to(CourseDetail(title: title.toString()));
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
