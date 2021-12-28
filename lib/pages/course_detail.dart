part of 'pages.dart';

class CourseDetail extends StatefulWidget {
  final Course course;

  const CourseDetail({Key? key, required this.course}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CourseDetailState();
  }
}

class _CourseDetailState extends State<CourseDetail> {
  // final TargetPlatform? _platform = TargetPlatform.android;
  final TargetPlatform? _platform = TargetPlatform.iOS;
  final CourseController _courseController = Get.find();
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final QuizService _quizService;

  Duration? quizToRedoPosition;

  List<int> respondedQuizzes = [];

  @override
  void initState() {
    super.initState();
    initializePlayer();
    _quizService = QuizService(widget.course.quiz);
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  Future<void> initializePlayer() async {
    // Youtube video converter has a problem on web version: To fix later
    var dataSource = await YoutubeUtils.extractVideoUrl(widget.course.video);
    if (dataSource == '') {
      dataSource =
          "https://assets.mixkit.co/videos/preview/mixkit-daytime-city-traffic-aerial-view-56-large.mp4";
    }
    _videoPlayerController = VideoPlayerController.network(dataSource);
    await Future.wait([
      _videoPlayerController.initialize(),
    ]);
    _videoPlayerController.addListener(
      () {
        //custom Listner
        _controlVideo(_videoPlayerController.value.position);
      },
    );
    _createChewieController();
    setState(() {});
    _courseController.updateCoursesViews(widget.course.id);
  }

  void _createChewieController() {
    final subtitles = [
      Subtitle(
        index: 0,
        start: Duration.zero,
        end: const Duration(seconds: 10),
        text: 'Hello from subtitles',
      ),
      Subtitle(
        index: 0,
        start: const Duration(seconds: 10),
        end: const Duration(seconds: 20),
        text: 'Whats up? :)',
      ),
    ];

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,

      autoPlay: true,
      looping: false,

      // subtitle: Subtitles(subtitles),
      subtitleBuilder: (context, dynamic subtitle) => Container(
        padding: const EdgeInsets.all(5.0),
        decoration: const BoxDecoration(color: Colors.green),
        child: Text(
          subtitle.toString(),
          style: const TextStyle(color: Colors.white),
        ),
      ),

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

  _continuePlaying() {
    _videoPlayerController.play();
  }

  _goBackTo(Duration duration) {
    _videoPlayerController.seekTo(duration);
    // print("player seeked to: ${_videoPlayerController.position}");
    // _continuePlaying();
  }

  _continuePlayingFrom(Duration beginTime, Duration endTime) {
    _goBackTo(beginTime);
    _continuePlaying();
    Future.delayed(const Duration(milliseconds: 1000), () {
      // Do something
      quizToRedoPosition = Duration(seconds: endTime.inSeconds);
      // print("hehe: " + quizToRedoPosition.toString());
    });
  }

  _controlVideo(position) async {
    // print("Video track " + position.toString());
    // print("Quiz to redo $quizToRedoPosition");
    Quiz? quiz;
    if (quizToRedoPosition != null &&
        _quizService.compareDurations(quizToRedoPosition!, position) == 0) {
      quiz = _quizService.getQuizByMoment(position, false);
      quizToRedoPosition = null;
    } else {
      quiz = _quizService.getQuizByMoment(position, true);
    }
    if (quiz != null) {
      // print("FOUND");
      _videoPlayerController.pause();
      _showDialog(context, quiz);
    }
  }

  _showDialog(context, Quiz quiz) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          List<int> _selectedValues;
          if(quiz.uniqueChoice) {
            // Choix unique, la valeur à l'indice 0 indique l'élément séléctionné
            _selectedValues = List.filled(1, 0);
          } else {
            // Choix multiple, la valeur à l'indice i représente l'état du checkbox correspondant
            _selectedValues = List.filled(quiz.choices.length, 0);
          }
          // représente ce que le user veut faire ensuite:
          // 0 retry, -1: rewatch, 1: correct answer
          int result = 0;

          _validateResult() {
            switch (result) {
              case 1:
                {
                  Navigator.of(context).pop();
                  _continuePlaying();
                  break;
                }
              case -1:
                {
                  _continuePlayingFrom(quiz.beginTime, quiz.endTime);
                  Navigator.of(context).pop();
                  break;
                }
              default:
                break;
            }
          }

          _handleSubmit() async {
            bool success = true;
            if(quiz.uniqueChoice) {
              if(_selectedValues[0] <= 0 || !quiz.findChoiceByOrder(_selectedValues[0]).correct) {
                success = false;
              }
            }else{
              for(int i = 0; i < _selectedValues.length; i++){
                int realValue = quiz.findChoiceByOrder(i+1).correct ? 1 : 0;
                if(_selectedValues[i] != realValue) {success = false;
                break;
                }
              }
            }

            if(!respondedQuizzes.contains(quiz.beginTime.inMilliseconds)){
              _courseController.courseRespond(widget.course.id, quiz.beginTime, success);
              respondedQuizzes.add(quiz.beginTime.inMilliseconds);
            }

            if (success) {
              Dialogs.bottomMaterialDialog(
                  color: mainColor2,
                  msg: 'Tu peux à présent continuer',
                  title: 'Bien joué',
                  context: context,
                  actions: [
                    IconsButton(
                      onPressed: () {
                        result = 1;
                        Navigator.of(context).pop();
                        _validateResult();
                      },
                      text: 'Continuer',
                      iconData: Icons.done,
                      color: Colors.blue,
                      textStyle: const TextStyle(color: Colors.white),
                      iconColor: Colors.white,
                    ),
                  ]);
            } else {
              Dialogs.bottomMaterialDialog(
                  color: mainColor2,
                  msg: "Malheuresement vous n'avez pas choisi la bonne réponse",
                  title: 'Mauvaise réponse',
                  context: context,
                  actions: [
                    IconsOutlineButton(
                      onPressed: () {
                        result = 0;
                        Navigator.of(context).pop();
                        _validateResult();
                      },
                      text: 'Réessayer',
                      iconData: Icons.compare_arrows,
                      textStyle: TextStyle(color: Colors.grey),
                      iconColor: Colors.grey,
                    ),
                    IconsButton(
                      onPressed: () {
                        result = -1;
                        Navigator.of(context).pop();
                        _validateResult();
                      },
                      text: "Revoir",
                      iconData: Icons.play_arrow,
                      color: Colors.red,
                      textStyle: TextStyle(color: Colors.white),
                      iconColor: Colors.white,
                    ),
                  ]);
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
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            RichText(
                              textAlign: TextAlign.justify,
                              text: const TextSpan(
                                  text: "Une petite question quiz",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20,
                                      color: Colors.white,
                                      wordSpacing: 1)),
                            ),
                            const Divider(
                              height: 20.0,
                              color: Colors.grey,
                            ),
                            RichText(
                              textAlign: TextAlign.left,
                              text: TextSpan(
                                  text: quiz.question,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: Colors.white,
                                    letterSpacing: 1,
                                    wordSpacing: 0.01,
                                  )),
                            ),
                            const SizedBox(height: 20),
                            _renderChoices(quiz, _selectedValues, setState),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: RaisedButton(
                                child: const Text("Vérifier la réponse"),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    _handleSubmit();
                                  }
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ));
        });
  }

  _renderChoices(quiz, _selectedValues, setState) {
    return quiz.uniqueChoice
        ? Column(
            children: [
              for (var choice in quiz.choices)
                Row(
                  children: <Widget>[
                    Text(choice.text),
                    const Spacer(),
                    Radio<int>(
                      activeColor: Colors.blue,
                      value: choice.order,
                      groupValue: _selectedValues[0],
                      onChanged: (value) {
                        setState(() {
                          _selectedValues[0] = value!;
                        });
                      },
                    ),
                  ],
                )
            ],
          )
        : Column(
            children: [
              for (var choice in quiz.choices)
                Row(
                  children: <Widget>[
                    Text(choice.text),
                    const Spacer(),
                    Checkbox(value: _selectedValues[choice.order-1] == 0 ? false : true, onChanged: (bool? selected){
                      setState((){
                        _selectedValues[choice.order-1] = selected! ? 1 : 0;
                      });
                    }),
                  ],
                ),
            ],
          );
  }

  List<Widget> renderParagraphs(){
    List<Widget> list = [];

    for(var i = 0; i < widget.course.paragraphs.length; i++){
      list.add(const SizedBox(height: 20));
      list.add(Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Text(
            "       ${widget.course.paragraphs[i]}",
            style: const TextStyle(fontSize: 16),
          ),
        ));
    }

    if(list.isEmpty){
      list.add(const SizedBox(height: 60));
      list.add(const Padding(
        padding: EdgeInsets.only(left: 15, right: 15),
        child: Text(
          "Ce cours ne dispose d'aucun contenu texte.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ));
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: widget.course.title,
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
          title: Text(widget.course.title),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: Responsive.isDesktop(context) ? 500 : 200,
                child: Center(
                  child: _chewieController != null &&
                          _chewieController!
                              .videoPlayerController.value.isInitialized
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
              const SizedBox(height: 20),
              Text(
                widget.course.title,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Column(
                children: renderParagraphs(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
