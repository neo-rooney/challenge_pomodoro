import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          backgroundColor: const Color(0xFFE64D3D),
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            color: Color(0xFF232B55),
          ),
          displayMedium: TextStyle(
            color: Color(0xFFF3F4F6),
          ),
          displaySmall: TextStyle(
            color: Color(0xFFFFFFFF),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const fifteen = 15 * 60;
  static const twenty = 20 * 60;
  static const twentyFive = 25 * 60;
  static const thirty = 30 * 60;
  static const thirtyFive = 35 * 60;
  static const breakTime = 5 * 60;

  List<Map<String, dynamic>> list = [
    {
      "value": 'fifteen',
      "isSelectd": false,
      "second": fifteen,
    },
    {
      "value": 'twenty',
      "isSelectd": false,
      "second": twenty,
    },
    {
      "value": 'twentyFive',
      "isSelectd": false,
      "second": twentyFive,
    },
    {
      "value": 'thirty',
      "isSelectd": false,
      "second": thirty,
    },
    {
      "value": 'thirtyFive',
      "isSelectd": false,
      "second": thirtyFive,
    }
  ];

  int totalSeconds = 3;
  // late int totalSeconds;
  int round = 0;
  int goal = 0;
  late Timer timer;
  bool isRunning = false;
  bool isBreakItem = false;

  String formatMin(int seconds) {
    var duration = Duration(seconds: seconds);
    return duration.toString().split('.').first.substring(2, 4);
  }

  String formatSecond(int seconds) {
    var duration = Duration(seconds: seconds);
    return duration.toString().split('.').first.substring(5, 7);
  }

  void handleClickMin(String value) {
    setState(() {
      list = list.map((item) {
        if (item['value'] == value) {
          var newItem = {
            "value": item['value'],
            "isSelectd": true,
            "second": item['second']
          };
          totalSeconds = item['second'];
          return newItem;
        } else {
          var newItem = {
            "value": item['value'],
            "isSelectd": false,
            "second": item['second']
          };
          return newItem;
        }
      }).toList();
    });
  }

  void onTick(Timer timer) {
    if (totalSeconds == 0 && !isBreakItem) {
      timer.cancel();
      setState(() {
        isRunning = false;
        isBreakItem = true;
        totalSeconds = breakTime;
      });
      onStartPressed();
      if (round == 4) {
        setState(() {
          round = 0;
          goal = goal + 1;
        });
      } else {
        setState(() {
          round = round + 1;
        });
      }
    } else if (totalSeconds == 0 && isBreakItem) {
      timer.cancel();
      List<Map<String, dynamic>> selectedItem =
          list.where((element) => element['isSelectd'] == true).toList();
      int selectedSecond = selectedItem.first['second'];
      setState(() {
        isRunning = false;
        isBreakItem = false;
        totalSeconds = selectedSecond;
      });
    } else {
      setState(() {
        totalSeconds = totalSeconds - 1;
      });
    }
  }

  void onStartPressed() {
    timer = Timer.periodic(
      const Duration(
        seconds: 1,
      ),
      onTick,
    );
    setState(() {
      isRunning = true;
    });
  }

  void onPausePressed() {
    timer.cancel();
    setState(() {
      isRunning = false;
    });
  }

  void onReset() {
    setState(() {
      round = 0;
      goal = 0;
      isRunning = false;
      isBreakItem = false;
    });
    handleClickMin('fifteen');
  }

  @override
  void initState() {
    super.initState();
    handleClickMin('fifteen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          Flexible(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  'POMOTIMER',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.displaySmall!.color,
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Center(
              child: IconButton(
                iconSize: 30,
                color: Colors.white,
                onPressed: onReset,
                icon: const Icon(
                  Icons.restart_alt,
                ),
              ),
            ),
          ),
          Flexible(
              flex: 8,
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 140,
                        height: 180,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            formatMin(totalSeconds),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.background,
                              fontWeight: FontWeight.w700,
                              fontSize: 78,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          ":",
                          style: TextStyle(
                            color: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .color,
                            fontSize: 78,
                          ),
                        ),
                      ),
                      Container(
                        width: 140,
                        height: 180,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            formatSecond(totalSeconds),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.background,
                              fontWeight: FontWeight.w700,
                              fontSize: 78,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )),
          Flexible(
            flex: 1,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: list.length,
              itemBuilder: (context, index) {
                double itemWidth = MediaQuery.of(context).size.width * 0.175;
                var item = list[index];
                var value = item['value'];
                var second = item['second'];
                var isSelected = item['isSelectd'];
                return Container(
                    width: itemWidth,
                    margin: const EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white.withOpacity(0.6),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(4.0),
                      color: isSelected
                          ? Colors.white
                          : Theme.of(context).colorScheme.background,
                    ),
                    child: Center(
                      child: TextButton(
                        onPressed: () {
                          handleClickMin(value);
                        },
                        child: Text(
                          formatMin(second),
                          style: TextStyle(
                            color: isSelected
                                ? Theme.of(context).colorScheme.background
                                : Colors.white.withOpacity(0.6),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ));
              },
            ),
          ),
          Flexible(
            flex: 8,
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2), // 원하는 배경색
                  shape:
                      BoxShape.circle, // 원 모양의 버튼인 경우에는 BoxShape.circle로 설정합니다.
                ),
                child: IconButton(
                  iconSize: 50,
                  color: Colors.white,
                  onPressed: isRunning ? onPausePressed : onStartPressed,
                  icon: isRunning
                      ? const Icon(
                          Icons.pause,
                        )
                      : const Icon(
                          Icons.play_arrow_rounded,
                        ),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 4,
            child: Row(
              children: [
                Expanded(
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          '$round/4',
                          style: TextStyle(
                            color: Colors.white.withOpacity(
                              0.6,
                            ),
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'ROUND',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          '$goal/12',
                          style: TextStyle(
                            color: Colors.white.withOpacity(
                              0.6,
                            ),
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'GOAL',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
