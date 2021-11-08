part of 'widgets.dart';

class EmptyWidget extends StatelessWidget {
  EmptyWidget({
    Key? key,
    this.button = true,
  }) : super(key: key);

  bool button;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: bgColor,
        width: MediaQuery.of(context).size.width,
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/illus/kosong.png",
            height: 300,
          ),
          SizedBox(height: 20),
          Text(
            "No Data",
            style: greyTextFont.copyWith(
              fontSize: 18,
            ),
          ),
          SizedBox(height: 70),
          (button != true)
              ? SizedBox()
              : PrimaryButton(
                  text: "Back",
                  onPress: () {
                    Get.back();
                  },
                )
        ],
      )),
    );
  }
}
