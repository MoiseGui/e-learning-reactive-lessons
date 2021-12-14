part of './pages/pages.dart';

class HomePage extends StatefulWidget {
  final String title;

  const HomePage({Key? key, required this.title}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _courseController = Get.put(CourseController());
  final _categoryController = Get.put(CategoryController());
  final _userController = Get.put(UserController());

  openSlideDrawer() => _scaffoldKey.currentState!.openDrawer();

  // controls the text label we use as a search bar
  final TextEditingController _filter = TextEditingController();

  String _searchText = "";

  List<Course> filteredCourses = []; // courses' titles filterd by search text

  Icon _searchIcon = const Icon(Icons.search, color: Colors.white);

  Widget? _appBarTitle;

  String? id = '';
  String? username = '';
  String? email = '';
  String? token = '';
  Gravatar? _gravatar;
  bool _loading = false;
  bool _loadingError = false;
  bool isLoggedIn = false;

  String _selectedCategoryId = '';

  getDataPref() async {
    _initData();
    _initUserData();

    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          filteredCourses = _courseController.courses;
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  Future<void> _initUserData() async {
    final _sharePref = await SharedPreferences.getInstance();
    setState(() {
      id = _sharePref.getString("id");
      email = _sharePref.getString("email");

      if (email != null && email != "") _gravatar = Gravatar(email!);

      username = _sharePref.getString("username");
      token = _sharePref.getString("token");

      if (token != null && !token.isBlank!) {
        isLoggedIn = true;
      } else {
        isLoggedIn = false;
      }
    });
  }

  Future<void> _initData() async {
    try {
      setState(() {
        _loading = true;
      });
      await _categoryController.loadAllCategories();
      await _courseController.loadAllCourses();
      setState(() {
        filteredCourses = _courseController.courses;
        _loadingError = false;
        _loading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        _loadingError = true;
        _loading = false;
      });
    }
  }

  void _clearStateAndStorage() async {
    _userController.logout();

    setState(() {
      id = '';
      username = '';
      email = '';
      token = '';
      isLoggedIn = false;
    });
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
                  _clearStateAndStorage();
                  Navigator.of(context).pop(true);
                },
                child: const Text('Oui, Je me déconnecte'),
              ),
            ],
          ),
        )) ??
        false;
  }

  void _searchPressed() {
    setState(() {
      if (_searchIcon.icon == Icons.search) {
        _searchIcon = const Icon(Icons.close, color: Colors.white);
        _appBarTitle = TextField(
          controller: _filter,
          decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search), hintText: 'Recherche...'),
        );
      } else {
        _searchIcon = const Icon(Icons.search, color: Colors.white);
        _appBarTitle = null;
        filteredCourses = _courseController.courses;
        _filter.clear();
      }
    });
  }

  Widget _buildSearchResultList() {
    if (_searchText.isNotEmpty) {
      List<Course> tempList = [];
      for (int i = 0; i < filteredCourses.length; i++) {
        if (filteredCourses[i]
            .title
            .toLowerCase()
            .contains(_searchText.toLowerCase())) {
          tempList.add(filteredCourses[i]);
        }
      }
      filteredCourses = tempList;
    }
    return ListView.builder(
      itemCount: filteredCourses.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(filteredCourses[index].title),
          onTap: () => {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      CourseDetail(course: filteredCourses[index])),
            )
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getDataPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // backgroundColor: bgColor,
      // drawer: const SlideDrawer(),
      appBar: AppBar(
        // backgroundColor: bgColor,
        elevation: 1,
        leading: null,
        title: _appBarTitle ??
            Text(
              widget.title,
              style: whiteTextFont,
            ),
        actions: [
          GestureDetector(
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Row(
                children: [
                  CircleAvatar(
                    child: _searchIcon,
                    backgroundColor: linkColor.withOpacity(0),
                  ),
                  if (Responsive.isDesktop(context)) const SizedBox(width: 5),
                  if (Responsive.isDesktop(context))
                    const Text("Rechercher un cours"),
                  if (Responsive.isDesktop(context)) const SizedBox(width: 40,)
                ],
              ),
            ),
            onTap: () {
              _searchPressed();
            },
          ),
          if (!isLoggedIn)
            GestureDetector(
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Row(
                  children: [
                    CircleAvatar(
                      child: LineIcon(LineIcons.userCircleAlt,
                          color: Colors.white, size: 35),
                      backgroundColor: linkColor.withOpacity(0.0),
                    ),
                    if (Responsive.isDesktop(context))
                      const SizedBox(width: 10),
                    if (Responsive.isDesktop(context))
                      const Text("Me connecter"),
                  ],
                ),
              ),
              onTap: () async {
                // Get.offAndToNamed("/login");
                await Get.toNamed("/login");
                _initUserData();
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
                "Hi, $username 👋",
                style: whiteTextFont.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              // ),
            ),
          if (isLoggedIn) const SizedBox(width: 16),
          if (isLoggedIn)
            GestureDetector(
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: CircleAvatar(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      _gravatar!.imageUrl(),
                    ),
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
      body: _searchIcon.icon != Icons.search
          ? _buildSearchResultList()
          : Scrollbar(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: RefreshIndicator(
                  onRefresh: _initData,
                  child: ListView(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: _loading ? [] : listCategoryCard(),
                        ),
                      ),
                      const SizedBox(height: 20),
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
                            : listCourseCard(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  List<Widget> listCategoryCard() {
    List<Widget> list = [
      SecondaryButton(
        title: "Tout",
        icon: const Icon(LineIcons.clipboardList),
        focus: false,
        color: linkColor,
        backgroundColor: _selectedCategoryId == ''
            ? linkColor.withOpacity(0.3)
            : linkColor.withOpacity(0),
        radius: BorderRadius.circular(20),
        size: 16,
        onPress: () {
          setState(() {
            _selectedCategoryId = '';
          });
          // Get.to(EmptyWidget());
        },
      ),
    ];

    for (var i = 0; i < _categoryController.categories.length; i++) {
      list.add(
        SecondaryButton(
          title: _categoryController.categories[i].title,
          icon: const Icon(LineIcons.clipboardList),
          focus: false,
          color: linkColor,
          backgroundColor: _selectedCategoryId
                      .compareTo(_categoryController.categories[i].id) ==
                  0
              ? linkColor.withOpacity(0.3)
              : linkColor.withOpacity(0),
          radius: BorderRadius.circular(20),
          size: 16,
          onPress: () {
            setState(() {
              _selectedCategoryId = _categoryController.categories[i].id;
            });
            // Get.to(EmptyWidget());
          },
        ),
      );
      // list.add(
      //   const SizedBox(width: 20),
      // );
    }

    return list.length > 1 ? list : [];
  }

  List<Widget> listCourseCard() {
    List<Widget> list = [];

    // var data = DataDummy();

    CourseCard card;

    for (var i = 0; i < _courseController.courses.length; i++) {
      if (_selectedCategoryId == '' ||
          _selectedCategoryId
                  .compareTo(_courseController.courses[i].categoryId) ==
              0) {
        card = CourseCard(course: _courseController.courses[i]);
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
