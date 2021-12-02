part of 'pages.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _keyForm = GlobalKey<FormState>();

  String? emailInput;
  String? passwordInput;

  bool securer = true;
  Icon iconSecure = Icon(LineIcons.eye, color: whiteColor);

  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  _checkIfLoggedIn() async {
    final _sharePref = await SharedPreferences.getInstance();
    String? id = _sharePref.getString("id");
    if(id != null) Navigator.of(context).pop(true);
  }

  @override
  void initState() {
    _checkIfLoggedIn();
    super.initState();
  }

  void onTappedSuffixIcon() {
    if (securer == true) {
      setState(() {
        securer = false;
        iconSecure = Icon(
          LineIcons.eyeSlash,
          color: whiteColor,
        );
      });
    } else {
      setState(() {
        securer = true;
        iconSecure = Icon(
          LineIcons.eye,
          color: whiteColor,
        );
      });
    }
  }

  void validateForm() {
    UserController userController = Get.put(UserController());
    // APIService apiService = Get.put(APIService());

    final form = _keyForm.currentState;

    if (form!.validate()) {
      form.save();

      userController.userLogin(emailInput, passwordInput);
      // apiService.login(email: emailInput, password: passwordInput);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: bgColor,
      body: Responsive(
        desktop: desktop(),
        mobile: mobile(),
      ),
    );
  }

  Widget desktop() {
    var sizeScreen = MediaQuery.of(context).size;
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 30),
          child: form(screenWidth: sizeScreen.width * 0.3),
        ),
        Flexible(
          child: Container(
            height: sizeScreen.height,
            width: sizeScreen.width,
            child: Center(
              child: Image.asset(
                "assets/illus/Education-Illustration-Kit-09.png",
                height: sizeScreen.height * 0.8,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // TODO : mobile()
  Widget mobile() {
    return form();
  }

  form({double? screenWidth}) {
    return Form(
      key: _keyForm,
      child: Container(
        width: screenWidth,
        margin: const EdgeInsets.symmetric(
          horizontal: horizontalMargin,
        ),
        child: ListView(
          children: [
            const SizedBox(
              height: 50,
            ),
            Text(
              "Bienvenue, Merci de rendre l'éducation plus amusant!",
              style: whiteTextFont.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 54,
            ),
            InputField(
              hintText: '',
              labelText: 'Email',
              prefixIcon: Icon(LineIcons.mailBulk, color: whiteColor),
              userInputController: emailController,
              savedValue: (value) => emailInput = value!,
              validator: (value) => (value!.isEmpty)
                  ? 'Veuillez saisir votre adresse mail !'
                  : (!GetUtils.isEmail(value))
                      ? 'Email invalide'
                      : null,
            ),
            InputField(
              hintText: '',
              labelText: 'Mot de passe',
              prefixIcon: Icon(LineIcons.lock, color: whiteColor),
              suffixIcon: GestureDetector(
                child: iconSecure,
                onTap: () => onTappedSuffixIcon(),
              ),
              secure: securer,
              userInputController: passwordController,
              savedValue: (value) => passwordInput = value!,
              validator: (value) => (value!.isEmpty)
                  ? 'Veuillez saisir votre mot de passe'
                  : (value.length < 6)
                      ? 'Votre mot de passe doit avoir au moins 6 caractères'
                      : null,
              // onTapped: () => onTappedIcon(),
            ),
            Container(
              alignment: Alignment.centerRight,
              margin: const EdgeInsets.only(top: 5),
              child: Text(
                'Mot de passe oublié ?',
                style: whiteTextFont.copyWith(),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            FloatingActionButton.extended(
              elevation: 0,
              backgroundColor: linkColor,
              splashColor: whiteColor,
              onPressed: () {
                setState(() {
                  validateForm();
                });
              },
              label: Row(
                children: const [
                  Text("Me connecter"),
                  Icon(Icons.arrow_forward),
                ],
              ),
            ),
            const SizedBox(
              height: 70,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Pas encore inscrit ? ',
                  style: whiteTextFont.copyWith(),
                ),
                GestureDetector(
                  onTap: () {
                    // Get.close(0);
                    // Get.offAndToNamed("/register");
                    Get.toNamed("/register");
                  },
                  child: Text(
                    'Je m\'inscris',
                    style: linkTextFont.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}
