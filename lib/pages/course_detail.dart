import 'package:chewie/chewie.dart';
import 'package:elearning/models/models.dart';
import 'package:elearning/models/quiz.dart';
import 'package:elearning/shared/theme.dart';
import 'package:elearning/theme.dart';
import 'package:elearning/utils/youtube_utils.dart';
import 'package:elearning/utils/youtube_video_utils.dart';
import 'package:elearning/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:video_player/video_player.dart';
import 'package:elearning/responsive.dart';

class CourseDetail extends StatefulWidget {
  final String title;

  const CourseDetail({Key? key, required this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CourseDetailState();
  }
}

class _CourseDetailState extends State<CourseDetail> {
  final TargetPlatform? _platform = TargetPlatform.iOS;
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final VideoQuiz videoQuiz;

  Duration? quizToRedoPosition;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  Future<void> initializePlayer() async {
    // Youtube video converter has a problem on web version: To fix later
    var dataSource = await YoutubeUtils.extractVideoUrl("https://www.youtube.com/watch?v=6bzqaG2vPZs");
    // var dataSource = await YoutubeVideoUtils.getVideoUrlFromYoutube("https://www.youtube.com/watch?v=6bzqaG2vPZs");
    _videoPlayerController = VideoPlayerController.network(
      // "https://assets.mixkit.co/videos/preview/mixkit-daytime-city-traffic-aerial-view-56-large.mp4"
        dataSource
    );
    await Future.wait([
      _videoPlayerController.initialize(),
    ]);
    _videoPlayerController.addListener(() {  //custom Listner
      _controlVideo(_videoPlayerController.value.position);
    },);
    videoQuiz = VideoQuiz();
    _createChewieController();
    setState(() {});
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

      subtitle: Subtitles(subtitles),
      subtitleBuilder: (context, dynamic subtitle) =>
          Container(
            padding: const EdgeInsets.all(5.0),
            decoration: const BoxDecoration(
                color: Colors.green
            ),
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

  _continuePlaying(){
    _videoPlayerController.play();
  }

  _goBackTo(Duration duration){
    _videoPlayerController.seekTo(duration);
    print("player seeked to: ${_videoPlayerController.position}");
    // _continuePlaying();
  }

  _continuePlayingFrom(Duration beginTime, Duration endTime){
    _goBackTo(beginTime);
    _continuePlaying();
    Future.delayed(const Duration(milliseconds: 1000), () {
      // Do something
      quizToRedoPosition = Duration(seconds: endTime.inSeconds);
      print("hehe: "+quizToRedoPosition.toString());
    });
  }

  _controlVideo(position) async {
    print("Video track " + position.toString());
    print("Quiz to redo $quizToRedoPosition");
    Quiz? quiz;
    if(quizToRedoPosition != null && videoQuiz.compareDurations(quizToRedoPosition!, position) == 0) {
      quiz = videoQuiz.getQuizByMoment(position, false);
      quizToRedoPosition = null;
    }
    else {
      quiz = videoQuiz.getQuizByMoment(position, true);
    }
    if(quiz != null){
      print("FOUND");
      _videoPlayerController.pause();
      _showDialog(context, quiz);
    }
  }

  _showDialog(context, Quiz quiz) {
    showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      int _selectedRadio = 0;
      // 0 retry, -1: rewatch, 1: correct answer
      int result = 0;

      _validateResult(){
        switch(result){
          case 1 : {
            Navigator.of(context).pop();
            _continuePlaying();
            break;
          }
          case -1: {
            _continuePlayingFrom(quiz.beginTime, quiz.endTime);
            Navigator.of(context).pop();
            break;
          }
          default: break;
        }
      }

      _handleSubmit() async {

        if(_selectedRadio == 1){
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
        }
        else{
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

      //TODO: Make the content of this form dynamic, ie bring it from the quiz object
      return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState){
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
                          text: TextSpan(
                              text: "Une petite question ${quiz.text}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                  color: Colors.white,
                                  wordSpacing: 1
                              )
                          ),
                        ),
                        const Divider(height: 20.0, color: Colors.grey,),
                        // TODO: Make this content dynamic
                        RichText(
                          textAlign: TextAlign.left,
                          text: const TextSpan(
                              text: "Qu'est ce qui ne fait pas partie du MVC ?",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Colors.white,
                                letterSpacing: 1,
                                wordSpacing: 0.01,
                              )
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: <Widget>[
                            const Text("Modélisation"),
                            const Spacer(),
                            Radio(
                              activeColor: Colors.blue,
                              value: 1,
                              groupValue: _selectedRadio,
                              onChanged: (int? value){
                                setState(() {
                                  _selectedRadio = value!;
                                });
                              },
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            const Text("View"),
                            const Spacer(),
                            Radio(
                              activeColor: Colors.blue,
                              value: 2,
                              groupValue: _selectedRadio,
                              onChanged: (int? value){
                                setState(() {
                                  _selectedRadio = value!;
                                });
                              },
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            const Text("Controller"),
                            const Spacer(),
                            Radio(
                              activeColor: Colors.blue,
                              value: 3,
                              groupValue: _selectedRadio,
                              onChanged: (int? value){
                                setState(() {
                                  _selectedRadio = value!;
                                });
                              },
                            ),
                          ],
                        ),
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
          )
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: widget.title,
      theme: AppTheme.dark.copyWith(
        platform: _platform ?? Theme
            .of(context)
            .platform,
      ),
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back), onPressed: () {
            Navigator.pop(context, false);
          },),
          title: Text(widget.title),
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
                      Text('Loading'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                widget.title,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Text(
                  "       MVC est un modèle architectural composé de trois parties : modèle, vue, contrôleur . Modèle : gère la logique des données. View : Il affiche les informations du modèle à l'utilisateur. Contrôleur : il contrôle le flux de données dans un objet de modèle et met à jour la vue chaque fois que les données changent.",
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Text(
                  "       Le pattern MVC permet de bien organiser son code source. Il va vous aider à savoir quels fichiers créer, mais surtout à définir leur rôle. Le but de MVC est justement de séparer la logique du code en trois parties que l'on retrouve dans des fichiers distincts.",
                  style: TextStyle(fontSize: 16),),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Text(
                  "       Modèle\n    Le composant Modèle correspond à toute la logique liée aux données avec laquelle l'utilisateur travaille. Cela peut représenter soit les données qui sont transférées entre les composants View et Controller, soit toute autre donnée liée à la logique métier. Par exemple, un objet Customer récupérera les informations client de la base de données, les manipulera et mettra à jour les données dans la base de données ou les utilisera pour restituer des données.",
                  style: TextStyle(fontSize: 16),),
              ),
            ],
          ),
        ),

      ),
    );
  }

}