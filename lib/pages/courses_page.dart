part of 'pages.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({Key? key}) : super(key: key);

  @override
  _CoursesPageState createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  final _userController = Get.put(UserController());

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

  Future<void> _initUserData() async {
    _loading = true;
    user = await AuthService().checkAuth(miniMumRole: ROLE_PROFESSEUR);
    setState(() {
      if (user == null) {
        print("User not connected");
        Get.offNamed(RouteName.loginPage);
      }

      if (user.email != null && user.email != "") {
        _gravatar = Gravatar(user.email);
      }

      _loading = false;
    });
  }

  @override
  void initState() {
    _initUserData();
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
                  'AU TOTAL 12',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 15),
                Column(
                  children: <Widget>[
                    CourseCell(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _imageView() {
    return Container(
      height: 250.0,
      width: double.infinity,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              width: 4.0,
              color: Colors.transparent,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x22000000),
                blurRadius: 10.0,
                spreadRadius: 10.0,
              ),
            ],
            borderRadius: const BorderRadius.all(const Radius.circular(125.0)),
          ),
          width: 250.0,
          height: 250.0,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(const Radius.circular(120.0)),
            child: Image.asset('assets/illus/Education Illustration Kit-06.png'),
          ),
        ),
      ),
    );
  }
}
