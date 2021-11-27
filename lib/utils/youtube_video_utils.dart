import 'dart:convert';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class YoutubeVideoUtils{
  static String? convertUrlToId(String url, {bool trimWhitespaces = true}) {
    // assert(url?.isNotEmpty ?? false, 'Url cannot be empty');
    String _url;
    if (!url.contains('http') && (url.length == 11)) return url;
    if (trimWhitespaces) {
      _url = url.trim();
    } else {
      _url = url;
    }

    for (final exp in [
      RegExp(r'^https:\/\/(?:www\.|m\.)?youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11}).*$'),
      RegExp(
          r'^https:\/\/(?:www\.|m\.)?youtube(?:-nocookie)?\.com\/embed\/([_\-a-zA-Z0-9]{11}).*$'),
      RegExp(r'^https:\/\/youtu\.be\/([_\-a-zA-Z0-9]{11}).*$')
    ]) {
      final Match match = exp.firstMatch(_url) as Match;
      if (match != null && match.groupCount >= 1) return match.group(1);
    }

    return null;
  }

  static String _getVideoId(String url) {
    try {
      var id = '';
      id = url.substring(url.indexOf('?v=') + '?v='.length);
      // var id = convertUrlToId(url);

      return 'https://www.youtube.com/get_video_info?video_id=${id}&el=embedded&ps=default&eurl=&gl=US&hl=en';
    } catch (e) {
      return '';
    }
  }

  static Future<String> getVideoUrlFromYoutube(String youtubeUrl) async {
    // Extract the info url using the past method
    var link = _getVideoId(youtubeUrl);

    // Checker if the link is valid
    if (link == '') {
      print('Null Video Id from Link: $youtubeUrl');
    }

    // Links Holder
    var links = <String>[]; // This could turn into a map if one desires it
    var responseText;

   // try{
     // Now make the request
     var uri = Uri.parse(link);
     var response = await http.get(uri);

     if (response.statusCode == 200) {
       // var jsonResponse =
       // convert.jsonDecode(response.body) as Map<String, dynamic>;
       // var itemCount = jsonResponse['totalItems'];
       // print('Number of books about http: $itemCount.');
       // To make autocomplete easier
       responseText = response.body.toString();

       // This sections the chuck of data into multiples so we can parse it
       var sections = Uri.decodeFull(responseText).split('&');

       // This is the response json we are looking for
       var playerResponse = <String, dynamic>{};

       // Optimized better
       for (int i = 0; i < sections.length; i++) {
         String s = sections[i];

         // We can have multiple '=' inside the json, we want to divide the chunk by only the first equal
         int firstEqual = s.indexOf('=');

         // Sanity Check
         if (firstEqual < 0) {
           continue;
         }

         // Here we create the key value of the chunk of data
         String key = s.substring(0, firstEqual);
         String value = s.substring(firstEqual + 1);

         // This is the key that holds the mp4 information
         if (key == 'player_response') {
           playerResponse = jsonDecode(value);
           break;
         }
       }

       // Now that we have the json we need, we can start pointing to the links that holds the mp4
       // The node we need
       Map data = playerResponse['streamingData'];

       // Aggregating the data
       if (data['formats'] != null) {
         var formatLinks = [];
         formatLinks = data['formats'];
         if (formatLinks != null) {
           formatLinks.forEach((element) {
             // you can read the map here to get additional video infomation
             // like quality width height and bitrate
             // For this example however I just want the url
             links.add(element['url']);
           });
         }
       }

       // And adaptive ones also
       if (data['adaptiveFormats'] is List) {
         var formatLinks = [];
         formatLinks = data['adaptiveFormats'];
         formatLinks.forEach((element) {
           // you can read the map here to get additional video infomation
           // like quality width height and bitrate
           // For this example however I just want the url
           links.add(element['url']);
         });
       }

     } else {
       print('Request failed with status: ${response.statusCode}.');
     }


   // }
   // catch(e){
   //   print("heya :"+e.toString());
   // }

    // Finally return the links for the player
    return links.isNotEmpty
        ? links[0]
        :
      'https://assets.mixkit.co/videos/preview/mixkit-daytime-city-traffic-aerial-view-56-large.mp4' // This video Url will be the url we will use if there is an error with the method. Because we don't want to break do we? :)
    ;

  }
}