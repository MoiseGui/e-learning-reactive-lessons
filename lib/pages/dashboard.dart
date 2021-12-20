part of 'pages.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final _userController = Get.put(UserController());

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  openSlideDrawer() => _scaffoldKey.currentState!.openDrawer();

  String? id = '';
  String? username = '';
  String? email = '';
  String? token = '';
  Gravatar? _gravatar;
  bool _loading = false;

  Future<void> _initUserData() async {
    _loading = true;
    final _sharePref = await SharedPreferences.getInstance();
    setState(() {
      id = _sharePref.getString("id");
      email = _sharePref.getString("email");

      if (email != null && email != "") _gravatar = Gravatar(email!);

      username = _sharePref.getString("username");
      token = _sharePref.getString("token");

      if (token == null || token.isBlank!) {
        Get.close(1);
        Get.toNamed(RouteName.home);
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
                "Hi, $username 👋",
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
                  child: !_loading ? Image.network(
                    _gravatar!.imageUrl(),
                  ) : null,
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
                      children: const [
                        QuickLinkWidget(icon: LineIcons.school, value: "204", text: "Cours",),
                        QuickLinkWidget(icon: LineIcons.youtube, value: "20103", text: "Vues",),
                        QuickLinkWidget(icon: LineIcons.flask, value: "387", text: "Quiz",),
                        QuickLinkWidget(icon: LineIcons.chalkboard, value: "87%", text: "Réussite",),
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
