part of './pages/pages.dart';

class HomePage extends StatefulWidget {
  final String title;

  const HomePage({Key? key, required this.title}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  openSlideDrawer() => _scaffoldKey.currentState!.openDrawer();

  var id = '';
  var username = '';
  var email = '';
  String token = '';

  bool isLoggedIn = false;

  getDataPref() async {
    final _sharePref = await SharedPreferences.getInstance();

    id = _sharePref.getString("id")!;
    email = _sharePref.getString("email")!;
    username = _sharePref.getString("username")!;
    token = _sharePref.getString("token")!;


    if (token != null && !token.isBlank!) {
      isLoggedIn = true;
    }
    else{
      isLoggedIn = false;
    }
  }

  @override
  void initState() {
    getDataPref();
    super.initState();
    print("TOKEN "+token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // backgroundColor: bgColor,
      appBar: AppBar(
        // backgroundColor: bgColor,
        elevation: 1,
        title: Text(
          widget.title,
          style: whiteTextFont,
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: GestureDetector(
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: LineIcon(
                LineIcons.bars,
                color: whiteTextFont.color,
              ),
            ),
            onTap: () {
              openSlideDrawer();
              setState(() {
                isLoggedIn = !isLoggedIn;
              });
            },
          ),
        ),
        actions: [
          if (!isLoggedIn)
            GestureDetector(
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Row(
                  children: [
                    LineIcon(LineIcons.userCircleAlt, color: Colors.white),
                    if (Responsive.isDesktop(context))
                      const Text("Me connecter"),
                  ],
                ),
              ),
              onTap: () {
                Get.offAndToNamed("/login");
                // Get.toNamed("/login");
              },
            ),
          if (isLoggedIn)
            GestureDetector(
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: LineIcon(LineIcons.plus, color: Colors.white),
              ),
              onTap: () {
                // Get.defaultDialog(
                // title: '',
                // content: const ChoiseClassOption(),
                // );
              },
            ),
          if (Responsive.isDesktop(context) && isLoggedIn)
            const SizedBox(width: 30),
          if (Responsive.isDesktop(context) && isLoggedIn)
            Center(
              child:
                  // Obx(
                  //                 () =>
                  Text(
                "Hi, MoiseGui 👋",
                style: whiteTextFont.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              // ),
            ),
          if (isLoggedIn) const SizedBox(width: 16),
          if (isLoggedIn)
            const CircleAvatar(
              backgroundColor: Colors.grey,
            ),
          const SizedBox(width: 24),
        ],
      ),
      body: Scrollbar(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: ListView(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    const SizedBox(width: 20),
                    SecondaryButton(
                      title: "Devoirs",
                      icon: const Icon(LineIcons.clipboardList),
                      focus: false,
                      color: linkColor,
                      // backgroundColor: linkColor.withOpacity(0.03),
                      radius: BorderRadius.circular(20),
                      size: 16,
                      onPress: () {
                        Get.to(EmptyWidget());
                      },
                    ),
                    const SizedBox(width: 20),
                    SecondaryButton(
                      title: "TO DO",
                      icon: const Icon(LineIcons.checkSquareAlt),
                      focus: false,
                      color: linkColor,
                      // backgroundColor: linkColor.withOpacity(0.03),
                      radius: BorderRadius.circular(20),
                      size: 16,
                      onPress: () {
                        Get.to(EmptyWidget());
                      },
                    ),
                    const SizedBox(width: 20),
                    SecondaryButton(
                      title: "Calendar",
                      icon: const Icon(LineIcons.calendarCheck),
                      focus: false,
                      color: linkColor,
                      // backgroundColor: linkColor.withOpacity(0.03),
                      radius: BorderRadius.circular(20),
                      size: 16,
                      onPress: () {
                        Get.to(EmptyWidget());
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.start,
                children: listClassCard(),
              ),
            ],
          ),
        ),
      ),
      drawer: const SlideDrawer(),
    );
  }

  List<Widget> listClassCard() {
    List<Widget> list = [];

    var data = DataDummy();

    CardClass card;

    for (var i = 0; i < data.courses.length; i++) {
      card = CardClass(course: data.courses[i]);
      list.add(card);
    }

    return list;
  }
}

class ChoiseClassOption extends StatefulWidget {
  const ChoiseClassOption({Key? key}) : super(key: key);

  @override
  _ChoiseClassOptionState createState() => _ChoiseClassOptionState();
}

class _ChoiseClassOptionState extends State<ChoiseClassOption> {
  final _keyForm = GlobalKey<FormState>();

  var titleController = TextEditingController();

  var emailController = TextEditingController();

  String? titleInput;

  String? emailInput;

  String? aToken = '';

  int? id;

  String? username;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton(
          onPressed: () {
            Get.close(0);
            Get.defaultDialog(
              title: '',
              content: formInviteUser(),
            );
          },
          child: Text(
            "Invite user",
            style: blackTextFont.copyWith(fontSize: 18),
          ),
        ),
        const SizedBox(height: 20),
        TextButton(
          onPressed: () {
            Get.close(0);
            Get.defaultDialog(
              title: '',
              content: formCreateClass(),
            ).timeout(const Duration(seconds: 2));
          },
          child: Text(
            "Create class",
            style: blackTextFont.copyWith(fontSize: 18),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  void validateForm() {
    // final classC = Get.put(ClassController());
    // final userC = Get.find<UserController>();
    final form = _keyForm.currentState;

    if (form!.validate()) {
      form.save();

      // ClassService.classes();
      // ClassService().createNewClass(
      //   className: titleInput,
      // ).then((value) {
      //   print(value.headers);
      // });

      // classC.createClass(
      //   titleInput,
      //   aToken.toString(),
      // );
    }
  }

  Widget formCreateClass() {
    return Form(
      key: _keyForm,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Text(
              "Create class",
              style: blackTextFont.copyWith(fontSize: 18),
            ),
            InputField(
              hintText: 'New class name',
              labelText: 'Title',
              prefixIcon: Icon(LineIcons.edit, color: mainColor),
              userInputController: titleController,
              savedValue: (value) => titleInput = value!,
              validator: (value) =>
                  (value!.isEmpty) ? 'Please input title' : null,
            ),
            PrimaryButton(
              text: "Done",
              onPress: () {
                // setState(() {
                validateForm();
                // });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget formInviteUser() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Text(
            "Invite User",
            style: blackTextFont.copyWith(fontSize: 18),
          ),
          InputField(
            hintText: 'User email',
            labelText: 'Email',
            prefixIcon: Icon(LineIcons.edit, color: mainColor),
            userInputController: emailController,
            savedValue: (value) => emailInput = value!,
            validator: (value) => (value!.isEmpty)
                ? 'Please input your email'
                : (!GetUtils.isEmail(value))
                    ? 'Email invalid'
                    : null,
          ),
          PrimaryButton(
            text: "Done",
            onPress: () {},
          ),
        ],
      ),
    );
  }
}
