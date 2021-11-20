import 'package:chewie/chewie.dart';
import 'package:elearning/models/models.dart';
import 'package:elearning/models/quiz.dart';
import 'package:elearning/shared/theme.dart';
import 'package:elearning/theme.dart';
import 'package:elearning/utils/YoutubeUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:video_player/video_player.dart';

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
    // var dataSource = await YoutubeUtils.extractVideoUrl(
    //     "https://www.youtube.com/watch?v=Y9Wjnc8cWa0&t=331s");
    _videoPlayerController = VideoPlayerController.network(
      "https://assets.mixkit.co/videos/preview/mixkit-daytime-city-traffic-aerial-view-56-large.mp4"
      //   dataSource
    );
    await Future.wait([
      _videoPlayerController.initialize(),
    ]);
    _videoPlayerController.addListener(() {                      //custom Listner
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

  _continuePlayingFrom(Duration duration){
    _goBackTo(duration);
    _continuePlaying();
  }

  _controlVideo(position) async {
    // print("Video track " + position.toString());
    Quiz? quiz = videoQuiz.getQuizByMoment(position);
    if(quiz != null){
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
            Navigator.of(context).pop();
            _continuePlayingFrom(quiz.beginTime);
            break;
          }
          default: break;
        }
      }

      _handleSubmit() async {

        if(_selectedRadio == 1){
          Dialogs.bottomMaterialDialog(
              color: mainColor2,
              msg: 'Congratulations, you won 500 points',
              title: 'Bien joué',
              context: context,
              actions: [
                IconsButton(
                  onPressed: () {
                    result = 1;
                    Navigator.of(context).pop();
                    _validateResult();
                  },
                  text: 'Claim',
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

      return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState){
              return Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  // Positioned(
                  //   right: -40.0,
                  //   top: -40.0,
                  //   child: InkResponse(
                  //     onTap: () {
                  //       Navigator.of(context).pop();
                  //     },
                  //     child: const CircleAvatar(
                  //       child: Icon(Icons.close),
                  //       backgroundColor: Colors.red,
                  //     ),
                  //   ),
                  // ),
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
                        RichText(
                          textAlign: TextAlign.left,
                          text: const TextSpan(
                              text: "Quelle est selon toi le plus important ?",
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
                            const Text("L'ergonomie"),
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
                            const Text("Le design"),
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
                            const Text("Les fonctionalités"),
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
                height: 200,
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
                  "       L'apprentissage automatique (en anglais : machine learning, litt. « apprentissage machine »), apprentissage artificiel1 ou apprentissage statistique est un champ d'étude de l'intelligence artificielle qui se fonde sur des approches mathématiques et statistiques pour donner aux ordinateurs la capacité d'« apprendre » à partir de données, c'est-à-dire d'améliorer leurs performances à résoudre des tâches sans être explicitement programmés pour chacune. Plus largement, il concerne la conception, l'analyse, l'optimisation, le développement et l'implémentation de telles méthodes.",
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Text(
                  "       L'apprentissage automatique comporte généralement deux phases. La première consiste à estimer un modèle à partir de données, appelées observations, qui sont disponibles et en nombre fini, lors de la phase de conception du système. L'estimation du modèle consiste à résoudre une tâche pratique, telle que traduire un discours, estimer une densité de probabilité, reconnaître la présence d'un chat dans une photographie ou participer à la conduite d'un véhicule autonome. Cette phase dite « d'apprentissage » ou « d'entraînement » est généralement réalisée préalablement à l'utilisation pratique du modèle. La seconde phase correspond à la mise en production : le modèle étant déterminé, de nouvelles données peuvent alors être soumises afin d'obtenir le résultat correspondant à la tâche souhaitée. En pratique, certains systèmes peuvent poursuivre leur apprentissage une fois en production, pour peu qu'ils aient un moyen d'obtenir un retour sur la qualité des résultats produits. ",
                  style: TextStyle(fontSize: 16),),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Text(
                  "       Selon les informations disponibles durant la phase d'apprentissage, l'apprentissage est qualifié de différentes manières. Si les données sont étiquetées (c'est-à-dire que la réponse à la tâche est connue pour ces données), il s'agit d'un apprentissage supervisé. On parle de classification ou de classement3 si les étiquettes sont discrètes, ou de régression si elles sont continues. Si le modèle est appris de manière incrémentale en fonction d'une récompense reçue par le programme pour chacune des actions entreprises, on parle d'apprentissage par renforcement. Dans le cas le plus général, sans étiquette, on cherche à déterminer la structure sous-jacente des données (qui peuvent être une densité de probabilité) et il s'agit alors d'apprentissage non supervisé. L'apprentissage automatique peut être appliqué à différents types de données, tels des graphes, des arbres, des courbes, ou plus simplement des vecteurs de caractéristiques, qui peuvent être des variables qualitatives ou quantitatives continues ou discrètes. ",
                  style: TextStyle(fontSize: 16),),
              ),
            ],
          ),
        ),

      ),
    );
  }

}