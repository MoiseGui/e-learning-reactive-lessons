part of 'pages.dart';

class RegisterPage extends StatefulWidget {
  // const RegisterPage({ Key? key }) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _keyForm = GlobalKey<FormState>();

  String? firstnameInput;

  String? lastnameInput;

  String? emailInput;

  String? passwordInput;

  String? confirmPasswordInput;

  bool securer = true;

  Icon iconSecure = Icon(LineIcons.eye, color: whiteColor);

  var firstnameController = TextEditingController();

  var lastnameController = TextEditingController();

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  var confirmPasswordController = TextEditingController();

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

  validateForm() {
    UserController userController = Get.put(UserController());
    final form = _keyForm.currentState;

    if (form!.validate()) {
      form.save();
      userController.registerUser(firstnameInput, lastnameInput, emailInput, passwordInput);
    }
  }

  @override
  Widget build(BuildContext context) {
    var sizeScreen = MediaQuery.of(context).size;

    return Scaffold(
      body: Responsive(
        desktop: desktop(),
        mobile: mobile(),
      ),
    );
  }

  Widget mobile() {
    return form();
  }

  Widget desktop({var screenWidth}) {
    var sizeScreen = MediaQuery.of(context).size;
    return Row(
      children: [
        Flexible(
          child: Container(
            height: sizeScreen.height,
            width: sizeScreen.width,
            child: Center(
              child: Image.asset(
                "assets/illus/Education-Illustration-Kit-01.png",
                height: sizeScreen.height * 0.8,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 40),
          child: form(screenWidth: sizeScreen.width * 0.3),
        ),
      ],
    );
  }

  form({double? screenWidth}) {
    return Form(
      key: _keyForm,
      child: Container(
        width: screenWidth,
        padding: const EdgeInsets.symmetric(
          horizontal: horizontalMargin,
        ),
        child: ListView(
          children: [
            const SizedBox(
              height: 40,
            ),
            Text(
              "Je m'inscris!",
              style: whiteTextFont.copyWith(
                fontSize: 24,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            InputField(
              hintText: '',
              labelText: 'Prénom',
              prefixIcon: Icon(LineIcons.user, color: whiteColor),
              userInputController: firstnameController,
              savedValue: (value) => firstnameInput = firstnameController.text,
              validator: (value) =>
                  (value!.isEmpty) ? 'Veuillez saisir votre prénom' : null,
            ),
            InputField(
              hintText: '',
              labelText: 'Nom',
              prefixIcon: Icon(LineIcons.user, color: whiteColor),
              userInputController: lastnameController,
              savedValue: (value) => lastnameInput = lastnameController.text,
              validator: (value) =>
              (value!.isEmpty) ? 'Veuillez saisir votre nom' : null,
            ),
            InputField(
              hintText: '',
              labelText: 'Email',
              prefixIcon: Icon(LineIcons.mailBulk, color: whiteColor),
              userInputController: emailController,
              savedValue: (value) => emailInput = emailController.text,
              validator: (value) => (value!.isEmpty)
                  ? 'Veuillez saisir votre address mail'
                  : (!GetUtils.isEmail(value))
                      ? 'Email invalide'
                      : null,
            ),
            InputField(
              hintText: 'Au moins 6 caractères.',
              labelText: 'Mot de passe',
              prefixIcon: Icon(LineIcons.lock, color: whiteColor),
              suffixIcon: GestureDetector(
                child: iconSecure,
                onTap: () => onTappedSuffixIcon(),
              ),
              secure: securer,
              userInputController: passwordController,
              savedValue: (value) => passwordInput = passwordController.text,
              validator: (value) => (value!.isEmpty)
                  ? 'Veuillez saisir un mot de passe'
                  : (value.length < 6)
                      ? 'Votre mot de passe doit avoir au moins 6 caractères'
                      : null,
              // onTapped: () => onTappedIcon(),
            ),
            InputField(
              hintText: 'Confirm your password',
              labelText: 'Confirm password',
              prefixIcon: Icon(LineIcons.lock, color: whiteColor),
              suffixIcon: GestureDetector(
                child: iconSecure,
                onTap: () => onTappedSuffixIcon(),
              ),
              secure: securer,
              userInputController: confirmPasswordController,
              savedValue: (value) =>
                  confirmPasswordInput = confirmPasswordController.text,
              validator: (value) => (value!.isEmpty)
                  ? 'Veuillez confirmer votre mot de passe'
                  : (value.compareTo(passwordController.text) != 0)
                  ? 'Les deux mots de passe doivent être identiques'
                  : null,
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
                  Text("M'enregister"),
                  Icon(Icons.arrow_forward),
                ],
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "J'ai déjà un compte ? ",
                  style: whiteTextFont.copyWith(),
                ),
                GestureDetector(
                  onTap: () {
                    Get.close(0);
                    Get.offAndToNamed("/login");
                  },
                  child: Text(
                    "Je me connecte",
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
