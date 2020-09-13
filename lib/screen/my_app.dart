import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:td_test_project/puzzle_game/puzzle_game.dart';
import 'package:td_test_project/screen/WebView.dart';
import 'package:td_test_project/utils/api.dart';
import 'package:td_test_project/utils/app_start_utils.dart';

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  Widget home = PuzzleGame(title: "game");
  Future<Widget> defineWidgetToBuild() async {
    bool isFirstTime = await AppStartUtils.isFirstTime();
    if (isFirstTime) {
      bool apiResponse = await ServerApi.getReq();
      if (apiResponse) {
        print("Server---true");
        return WebV("http://html5test.com");
      }
    }

    return PuzzleGame(title: "Puzzle");
  }

  @override
  void initState() {
    super.initState();
    defineWidgetToBuild().then((value) => setState(() {
          home = value;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(theme: ThemeData.light(), home: home);
  }
}
