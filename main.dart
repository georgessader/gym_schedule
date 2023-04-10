import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:developer';

void main() {
  runApp(const MyApp());
}

class DataStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/datastored.txt');
  }

  Future<String> readCounter() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return 0
      return "";
    }
  }

  Future<File> writeCounter(String dataString) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString(dataString);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final DataStorage storage = DataStorage();

  MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String dataFromFile = "";

  Map<String, Color> colorsDRead = {
    "r": Colors.red,
    "y": Colors.yellow,
    "w": Colors.white,
  };

  List<String> chestArray = [
    "Bench Press",
    "Incline Bench Press",
    "Decline Bench Press",
    "Dumbbell Bench Press",
    "Dumbbell Incline Press",
    "Dumbbell Decline Press",
    "Low Cable Cross Over",
    "Single Arm Cable",
    "Cable Chest Press",
    "Machine Chest Fly",
    "Machine Decline Chest Press",
    "Machine Chest Press",
    "Close Grip Dumbbell",
    "Dumbbell Pullover",
    "Dumbbell Fly",
    "Incline Dumbbell Fly",
    "Double Bar Roll Out",
    "Push Up"
  ];
  Map<String, Color> colorsMap = {};
  @override
  void initState() {
    super.initState();
    setState(() {
      widget.storage.readCounter().then((value) {
        setState(() {
          dataFromFile = value;
          applyColors();
        });
      });
    });
  }

  void applyColors() {
    setState(() {
      final lines = dataFromFile.split(";");
      log(dataFromFile);
      for (var i = 0; i < lines.length; i++) {
        final kv = lines[i].split(":");
        if(kv.length==2) {
          colorsMap[kv[0]] = colorsDRead[kv[1]]!;
        }
      }
    });
  }


  List<Widget> flexGetImages() {
    var dir = Directory('images/Chest/');
    List<Widget> images = <Widget>[];
    List contents = dir.listSync();
    for (var fileOrDir in contents) {
      images.add(Column(
        children: [
          Image.asset(fileOrDir.path),
          Text(fileOrDir.name),
        ],
      ));
    }
    return images;
  }

  void changeToDone(String sel) {
    setState(() {
      // Permission.requestPermissions([PermissionName.Storage]);
      if (colorsMap[sel] == Colors.red) {
        colorsMap[sel] = Colors.yellow;
      } else if (colorsMap[sel] == Colors.yellow) {
        colorsMap[sel] = Colors.white;
      } else {
        colorsMap[sel] = Colors.red;
      }
      String dataToSave = "";
      colorsMap.forEach((key, value) {
        if (value == Colors.red) {
          dataToSave += '$key:r;';
        } else if (value == Colors.yellow) {
          dataToSave += '$key:y;';
        } else {
          dataToSave += '$key:w;';
        }
      });
      widget.storage.writeCounter(dataToSave);
    });
  }

  List<Widget> getImages(var n, String muscle) {
    List<Widget> images = <Widget>[];
    for (var i = 1; i <= n; i++) {
      images.add(GestureDetector(
        onTap: () {
          changeToDone("$muscle$i");
        },
        child: Container(
          color: colorsMap["$muscle$i"],
          child: Column(
            children: [
              Expanded(flex: 1, child: Image.asset('images/$muscle/$i.jpg')),
              Text(chestArray[i - 1],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 10.0,
                  ))
            ],
          ),
        ),
      ));
    }
    return images;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: DefaultTabController(
          length: 6,
          child: Scaffold(
            backgroundColor: Colors.blueGrey[50],
            appBar: AppBar(
              title: const Text("Choose the muscle"),
              backgroundColor: Colors.lightBlue[900],
              bottom: const TabBar(
                tabs: [
                  Tab(
                    child: AutoSizeText(
                      "Chest",
                      style: TextStyle(fontSize: 15),
                      maxLines: 1,
                      minFontSize: 7,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Tab(
                    child: AutoSizeText(
                      "Biceps",
                      style: TextStyle(fontSize: 15),
                      maxLines: 1,
                      minFontSize: 7,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Tab(
                    child: AutoSizeText(
                      "Triceps",
                      style: TextStyle(fontSize: 15),
                      maxLines: 1,
                      minFontSize: 7,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Tab(
                    child: AutoSizeText(
                      "Shoulders",
                      style: TextStyle(fontSize: 15),
                      maxLines: 1,
                      minFontSize: 7,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Tab(
                    child: AutoSizeText(
                      "Back",
                      style: TextStyle(fontSize: 15),
                      maxLines: 1,
                      minFontSize: 7,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Tab(
                    child: AutoSizeText(
                      "Legs",
                      style: TextStyle(fontSize: 15),
                      maxLines: 1,
                      minFontSize: 7,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
            ),
            body: TabBarView(children: [
              GridView.count(
                primary: false,
                padding: const EdgeInsets.all(10),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 3,
                children: getImages(18, "Chest"),
              ),
              const Center(
                  child: Text(
                "Two",
                style: TextStyle(fontSize: 50),
              )),
              const Center(
                  child: Text(
                "Three",
                style: TextStyle(fontSize: 50),
              )),
              const Center(
                  child: Text(
                "Four",
                style: TextStyle(fontSize: 50),
              )),
              const Center(
                  child: Text(
                "Five",
                style: TextStyle(fontSize: 50),
              )),
              const Center(
                  child: Text(
                "Six",
                style: TextStyle(fontSize: 50),
              ))
            ]),
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
