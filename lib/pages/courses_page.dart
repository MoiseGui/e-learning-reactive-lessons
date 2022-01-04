part of 'pages.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({Key? key}) : super(key: key);

  @override
  _CoursesPageState createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  final UserController _userController = Get.find();
  final CourseController _courseController = Get.find();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  openSlideDrawer() => _scaffoldKey.currentState!.openDrawer();

  // String? id = '';
  // String? id = '';
  // String? username = '';
  // String? email = '';
  // String? token = '';
  Gravatar? _gravatar;
  bool _loading = false;
  var user;
  List<Course> myCourses = [];

  Future<void> _initUserData() async {
    setState(() {
      _loading = true;
    });
    user = await AuthService().checkAuth(miniMumRole: ROLE_PROFESSEUR);

    setState(() {
      if (user.email != null && user.email != "") {
        _gravatar = Gravatar(user.email);
      }
      _loading = true;
    });
  }

  Future<void> _initData() async {
    try {
      setState(() {
        _loading = true;
      });
      await _courseController.loadAllCourses();
      setState(() {
        myCourses = _courseController.myCourses;
        _loading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    _initUserData();
    _initData();
  }

  Future<bool> _logout() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Êtes vous sûr ?'),
            content: const Text('Voulez vous vraiment vous déconnecter ?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Non'),
              ),
              TextButton(
                onPressed: () {
                  _userController.logout();
                  Navigator.of(context).pop(true);
                  Get.close(0);
                  Get.toNamed(RouteName.home);
                },
                child: const Text('Oui, Je me déconnecte'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const SlideDrawer(),
      appBar: AppBar(
        // backgroundColor: bgColor,
        elevation: 1,
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
            },
          ),
        ),
        title: const Text(
          "Mes cours",
        ),
        actions: [
          GestureDetector(
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: LineIcon(LineIcons.plus, color: Colors.white),
            ),
            onTap: () async {
              // Get.defaultDialog(
              // title: '',
              // content: const ChoiseClassOption(),
              // );
              await Get.to(CourseFrom());
              _initData();
            },
          ),
          if (Responsive.isDesktop(context)) const SizedBox(width: 30),
          if (Responsive.isDesktop(context))
            Center(
              child:
                  // Obx(
                  //                 () =>
                  Text(
                "Hi, ${user!.username ?? ''} 👋",
                style: whiteTextFont.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              // ),
            ),
          const SizedBox(width: 16),
          GestureDetector(
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: CircleAvatar(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: !_loading
                      ? Image.network(
                          _gravatar!.imageUrl(),
                        )
                      : null,
                ),
                backgroundColor: Colors.grey,
              ),
            ),
            onTap: () {
              _logout();
            },
          ),
          const SizedBox(width: 24),
        ],
      ),
      body: Scrollbar(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: RefreshIndicator(
            onRefresh: _initData,
            child: ListView(
              children: [
                Text(
                  'AU TOTAL ' + myCourses.length.toString() + ' COURS',
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 15),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  alignment: WrapAlignment.start,
                  children: _loading
                      ? [
                          const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ]
                      : listCourseCard(myCourses),
                ),
                // Column(
                //   children: listCourseCard(),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> listCourseCard(courses) {
    List<Widget> list = [];

    // var data = DataDummy();

    CourseCell card;

    if (courses != null) {
      for (var i = 0; i < courses.length; i++) {
        card = CourseCell(
            course: courses[i],
            onTap: () async {
              await _showDialog(context, courses[i]);
              _initData();
            });
        list.add(card);
      }
    }

    if (list.isEmpty) {
      list = [
        Column(
          children: [
            const SizedBox(height: 30),
            const Center(
              child: Text(
                "Aucun cours pour le moment.",
                style: TextStyle(fontSize: 20),
              ),
            ),
            const Center(
              child: Text("Tirez vers le bas pour rafraichir."),
            ),
            const SizedBox(height: 20),
            Image.asset(
              "assets/illus/noData.png",
              height: 300,
            ),
          ],
        )
      ];
    }

    return list;
  }

  String successRate(Course course) {
    String rate = "";
    int nbrGood = 0;
    int nbrWrong = 0;

    course.quiz.forEach((q) {
      q.responses.forEach((resp) {
        if (resp.correct) {
          nbrGood++;
        } else {
          nbrWrong++;
        }
      });
    });

    if (nbrWrong + nbrGood == 0) {
      rate = "N/A";
    } else {
      var percent = BigInt.from((nbrGood / (nbrWrong + nbrGood)) * 100);
      rate = percent.toString() + "%";
    }

    return rate;
  }

  _showDialog(context, Course course) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            content: SizedBox(
              height: 500,
              child: Stack(
                children: [
                  ListView(
                    children: [
                      Text(
                        course.title,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(height: 5),
                      const Divider(
                        height: 15.0,
                        color: Colors.grey,
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Wrap(
                            spacing: 5,
                            runSpacing: 5,
                            alignment: WrapAlignment.start,
                            children: [
                              SingleCourseStatWidget(
                                icon: LineIcons.youtube,
                                value: course.numViews.toString(),
                                text: "Vues",
                              ),
                              SingleCourseStatWidget(
                                icon: LineIcons.flask,
                                value: course.quiz.length.toString(),
                                text: "Quiz",
                              ),
                              SingleCourseStatWidget(
                                icon: LineIcons.chalkboard,
                                value: successRate(course),
                                text: "Réussite",
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 20),
                            fixedSize: Responsive.isDesktop(context)
                                ? const Size.fromWidth(308)
                                : const Size.fromWidth(400),
                            primary: linkColor,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)))),
                        child: const Text("Modifier ce cours"),
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
                      if (Responsive.isDesktop(context)) const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 20),
                            fixedSize: Responsive.isDesktop(context)
                                ? const Size.fromWidth(308)
                                : const Size.fromWidth(400),
                            primary: errorColor,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)))),
                        child: const Text("Supprimer ce cours"),
                        onPressed: () {

                        },
                      ),
                      if (Responsive.isDesktop(context)) const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 20),
                            fixedSize: Responsive.isDesktop(context)
                                ? const Size.fromWidth(308)
                                : const Size.fromWidth(400),
                            primary: warningColor2,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)))),
                        child: const Text("Retour"),
                        onPressed: () {
                          Get.close(0);
                          // Get.to(CourseDetail(title: title.toString()));
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
