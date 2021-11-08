part of 'widgets.dart';

class SlideDrawer extends StatelessWidget {
  const SlideDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final sizeScreen = MediaQuery.of(context).size;
    return Drawer(
      child: Container(
        color: bgColor,
        // width: sizeScreen.width * 0.22,
        padding: const EdgeInsets.only(right: 20),
        child: ListView(
          children: [
            SizedBox(height: 10),
            SecondaryButton(
              title: "Class",
              icon: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Icon(LineIcons.home),
              ),
              focus: true,
              color: secondColor,
              backgroundColor: secondColor.withOpacity(0.03),
              radius: BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              size: 24,
              onPress: () {
                Get.close(1);
                // Get.toNamed(RouteName.home);
              },
            ),
            SecondaryButton(
              title: "Calendar",
              icon: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Icon(LineIcons.calendar),
              ),
              focus: false,
              color: secondColor,
              // backgroundColor: greyColor.withOpacity(0.3),
              radius: BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              size: 24,

              onPress: () {
                Get.close(1);
                Get.to(EmptyWidget());
              },
            ),
            // class mengajar
            teachClass(),

            // class terdaftar
            registeredClass(),

            SecondaryButton(
              title: "Archived Class",
              icon: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Icon(LineIcons.archive),
              ),
              focus: false,
              color: secondColor,
              radius: BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              size: 24,
              onPress: () {
                Get.close(1);

                Get.to(EmptyWidget());
              },
            ),
            SecondaryButton(
              title: "Setting",
              icon: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Icon(LineIcons.userCog),
              ),
              focus: false,
              color: secondColor,
              radius: BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              size: 24,
              onPress: () {
                Get.close(1);
                Get.to(EmptyWidget());
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget teachClass() {
    return Column(
      children: [],
    );
  }

  Widget registeredClass() {
    return Column(
      children: [],
    );
  }
}
