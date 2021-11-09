import 'package:chewie/chewie.dart';
import 'package:elearning/theme.dart';
import 'package:elearning/utils/YoutubeUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CourseDetail extends StatefulWidget{
  final String title;

  const CourseDetail({Key? key, required this.title}) : super(key: key);
  
  @override
  State<StatefulWidget> createState() {
    return _CourseDetailState();
  }
}

class _CourseDetailState extends State<CourseDetail> {
  TargetPlatform? _platform = TargetPlatform.iOS;
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

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
    // var dataSource = await YoutubeUtils.extractVideoUrl("https://www.youtube.com/watch?v=Y9Wjnc8cWa0&t=331s");
    _videoPlayerController = VideoPlayerController.network(
      "https://assets.mixkit.co/videos/preview/mixkit-daytime-city-traffic-aerial-view-56-large.mp4"
    );
        await Future.wait([
      _videoPlayerController.initialize(),
    ]);
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
      subtitleBuilder: (context, dynamic subtitle) => Container(
        padding: const EdgeInsets.all(10.0),
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: widget.title,
      theme: AppTheme.dark.copyWith(
        platform: _platform ?? Theme.of(context).platform,
      ),
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(icon:const Icon(Icons.arrow_back), onPressed: () { Navigator.pop(context, false); },),
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
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Text("L'apprentissage automatique1,2 (en anglais : machine learning, litt. « apprentissage machine1,2 »), apprentissage artificiel1 ou apprentissage statistique est un champ d'étude de l'intelligence artificielle qui se fonde sur des approches mathématiques et statistiques pour donner aux ordinateurs la capacité d'« apprendre » à partir de données, c'est-à-dire d'améliorer leurs performances à résoudre des tâches sans être explicitement programmés pour chacune. Plus largement, il concerne la conception, l'analyse, l'optimisation, le développement et l'implémentation de telles méthodes."),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Text("L'apprentissage automatique comporte généralement deux phases. La première consiste à estimer un modèle à partir de données, appelées observations, qui sont disponibles et en nombre fini, lors de la phase de conception du système. L'estimation du modèle consiste à résoudre une tâche pratique, telle que traduire un discours, estimer une densité de probabilité, reconnaître la présence d'un chat dans une photographie ou participer à la conduite d'un véhicule autonome. Cette phase dite « d'apprentissage » ou « d'entraînement » est généralement réalisée préalablement à l'utilisation pratique du modèle. La seconde phase correspond à la mise en production : le modèle étant déterminé, de nouvelles données peuvent alors être soumises afin d'obtenir le résultat correspondant à la tâche souhaitée. En pratique, certains systèmes peuvent poursuivre leur apprentissage une fois en production, pour peu qu'ils aient un moyen d'obtenir un retour sur la qualité des résultats produits. "),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Text("Selon les informations disponibles durant la phase d'apprentissage, l'apprentissage est qualifié de différentes manières. Si les données sont étiquetées (c'est-à-dire que la réponse à la tâche est connue pour ces données), il s'agit d'un apprentissage supervisé. On parle de classification ou de classement3 si les étiquettes sont discrètes, ou de régression si elles sont continues. Si le modèle est appris de manière incrémentale en fonction d'une récompense reçue par le programme pour chacune des actions entreprises, on parle d'apprentissage par renforcement. Dans le cas le plus général, sans étiquette, on cherche à déterminer la structure sous-jacente des données (qui peuvent être une densité de probabilité) et il s'agit alors d'apprentissage non supervisé. L'apprentissage automatique peut être appliqué à différents types de données, tels des graphes, des arbres, des courbes, ou plus simplement des vecteurs de caractéristiques, qui peuvent être des variables qualitatives ou quantitatives continues ou discrètes. "),
              ),

              // TextButton(
              //   onPressed: () {
              //     _chewieController?.enterFullScreen();
              //   },
              //   child: const Text('Fullscreen'),
              // ),
              // Row(
              //   children: <Widget>[
              //     Expanded(
              //       child: TextButton(
              //         onPressed: () {
              //           setState(() {
              //             _videoPlayerController.pause();
              //             _videoPlayerController.seekTo(const Duration());
              //             _createChewieController();
              //           });
              //         },
              //         child: const Padding(
              //           padding: EdgeInsets.symmetric(vertical: 16.0),
              //           child: Text("Reinitialiser"),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              // Row(
              //   children: <Widget>[
              //     Expanded(
              //       child: TextButton(
              //         onPressed: () {
              //           setState(() {
              //             _platform = TargetPlatform.android;
              //           });
              //         },
              //         child: const Padding(
              //           padding: EdgeInsets.symmetric(vertical: 16.0),
              //           child: Text("Android controls"),
              //         ),
              //       ),
              //     ),
              //     Expanded(
              //       child: TextButton(
              //         onPressed: () {
              //           setState(() {
              //             _platform = TargetPlatform.iOS;
              //           });
              //         },
              //         child: const Padding(
              //           padding: EdgeInsets.symmetric(vertical: 16.0),
              //           child: Text("iOS controls"),
              //         ),
              //       ),
              //     )
              //   ],
              // ),
              // Row(
              //   children: <Widget>[
              //     Expanded(
              //       child: TextButton(
              //         onPressed: () {
              //           setState(() {
              //             _platform = TargetPlatform.windows;
              //           });
              //         },
              //         child: const Padding(
              //           padding: EdgeInsets.symmetric(vertical: 16.0),
              //           child: Text("Desktop controls"),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),

      ),
    );
  }

}