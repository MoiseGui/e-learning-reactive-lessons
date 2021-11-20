part of 'widgets.dart';

class CardClass extends StatelessWidget {
  String? title;
  String? username;
  final colorTheme;
  String? image;

  CardClass({
    Key? key,
    this.title,
    this.username,
    this.colorTheme,
    this.image
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var sizeScreen = MediaQuery.of(context).size;
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
        height: 300,
        width: 308,
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
                  padding: const EdgeInsets.all(20),
                  width: sizeScreen.width,
                  decoration: BoxDecoration(
                    color: mainColor2,
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
                          Text(
                            title.toString(),
                            style: whiteTextFont.copyWith(
                              letterSpacing: 1,
                              fontSize: 18,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Get.toNamed(RouteName.login);
                            },
                            child: Icon(
                              LineIcons.verticalEllipsis,
                              color: bgColor,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                      Text(username.toString()),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      alignment: Alignment(-.2, 0),
                      image: NetworkImage('https://image.freepik.com/free-photo/close-up-image-programer-working-his-desk-office_1098-18707.jpg'),
                      fit: BoxFit.cover),
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
                      fixedSize: const Size.fromWidth(308),
                      primary: mainColor,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10))
                      )),
                  child: const Text("Suivre ce cours"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CourseDetail(title: title.toString())),
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
