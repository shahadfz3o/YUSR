import 'package:flutter/material.dart';
import 'package:flutter_mobile_vision_2/flutter_mobile_vision_2.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class TextRecognitionPageUser extends StatefulWidget {
  const TextRecognitionPageUser({super.key});

  @override
  State<TextRecognitionPageUser> createState() =>
      _TextRecognitionPageUserState();
}

class _TextRecognitionPageUserState extends State<TextRecognitionPageUser> {
  bool isInitilized = false;
  List<String> Allowed = ["Gluten-Free"];
  List<String> notAllowed = ["wheat", "barley", "oat", "Gluten"];

  @override
  void initState() {
    FlutterMobileVision.start().then((value) {
      isInitilized = true;
    });
    super.initState();
  }

  Future<String> _startScan() async {
    List<OcrText> list = [];

    try {
      list = await FlutterMobileVision.read(
        waitTap: false,
        fps: 15,
        multiple: true,
        showText: false,
      );

      if (list.isEmpty) {
        return '';
      }

      for (OcrText text in list) {
        //resultState.getText(text);
        //print('values ${text.value}');
        for (String ingredient in Allowed) {
          if (text.value.toLowerCase().contains(ingredient)) {
            return 'Allowed';
          }
        }

        for (String ingredient in notAllowed) {
          if (text.value.toLowerCase().contains(ingredient)) {
            //print("not Allowed");
            return 'notAllowed';
          }
        }
      }
    } catch (e) {}
    return 'Allowed';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 246, 244, 240),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Image.asset(
              "assets/scanner.png",
              width: 250,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: 250,
              child: ElevatedButton(
                onPressed: () async {
                  await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                            content: Container(
                              height: 430,
                              child: Column(
                                children: [
                                  Text(
                                    "1 من 2",
                                    style: TextStyle(
                                      color: Color(0XFFd7ab65),
                                      fontFamily: 'Tajawal',
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Image.asset(
                                    "assets/scanner.png",
                                    width: 300,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    'أولاً، يرجى توجيه كاميرة الهاتف على قائمة المكونات للمنتج.',
                                    style: TextStyle(
                                      fontFamily: 'Tajawal',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () async {
                                  Navigator.pop(context, 'حسناً');
                                  await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                            content: Container(
                                              height: 430,
                                              child: Column(
                                                children: [
                                                  Text(
                                                    "2 من 2",
                                                    style: TextStyle(
                                                      color: Color(0XFFd7ab65),
                                                      fontFamily: 'Tajawal',
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Image.asset(
                                                    "assets/scanner2.png",
                                                    width: 300,
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Text(
                                                    'ثانيًا، عند التوجيه بشكلٍ صحيح يرجى النقر لمرةٍ واحدة.',
                                                    style: TextStyle(
                                                      fontFamily: 'Tajawal',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () async {
                                                  Navigator.pop(
                                                      context, 'حسناً');
                                                },
                                                child: const Text(
                                                  'حسناً',
                                                  style: TextStyle(
                                                    fontFamily: 'Tajawal',
                                                  ),
                                                ),
                                              )
                                            ]);
                                      });
                                },
                                child: const Text(
                                  'حسناً',
                                  style: TextStyle(
                                    fontFamily: 'Tajawal',
                                  ),
                                ),
                              )
                            ]);
                      });
                  String result = await _startScan();

                  if (result == 'notAllowed') {
                    AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            animType: AnimType.bottomSlide,
                            desc: 'المنتج يحتوي على القلوتين',
                            btnCancelText: 'حسنًا',
                            btnCancelOnPress: () {})
                        .show();
                  } else if (result == 'Allowed') {
                    await AwesomeDialog(
                            context: context,
                            dialogType: DialogType.success,
                            animType: AnimType.bottomSlide,
                            desc: 'المنتج آمن، لا يحتوي على القلوتين',
                            btnOkText: 'حسنًا',
                            btnOkOnPress: () {})
                        .show();
                  } else {
                    await AwesomeDialog(
                            context: context,
                            dialogType: DialogType.warning,
                            animType: AnimType.bottomSlide,
                            desc: 'لم تقم بمسح أي شيء',
                            btnOkText: 'حسنًا',
                            btnOkOnPress: () {})
                        .show();
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.document_scanner_outlined),
                    Text(
                      '  قم بالتعرف على خلو المنتج',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ],
                ),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.pressed)) {
                        return Colors.grey;
                      }
                      return Color(0XFFd7ab65);
                    }),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
