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
            const SizedBox(height: 10),
            SecondaryButton(
              title: "Accueil",
              icon: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Icon(LineIcons.home),
              ),
              focus: true,
              color: whiteColor,
              // backgroundColor: whiteColor.withOpacity(0.03),
              radius: const BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              size: 24,
              onPress: () {
                if(Get.currentRoute.compareTo(RouteName.home) == 0) {
                  Get.close(1);
                  return;
                }
                Get.close(2);
                Get.toNamed(RouteName.home);
              },
            ),
            SecondaryButton(
              title: "Tableau de bord",
              icon: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Icon(LineIcons.archive),
              ),
              focus: false,
              color: whiteColor,
              // backgroundColor: greyColor.withOpacity(0.3),
              radius: const BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              size: 24,

              onPress: () {
                if(Get.currentRoute.compareTo(RouteName.dashboard) == 0) {
                  Get.close(1);
                  return;
                }
                Get.close(2);
                Get.toNamed(RouteName.dashboard);
              },
            ),
            // class mengajar
            teachClass(),

            // class terdaftar
            registeredClass(),

            SecondaryButton(
              title: "Mes cours",
              icon: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Icon(LineIcons.list),
              ),
              focus: false,
              color: whiteColor,
              radius: const BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              size: 24,
              onPress: () {
                if(Get.currentRoute.compareTo(RouteName.courses) == 0) {
                  Get.close(1);
                  return;
                }
                Get.close(2);
                Get.toNamed(RouteName.courses);
                // Get.close(1);
                //
                // Get.to(EmptyWidget());
              },
            ),
            // SecondaryButton(
            //   title: "Setting",
            //   icon: const Padding(
            //     padding: EdgeInsets.symmetric(horizontal: 24),
            //     child: Icon(LineIcons.userCog),
            //   ),
            //   focus: false,
            //   color: whiteColor,
            //   radius: const BorderRadius.only(
            //     topRight: Radius.circular(20),
            //     bottomRight: Radius.circular(20),
            //   ),
            //   size: 24,
            //   onPress: () {
            //     Get.close(1);
            //     Get.to(EmptyWidget());
            //   },
            // ),
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
