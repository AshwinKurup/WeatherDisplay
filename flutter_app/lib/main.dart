import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
Future<void> main() async {
  print("main Method");
  runApp(MyApp());
}


Future<String> getAssetLocation() async {
  var weatherPrediction = await listenForWeather();
  print("this is the weatherIconValue value written in button");
  String location = "assets/images/" + weatherPrediction + ".png";
  print("this is the future value written in button");
  print(weatherPrediction);
  print("this is the location");
  print(location);
  int number = 1;
  return weatherPrediction;
}


Future<String> listenForWeather() async{
    Uri url = Uri.parse("https://api.data.gov.sg/v1/environment/2-hour-weather-forecast?date=2021-01-01");
    final response = await http.get(url);
    for (int i = 0; i < 47; i++) {
      if (json.decode(response.body)['items'][0]['forecasts'][i]['area'] ==
          "Bedok") {
        print(json.decode(
            response.body)['items'][0]['forecasts'][i]['forecast']);
        return json.decode(
            response.body)['items'][0]['forecasts'][i]['forecast'];
      }
    }
  }


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Weather Forecast',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.orange,
        ),
        home: MyHomePage()//)
    );

  }

}

class MyHomePage extends StatelessWidget{
  final checked = true;
  bool didFutureReturn = false;
  @override
  Widget build(BuildContext context){
    return FutureBuilder<String>(
        future: getAssetLocation(),
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                title: Text("Weather Display"),
                centerTitle: true,
                  backgroundColor: Colors.orange,
              ),
              body: Column(
                children: [Image(
                  image: AssetImage("assets/images/" + snapshot.data + ".png"), height: 300, width: 300,),
                Text("it is " + snapshot.data)]
                ,)
              ,);


            //);
            // return Image.asset(snapshot.data,
            //   height: 1,
            //   width: 2,
            //   fit: BoxFit.fitWidth,);

          } else {
            return CircularProgressIndicator();
          }
        }
    );
  }
}
