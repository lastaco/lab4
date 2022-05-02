import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _messangerKey = GlobalKey<ScaffoldMessengerState>();

  bool timeEnd = false;
  bool registration = false;

  int score = 0;
  Color _color = Colors.black;
  Color _color2 = Colors.black;
  String textColor = '';
  String textColor2 = '';
  String textColor3 = '';
  String name = '';
  String email = '';

  List<Color> colorsList = [
    Colors.purple,
    Colors.grey,
    Colors.black,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.pink,
    Colors.brown,
  ];

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();

  List<String> colorsName = [
    'Фиолетовый',
    'Серый',
    'Черный',
    'Синий',
    'Зеленый',
    'Желтый',
    'Оранжевый',
    'Коричневый',
    'Розовый',
  ];

  Map<int, Map<String, Color>> colors = {
    0: {'Фиолетовый': Colors.purple},
    1: {'Серый': Colors.grey},
    2: {'Черный': Colors.black},
    3: {'Синий': Colors.blue},
    4: {'Зеленый': Colors.green},
    5: {'Желтый': Colors.yellow},
    6: {'Оранжевый': Colors.orange},
    7: {'Розовый': Colors.pink},
    8: {'Коричневый': Colors.brown},
  };
  Timer? _timer;

  int retryTimer = 60;

  void stopTimer() {
    if (_timer != null) {
      try {
        _timer!.cancel();
      } catch (e) {}
    }
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (retryTimer == 0) {
          setState(() {
            stopTimer();
            timeEnd = true;
          });
        } else {
          setState(() {
            retryTimer--;
          });
        }
      },
    );
  }

  void _filedFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  void yes() {
    if (textColor == textColor3) {
      score++;
    }
  }

  void no() {
    if (textColor != textColor3) {
      score++;
    }
  }

  void changeColor() {
    var rng = Random();
    int index = rng.nextInt(9);
    int index2 = rng.nextInt(9);
    int index3 = rng.nextInt(9);
    int index4 = rng.nextInt(9);
    setState(() {
      textColor = '${colors[index]?.keys}'.replaceAll('(', '');
      textColor = textColor.replaceAll(')', '');

      _color = colors[index]?[textColor] as Color;
      _color2 = colorsList[index2];
      textColor2 = colorsName[index3];
      textColor3 = colorsName[index4];
    });
  }

  void sendEmail() async {
    await sendEmailAPI(
      score,
      email,
      name,
    );
    _messangerKey.currentState?.showSnackBar(const SnackBar(
      content: Text(
        'Результат отправлен',
        textAlign: TextAlign.center,
      ),
    ));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();

    super.dispose();
  }

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: _messangerKey,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey,
          title: const Text(
            'Лаборотна робота №4',
          ),
          centerTitle: true,
        ),
        body: registration == false
            ? Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                focusNode: _nameFocus,
                // autofocus: true,
                onFieldSubmitted: (_) {
                  _filedFocusChange(context, _nameFocus, _emailFocus);
                },
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Ваше имя',
                  prefixIcon: const Icon(
                    Icons.person,
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      _nameController.clear();
                    },
                    child: Icon(
                      Icons.delete_outline,
                      color: Colors.red[300]!,
                    ),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    borderSide:
                    BorderSide(color: Colors.black, width: 2.0),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    borderSide:
                    BorderSide(color: Colors.blue, width: 2.0),
                  ),
                ),
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                focusNode: _emailFocus,
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Ваша почта',
                  prefixIcon: const Icon(
                    Icons.mail,
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      _emailController.clear();
                    },
                    child: Icon(
                      Icons.delete_outline,
                      color: Colors.red[300]!,
                    ),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    borderSide:
                    BorderSide(color: Colors.black, width: 2.0),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    borderSide:
                    BorderSide(color: Colors.blue, width: 2.0),
                  ),
                ),
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextButton(
                onPressed: (){

                  setState(() {
                    email =   _emailController.text;
                    name = _nameController.text;
                  });


                  if (email != '' && name != '') {
                    setState(() {
                      registration = true;
                    });
                    changeColor();
                    startTimer();
                  }
                },
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all<Size>(
                    const Size(1000, 50),
                  ),
                  backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.grey),
                ),
                child: const Text(
                  'Завершить регистрацию',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30,),
          ],
        )
            : timeEnd == false
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Совпадает ли название цвета слева с цветом текста справа?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  textColor3,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _color2,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  textColor2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _color,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    yes();
                    changeColor();
                  },
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.grey),
                  ),
                  child: const Text(
                    'Да',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    no();
                    changeColor();
                  },
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.grey),
                  ),
                  child: const Text(
                    'Нет',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 100,
            ),
            Text(
              'Осталось: $retryTimer',
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: LinearProgressIndicator(
                backgroundColor: Colors.grey[300],
                color: Colors.grey,
                value: retryTimer.toDouble() * 1.66666666667 / 100,
              ),
            ),
          ],
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Center(
              child: Text(
                'Вас счет: $score',
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    retryTimer = 60;
                    timeEnd = false;
                  });
                  changeColor();
                  startTimer();
                },
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all<Size>(
                    const Size(1000, 50),
                  ),
                  backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.grey),
                ),
                child: const Text(
                  'Попробовать еще раз',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextButton(
                onPressed: sendEmail,
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all<Size>(
                    const Size(1000, 50),
                  ),
                  backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.grey),
                ),
                child: const Text(
                  'Отправить результат на почту',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}

Future<dynamic> sendEmailAPI(score, email, name) async {
  var response = await Dio().post(
    "https://api.emailjs.com/api/v1.0/email/send",
    data: {
      "service_id": 'service_13nl7hq',
      "template_id": 'template_wn7qknf',
      "user_id": 'YUcR56-gWVrgW8rt9',
      "accessToken": 'Hsb3a9u8xzW4qg9M7d36q',
      'template_params': {
        'user_name': name,
        'user_email': email,
        'user_subject': 'Результа игры',
        'user_score': '$score',
      },
    },
    options: Options(
      headers: {
        'Content-Type': 'application/json',
        'origin': 'http://localhost',
      },
    ),
  );
  return response;
}
