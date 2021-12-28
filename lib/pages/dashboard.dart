part of 'pages.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final _userController = Get.put(UserController());
  final _courseController = Get.put(CourseController());

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  openSlideDrawer() => _scaffoldKey.currentState!.openDrawer();

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

      _loading = false;
    });
  }

  Future<void> _initData() async {
    try {
      setState(() {
        _loading = true;
      });
      await _courseController.loadAllCourses();
      setState(() {
        myCourses = _courseController.courses;
        _loading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        _loading = false;
      });
    }
  }

  BigInt countViews(List<Course> courses) {
    BigInt views = BigInt.zero;
    courses.forEach((c) {
      views += c.numViews;
    });

    return views;
  }

  int countQuizzes(List<Course> courses) {
    int nbrQuizzes = 0;
    courses.forEach((c) {
      nbrQuizzes += c.quiz.length;
    });

    return nbrQuizzes;
  }

  String successRate(List<Course> courses) {
    String rate = "";
    int nbrGood = 0;
    int nbrWrong = 0;
    courses.forEach((c) {
      c.quiz.forEach((q) {
        q.responses.forEach((resp) {
          if (resp.correct)
            nbrGood++;
          else
            nbrWrong++;
        });
      });
    });

    if (nbrWrong + nbrGood == 0)
      rate = "N/A";
    else {
      var percent = BigInt.from((nbrGood / (nbrWrong + nbrGood)) * 100);
      rate = percent.toString() + "%";
    }

    return rate;
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
          "Tableau de bord",
        ),
        actions: [
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
          if (Responsive.isDesktop(context)) const SizedBox(width: 30),
          if (Responsive.isDesktop(context))
            Center(
              child:
                  // Obx(
                  //                 () =>
                  Text(
                "Hi, ${user.username} 👋",
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
            onRefresh: _initUserData,
            child: ListView(
              children: [
                const Text(
                  'TABLEAU DE BORD',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 15),
                Column(
                  children: [
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      alignment: WrapAlignment.start,
                      children: _loading
                          ? [
                              const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ]
                          : [
                              QuickLinkWidget(
                                icon: LineIcons.school,
                                value: myCourses.length.toString(),
                                text: "Cours",
                              ),
                              QuickLinkWidget(
                                icon: LineIcons.youtube,
                                value: countViews(myCourses).toString(),
                                text: "Vues",
                              ),
                              QuickLinkWidget(
                                icon: LineIcons.flask,
                                value: countQuizzes(myCourses).toString(),
                                text: "Quiz",
                              ),
                              QuickLinkWidget(
                                icon: LineIcons.chalkboard,
                                value: successRate(myCourses),
                                text: "Réussite",
                              ),
                            ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
