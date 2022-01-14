import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:elearning/controllers/controllers.dart';
import 'package:elearning/models/models.dart';
import 'package:elearning/shared/shared.dart';
import 'package:elearning/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:im_stepper/stepper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:video_player/video_player.dart';

import '../theme.dart';

class CourseFrom extends StatefulWidget {
  late final Course? course;

  CourseFrom({Key? key, this.course}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CourseFormState();
  }
}

class _CourseFormState extends State<CourseFrom> {
  // final TargetPlatform? _platform = TargetPlatform.android;
  final TargetPlatform? _platform = TargetPlatform.android;
  final CourseController _courseController = Get.find();
  final CategoryController _categoryController = Get.find();
  late VideoPlayerController _videoPlayerController1;
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  final _keyForm = GlobalKey<FormState>();
  final GlobalKey<FormState> _addQuizFormKey = GlobalKey<FormState>();

  bool _loading = true;

  String? title;
  String? description;
  String categoryId = "";
  List<String> paragraphs = [""];
  List<Quiz> quiz = [];

  bool loading = false;

  var catList = [];

  var _image;
  bool _imageError = false;
  var _video;
  bool _videoError = false;
  final picker = ImagePicker();

  prepareData() async {
    setState(() {
      loading = true;
    });
    await _categoryController.loadAllCategories();
    catList = _categoryController.categories;
    if (catList.isNotEmpty) categoryId = catList[0].id;
    // print(catList[0]);
    setState(() {
      loading = false;
    });
  }

  var titleController = TextEditingController();
  var descController = TextEditingController();
  var paragraphsController = TextEditingController();
  var quizQuestionController = TextEditingController();

  // THE FOLLOWING TWO VARIABLES ARE REQUIRED TO CONTROL THE STEPPER.
  int activeStep = 0; // Initial step set to 0.
  int upperBound = 2; // upperBound MUST BE total number of icons minus 1.

  Duration start = Duration.zero;
  Duration end = Duration.zero;

  @override
  void initState() {
    prepareData();
    super.initState();
  }

  @override
  void dispose() {
    try{
      if (_videoPlayerController1.value.isInitialized) {
        _videoPlayerController1.dispose();
      }
    }catch(e){
      // required to avoid errors
    }
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Ajouter un cours",
      theme: AppTheme.dark.copyWith(
        platform: _platform ?? Theme.of(context).platform,
      ),
      home: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            title: const Text("Ajouter un cours"),
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
            child: Column(
              children: [
                IconStepper(
                  icons: const [
                    Icon(Icons.list),
                    Icon(Icons.video_call),
                    Icon(Icons.dashboard_customize),
                  ],

                  enableNextPreviousButtons: false,
                  enableStepTapping: false,
                  activeStepColor: Colors.orangeAccent,
                  lineColor: Colors.orangeAccent,

                  // activeStep property set to activeStep variable defined above.
                  activeStep: activeStep,

                  // This ensures step-tapping updates the activeStep.
                  onStepReached: (index) {
                    setState(() {
                      activeStep = index;
                    });
                  },
                ),
                // header(),
                Expanded(
                  child: Form(
                    key: _keyForm,
                    child: ListView(
                      children: content(),
                    ),
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    previousButton(),
                    nextButton(),
                  ],
                ),
              ],
            ),
          )),
    );
  }

  List<Widget> content1() {
    return [
      InputField(
        hintText: 'Court et bien significatif',
        labelText: 'Titre',
        prefixIcon: Icon(LineIcons.textWidth, color: whiteColor),
        userInputController: titleController,
        savedValue: (value) => title = titleController.text,
        validator: (value) =>
            (value!.isEmpty) ? 'Veuillez saisir le titre du cours' : null,
      ),
      InputField(
        hintText: 'Aidez les utilisateurs à serner le sujet',
        labelText: 'Description',
        prefixIcon: Icon(LineIcons.textHeight, color: whiteColor),
        userInputController: descController,
        savedValue: (value) => description = descController.text,
        validator: (value) =>
            (value!.isEmpty) ? 'Veuillez saisir une description' : null,
        keyboardType: TextInputType.multiline,
        // minLines: 3,
        // maxLines: 5,
      ),
      const SizedBox(height: 40),
      loading
          ? const CircularProgressIndicator()
          : SelectField(
              labelText: "Choissisez une catégorie",
              categories: catList,
              onChange: (value) {
                setState(() {
                  categoryId = value!;
                });
              },
              value: categoryId,
            ),
      const SizedBox(height: 40),
      const Text(
        "Image de couverture",
        style: TextStyle(fontSize: 16),
      ),
      const SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton.icon(
              onPressed: () async => await _pickImage(),
              icon: const Icon(Icons.file_present),
              label: Text("Choisir",
                  style: TextStyle(fontSize: 16, color: whiteColor))),
          if (_image != null) Image.file(_image, width: 100),
        ],
      ),
      const SizedBox(height: 5),
      if (_imageError)
        Text("Vous devez choisir une image de couverture",
            style: TextStyle(fontSize: 14, color: errorColor)),
      const SizedBox(height: 10),
      InputField(
        hintText: 'Mettez du contenu texte à votre cours',
        labelText: 'Contenu',
        prefixIcon: Icon(LineIcons.textHeight, color: whiteColor),
        userInputController: paragraphsController,
        savedValue: (value) => paragraphs[0] = paragraphsController.text,
        // validator: (value) => (value!.isEmpty)
        //     ? 'Veuillez saisir une description'
        //     : null,
        keyboardType: TextInputType.multiline,
        minLines: 5,
        maxLines: 10,
      ),
      const SizedBox(height: 20),
    ];
  }

  List<Widget> content2() {
    return [
      const SizedBox(height: 30),
      if (_video != null)
        _videoPlayerController1.value.isInitialized
            ? AspectRatio(
                aspectRatio: _videoPlayerController1.value.aspectRatio,
                child: VideoPlayer(_videoPlayerController1),
              )
            : Container()
      else
        const Text(
          "A présent veuillez choisir la vidéo de votre cours.",
          style: TextStyle(fontSize: 18.0),
        ),
      const SizedBox(height: 30),
      ElevatedButton(
        onPressed: () {
          _pickVideo();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.video_call),
            Text(_video != null
                ? "Choisir une autre vidéo"
                : "Choisir une vidéo"),
          ],
        ),
      ),
      const SizedBox(height: 5),
      if (_videoError)
        Text("Vous devez choisir une vidéo pour ce cours",
            style: TextStyle(fontSize: 14, color: errorColor)),
    ];
  }

  List<Widget> content3() {
    return [
      SizedBox(
        height: Responsive.isDesktop(context) ? 500 : 200,
        child: Center(
          child: _chewieController != null &&
                  _chewieController!.videoPlayerController.value.isInitialized
              ? Chewie(
                  controller: _chewieController!,
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Text('Chargement en cours...'),
                  ],
                ),
        ),
      ),
      const SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text("Ajouter des quiz", style: TextStyle(fontSize: 18))
        ],
      ),
      const SizedBox(height: 10),
      ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            color: const Color(0xFF222222),
          ),
          // color: const Color(0xFF222222),
          // width: Responsive.isDesktop(context) ? 200 : 150,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          _saveCurentTime(true);
                        },
                        child: Row(
                          children: const [
                            Icon(Icons.not_started_outlined),
                            SizedBox(width: 5),
                            Text("Début")
                          ],
                        )),
                    ElevatedButton(
                        onPressed: () {
                          _saveCurentTime(false);
                        },
                        child: Row(
                          children: const [
                            Icon(Icons.restart_alt_outlined),
                            Text("Fin")
                          ],
                        )),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_formatDuration(start)),
                    Text(_formatDuration(end)),
                  ],
                ),
                const SizedBox(height: 10),
                if (canShowAddQuizButton())
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            _showQuizFormDialog(start, end, null);
                          },
                          child:
                              const Text("Ajouter un Quiz pour cet interval"))
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
      if (quiz.isEmpty)
        Column(
          children: const [
            SizedBox(height: 30),
            Text("Vous pouvez aussi enregistrer ce cours sans aucun quiz",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.orangeAccent))
          ],
        ),
      if (quiz.isNotEmpty)
        Column(
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text("Les quiz ajoutés", style: TextStyle(fontSize: 18))
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  color: const Color(0xFF222222),
                ),
                // color: const Color(0xFF222222),
                // width: Responsive.isDesktop(context) ? 200 : 150,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: _renderQuizList(),
                  ),
                ),
              ),
            ),
          ],
        ),
    ];
  }

  List<Widget> _renderQuizList() {
    List<Widget> list = [];

    for (int i = 0; i < quiz.length; i++) {
      list.add(Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(quiz[i].question.length <= 30
                      ? quiz[i].question
                      : quiz[i].question.substring(0, 30) + "..."),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_formatDuration(quiz[i].beginTime)),
                      const Text(" - "),
                      Text(_formatDuration(quiz[i].endTime)),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        setState(() {
                          quiz.remove(quiz[i]);
                        });
                      },
                      icon: Icon(Icons.delete, color: errorColor)),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          _showQuizFormDialog(null, null, quiz[i]);
                        });
                      },
                      icon: const Icon(Icons.edit, color: Colors.orangeAccent)),
                ],
              )
            ],
          ),
          // const SizedBox(height: 5),
          const Divider(),
        ],
      ));
    }

    return list;
  }

  _showQuizFormDialog(Duration? beginTime, Duration? endTime, Quiz? quizToEdit) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
          var choiceTextController = TextEditingController();
          bool showChoiceForm = false;
          bool _saveError = false;
          bool _coorectCountError = false;
          Choice choiceToAdd = Choice("", false, 0);
          Quiz currentQuiz;

          if (quizToEdit != null) {
            currentQuiz = Quiz(
                quizToEdit.question,
                quizToEdit.beginTime,
                quizToEdit.endTime,
                quizToEdit.uniqueChoice,
                quizToEdit.choices, []);
            quizQuestionController.text = currentQuiz.question;
          } else {
            currentQuiz = Quiz("", beginTime!, endTime!, true, [], []);
          }

          _addChoice() {
            currentQuiz.choices.add(Choice(choiceToAdd.text,
                choiceToAdd.correct, currentQuiz.choices.length+1));
            choiceToAdd.text = "";
            choiceTextController.text = "";
            choiceToAdd.correct = false;
            showChoiceForm = false;
            _saveError = false;
          }

          List<Widget> _renderChoices(setState) {
            List<Widget> list = [];

            for (int i = 0; i < currentQuiz.choices.length; i++) {
              Choice choice = currentQuiz.choices[i];
              list.add(Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                          value: choice.correct,
                          onChanged: (value) {
                            setState(() {
                              choice.correct = value!;
                            });
                          }),
                      const SizedBox(width: 10),
                      Text(choice.text.length > 15
                          ? choice.text.substring(0, 14) + "..."
                          : choice.text),
                    ],
                  ),
                  IconButton(
                      alignment: Alignment.centerRight,
                      onPressed: () {
                        setState(() {
                          currentQuiz.choices.remove(choice);
                        });
                      },
                      icon: const Icon(Icons.delete, color: Colors.redAccent))
                ],
              ));
            }

            return list;
          }

          _handleSave(setStateIntern) {
            if (_addQuizFormKey.currentState!.validate()) {
              _addQuizFormKey.currentState!.save();
              if (currentQuiz.question.isNotEmpty &&
                  currentQuiz.choices.length > 1) {
                // check if it's a single choice question or not
                int correctCount = 0;

                for (int i = 0; i < currentQuiz.choices.length; i++) {
                  if (currentQuiz.choices[i].correct) correctCount++;
                }

                if (correctCount == 0) {
                  setStateIntern(() {
                    _coorectCountError = true;
                  });
                  return;
                }

                if (correctCount > 1) currentQuiz.uniqueChoice = false;

                quizQuestionController.text = "";
                setState(() {
                  if (quizToEdit == null) {
                    quiz.add(currentQuiz);
                  } else {
                    quizToEdit.question = currentQuiz.question;
                    quizToEdit.uniqueChoice = currentQuiz.uniqueChoice;
                    quizToEdit.choices = currentQuiz.choices;
                    // = Quiz(
                    //     'currentQuiz.question',
                    //     currentQuiz.beginTime,
                    //     currentQuiz.endTime,
                    //     currentQuiz.uniqueChoice,
                    //     currentQuiz.choices, []);
                  }
                  Get.close(0);
                });
              } else {
                setStateIntern(() {
                  _saveError = true;
                });
              }
            }
          }

          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              content: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return Stack(
                  overflow: Overflow.visible,
                  children: <Widget>[
                    Form(
                      key: _addQuizFormKey,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const Text("Ajout d'un quiz",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            InputField(
                              hintText: 'La question de ce quiz',
                              labelText: 'Question',
                              prefixIcon:
                                  Icon(LineIcons.textWidth, color: whiteColor),
                              userInputController: quizQuestionController,
                              savedValue: (value) => currentQuiz.question =
                                  quizQuestionController.text,
                              validator: (value) => (value!.isEmpty)
                                  ? 'Veuillez saisir la question du quiz'
                                  : null,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  showChoiceForm = !showChoiceForm;
                                });
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(showChoiceForm
                                      ? Icons.cancel_outlined
                                      : Icons.add),
                                  const SizedBox(width: 10),
                                  Text(showChoiceForm
                                      ? "Annuler le choix"
                                      : "Ajouter un choix"),
                                ],
                              ),
                            ),
                            if (_saveError)
                              Text(
                                  "La question et ses choix (2 min) sont obligatoires",
                                  style: TextStyle(
                                      color: errorColor, fontSize: 14)),
                            if (_coorectCountError)
                              Text(
                                  "Vous n'avez ajouté aucune réponse correcte.",
                                  style: TextStyle(
                                      color: errorColor, fontSize: 14)),
                            if (showChoiceForm)
                              ClipRRect(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(5.0)),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    color: const Color(0xFF222222),
                                  ),
                                  // color: const Color(0xFF222222),
                                  // width: Responsive.isDesktop(context) ? 200 : 150,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Form(
                                      key: _formKey,
                                      child: Column(
                                        children: [
                                          const Text("Un nouveau choix",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                          InputField(
                                            hintText: 'Le texte de ce choix',
                                            labelText: 'Texte',
                                            prefixIcon: Icon(
                                                LineIcons.textWidth,
                                                color: whiteColor),
                                            userInputController:
                                                choiceTextController,
                                            savedValue: (value) =>
                                                choiceToAdd.text =
                                                    choiceTextController.text,
                                            validator: (value) => (value!
                                                    .isEmpty)
                                                ? 'Veuillez saisir le texte de ce choix'
                                                : null,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Checkbox(
                                                  value: choiceToAdd.correct,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      choiceToAdd.correct =
                                                          value!;
                                                    });
                                                  }),
                                              const SizedBox(width: 10),
                                              const Text("Bonne réponse"),
                                            ],
                                          ),
                                          SizedBox(
                                            width: 150,
                                            child: ElevatedButton(
                                                onPressed: () {
                                                  if (_formKey.currentState!
                                                      .validate()) {
                                                    _formKey.currentState!
                                                        .save();
                                                    setState(() {
                                                      _addChoice();
                                                    });
                                                  }
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: const [
                                                    Icon(Icons.arrow_forward),
                                                    SizedBox(width: 10),
                                                    Text("Ajouter")
                                                  ],
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            if (currentQuiz.choices.isNotEmpty)
                              ClipRRect(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(5.0)),
                                child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      color: const Color(0xFF222222),
                                    ),
                                    // color: const Color(0xFF222222),
                                    // width: Responsive.isDesktop(context) ? 200 : 150,
                                    child: Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Column(
                                        children: _renderChoices(setState),
                                      ),
                                    )),
                              ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.orange)),
                                    onPressed: () {
                                      Get.close(0);
                                    },
                                    child: Row(
                                      children: const [
                                        Icon(Icons.cancel),
                                      ],
                                    )),
                                ElevatedButton(
                                    onPressed: () {
                                      _handleSave(setState);
                                    },
                                    child: Row(
                                      children: const [
                                        Icon(Icons.save),
                                        SizedBox(width: 5),
                                        Text("Enregistrer"),
                                      ],
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }));
        });
  }

  _handleAddCourse() async{
    setState(() {
      _loading = true;
    });

    Course course = Course("", "", BigInt.zero, title!, description!, "", "", categoryId, "", paragraphs, quiz);

    // print("BEGIN");
    DialogController()
        .conditionnalDialog("Envoi en cours","Veuillez patienter, Ceci peut prendre du temps en fonction de la taille de vos fichiers.");
    await _courseController.addCourse(course, _image, _video, (){
      Get.close(0);
      setState(() {
        _loading = false;
      });
    });
    // print("END");

  }

  /// Returns the next button.
  Widget nextButton() {
    return ElevatedButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
              activeStep == 2 ? Colors.green : Colors.orange)),
      onPressed: () {
        // make the button not work if already submitting
        // if(_loading) return;

        if(activeStep == 2){
          _handleAddCourse();
          return;
        }

        // Increment activeStep, when the next button is tapped. However, check for upper bound.
        if (activeStep < upperBound) {
          setState(() {
            validateForm();
          });
          if (activeStep == 1 &&
              _video != null &&
              _videoPlayerController1.value.isInitialized) {
            _videoPlayerController1.play();
          }
          if (activeStep == 2) initializePlayer();
        }
      },
      child: Row(
        children: [
          Text(activeStep == 2 ? "Enregistrer" : "Suivant"),
          if (activeStep == 2) const SizedBox(width: 2),
          Icon(activeStep == 2 ? Icons.save : Icons.arrow_forward),
        ],
      ),
    );
  }

  /// Returns the previous button.
  Widget previousButton() {
    return ElevatedButton(
      onPressed: () {
        // Decrement activeStep, when the previous button is tapped. However, check for lower bound i.e., must be greater than 0.
        if (activeStep == 1 &&
            _video != null &&
            _videoPlayerController1.value.isInitialized) {
          _videoPlayerController1.pause();
        }
        if (activeStep > 0) {
          setState(() {
            activeStep--;
          });
          if (activeStep == 1 &&
              _video != null &&
              _videoPlayerController1.value.isInitialized) {
            _videoPlayerController1.play();
          }
        } else {
          Get.close(0);
        }
      },
      child: Row(
        children: [
          const Icon(Icons.arrow_back),
          Text(activeStep == 0 ? "Quitter" : "Retour"),
        ],
      ),
    );
  }

  /// Returns the header wrapping the header text.
  Widget header() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.3),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              headerText(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Returns the header text based on the activeStep.
  String headerText() {
    switch (activeStep) {
      case 1:
        return 'La vidéo';

      case 2:
        return 'Ajouter des quiz';

      default:
        return 'Informations générales';
    }
  }

  List<Widget> content() {
    switch (activeStep) {
      case 1:
        return content2();

      case 2:
        return content3();

      default:
        return content1();
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  _saveCurentTime(bool begin) {
    if (_videoPlayerController != null &&
        _videoPlayerController!.value.isInitialized) {
      _videoPlayerController!.pause();
      Duration d = _videoPlayerController!.value.position;
      setState(() {
        if (begin) {
          start = d;
        } else {
          end = d;
        }
      });
    }
  }

  bool canShowAddQuizButton() {
    if (end.compareTo(Duration.zero) == 0 || end.compareTo(start) <= 0) {
      return false;
    }
    if (quiz.isNotEmpty) {
      if (quiz
          .where((element) => element.endTime.compareTo(end) == 0)
          .isNotEmpty) {
        return false;
      }
    }
    return true;
  }

  void validateForm() {
    // UserController userController = Get.find();
    // APIService apiService = Get.put(APIService());

    switch (activeStep) {
      case 0:
        {
          final form = _keyForm.currentState;

          bool isFormValid = form!.validate();

          if (_image == null) {
            isFormValid = false;
            _imageError = true;
            return;
          } else {
            _imageError = false;
          }

          if (isFormValid) {
            form.save();
            title = titleController.text;
            activeStep++;
          }
          break;
        }
      case 1:
        {
          if (_video == null) {
            _videoError = true;
            return;
          } else {
            _videoError = false;
            if (_videoPlayerController1.value.isInitialized) {
              _videoPlayerController1.pause();
            }
            activeStep++;
          }
          break;
        }
      default:
        break;
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  // This funcion will helps you to pick a Video File
  Future<void> _pickVideo() async {
    PickedFile? pickedFile = await picker.getVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      _video = File(pickedFile.path);
      try {
        if (_videoPlayerController1.value.isInitialized) {
          _videoPlayerController1.dispose();
        }
      } catch (e) {
        // this try catch bock fixes the bug of old selected video playing in
        // background when switch off to another app and switch back to the app
      }
      _videoPlayerController1 = VideoPlayerController.file(_video)
        ..initialize().then((_) {
          setState(() {});
          _videoPlayerController1.play();
        });
    }
  }

  Future<void> initializePlayer() async {
    if (!_videoPlayerController1.value.isInitialized ||
        _chewieController == null) {
      _videoPlayerController = VideoPlayerController.file(_video)
        ..initialize().then((_) {
          setState(() {});
        });
      _videoPlayerController?.addListener(
        () {},
      );
      _createChewieController();
      setState(() {});
    }
  }

  void _createChewieController() {
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController!,

      autoPlay: false,
      looping: false,
      // Try playing around with some of these other options:

      // showControls: false,
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.red,
        handleColor: Colors.blue,
        backgroundColor: Colors.grey,
        bufferedColor: Colors.lightGreen,
      ),
      // placeholder: Container(
      //   color: Colors.grey,
      // ),
      // autoInitialize: true,
    );
  }
}
