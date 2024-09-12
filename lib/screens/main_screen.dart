import 'dart:io';

import 'package:findra/screens/result_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:url_launcher/url_launcher.dart';

const Color backgroundColor = Color(0xff1c202b);
const Color appBarColor = Color(0xff1c202b);
const Color buttonColor = Color(0xff575381);
const Color iconButtonText = Color(0xffb9b7bf);
const Color iconButtonColor = Color(0xff242A38);
const Color sendButtonColor = Color(0xffb9b7bf);
const Color textFieldBorderColor = Color(0xff88888e);
const Color textColor = Colors.white;

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  XFile? image;
  TextEditingController textEditingController = TextEditingController();
  String text = '';
  FocusNode focusNode = FocusNode();

  bool isAnimating = true;

  bool _isListening = false;
  late stt.SpeechToText _speech;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        _stopListening();
      }
    });
    _speech.initialize(
      onStatus: (status) {
        if (status == 'notListening') {
          setState(() {
            _isListening = false;
          });
        }
        if (status == 'listening') {
          setState(() {
            _isListening = true;
          });
        }
        if (status == 'done') {
          setState(() {
            _isListening = false;
          });
        }
      },
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).unfocus();
      focusNode.unfocus();
    });
  }

  void _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() {
        _isListening = true;
      });
      _speech.listen(onResult: (result) {
        setState(() {
          text = result.recognizedWords;
          textEditingController.text = text;
        });
      });
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() {
      _isListening = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Speaking with Findra'),
        centerTitle: true,
        backgroundColor: appBarColor,
        actions: [
          IconButton(
            onPressed: () {
              focusNode.unfocus();
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Container(
                    height: height * 0.2,
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(width * 0.04),
                        topRight: Radius.circular(width * 0.04),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Contact Us',
                          style: TextStyle(
                            color: textColor,
                            fontSize: width * 0.052,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'ABeeZee',
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            FilledButton.icon(
                              onPressed: () {
                                launchUrl(
                                  Uri.parse('mailto:conversa1805@gmail.com'),
                                );
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    WidgetStateProperty.all(buttonColor),
                              ),
                              label: const Text(
                                'Email Us',
                                style: TextStyle(fontFamily: 'ABeeZee'),
                              ),
                              icon: Icon(
                                Icons.email_outlined,
                                size: width * 0.052,
                              ),
                            ),
                            FilledButton.icon(
                              onPressed: () {
                                launchUrl(
                                  Uri.parse('tel:+91-9140535424'),
                                );
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    WidgetStateProperty.all(buttonColor),
                              ),
                              label: const Text(
                                'Call Us',
                                style: TextStyle(fontFamily: 'ABeeZee'),
                              ),
                              icon: Icon(
                                Icons.phone_outlined,
                                size: width * 0.052,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            icon: Icon(
              Icons.more_vert,
              size: width * 0.052,
            ),
          ),
        ],
        titleTextStyle: TextStyle(
          color: textColor,
          fontSize: width * 0.052,
          fontWeight: FontWeight.w400,
          fontFamily: 'ABeeZee',
        ),
      ),
      body: Focus(
        focusNode: focusNode,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: height * 0.02),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: height * 0.02),
                      GestureDetector(
                        onLongPress: () {
                          setState(() {
                            isAnimating = !isAnimating;
                          });
                        },
                        child: SizedBox(
                          height: width * 0.56,
                          width: width * 0.56,
                          child: Lottie.asset('lib/assets/ai.json',
                              reverse: true, animate: isAnimating),
                        ),
                      ),
                      SizedBox(height: height * 0.16),
                      Container(
                        height: width * 0.26,
                        width: width * 0.26,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: backgroundColor,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.25),
                              offset: const Offset(0, 4),
                              blurRadius: 16,
                            ),
                          ],
                        ),
                        child: FilledButton(
                          onPressed: () {
                            if (!_isListening) {
                              _startListening();
                            } else {
                              _stopListening();
                            }
                          },
                          style: ButtonStyle(
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(width * 0.12),
                              ),
                            ),
                            shadowColor: WidgetStateProperty.all(
                                Colors.purple.withOpacity(0.5)),
                            backgroundColor:
                                WidgetStateProperty.all(buttonColor),
                          ),
                          child: Icon(
                            _isListening
                                ? Icons.mic_off_outlined
                                : Icons.mic_none,
                            size: width * 0.12,
                            color: textColor,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.25),
                                offset: const Offset(0, 4),
                                blurRadius: 16,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.016),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _iconButton(
                            context,
                            Icons.camera_alt_outlined,
                            ImageSource.camera,
                          ),
                          SizedBox(width: width * 0.1),
                          _iconButton(
                            context,
                            Icons.image_outlined,
                            ImageSource.gallery,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              color: const Color(0xff242A38),
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.04,
                vertical: height * 0.03,
              ),
              child: Row(
                children: [
                  if (image != null)
                    Stack(
                      children: [
                        SizedBox(
                          height: width * 0.15,
                          width: width * 0.15,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(width * 0.04),
                            child: Image.file(
                              File(image!.path),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: CircleAvatar(
                            radius: width * 0.03,
                            backgroundColor: buttonColor,
                            child: IconButton(
                              onPressed: () {
                                setState(
                                  () {
                                    image = null;
                                  },
                                );
                              },
                              padding: EdgeInsets.zero,
                              icon: Icon(
                                Icons.close,
                                size: width * 0.04,
                                color: textColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (image != null) SizedBox(width: width * 0.04),
                  Expanded(
                    child: TextField(
                      controller: textEditingController,
                      onChanged: (value) {
                        setState(() {
                          text = value;
                        });
                      },
                      onSubmitted: (value) {
                        FocusScope.of(context).unfocus();
                        focusNode.unfocus();
                        textEditingController.clear();
                        if (image != null && text.isEmpty) {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => ResultScreen(
                                image: File(image!.path),
                              ),
                            ),
                          ).then(
                            (value) {
                              setState(() {
                                image = null;
                              });
                            },
                          );
                        } else if (text.isNotEmpty && image == null) {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => ResultScreen(text: text),
                            ),
                          ).then(
                            (value) {
                              setState(() {
                                text = '';
                              });
                            },
                          );
                        } else if (text.isNotEmpty && image != null) {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => ResultScreen(
                                text: text,
                                image: File(image!.path),
                              ),
                            ),
                          ).then(
                            (value) {
                              setState(() {
                                image = null;
                              });
                            },
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Please enter a message or select an image',
                                style: TextStyle(
                                  fontSize: width * 0.04,
                                  fontFamily: 'ABeeZee',
                                ),
                              ),
                            ),
                          );
                        }
                      },
                      decoration: InputDecoration(
                        hintText: 'Type a message',
                        hintStyle: TextStyle(
                          color: textColor.withOpacity(0.5),
                          fontSize: width * 0.04,
                          fontFamily: 'ABeeZee',
                        ),
                        border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: textFieldBorderColor),
                          borderRadius: BorderRadius.circular(width * 0.04),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: textFieldBorderColor),
                          borderRadius: BorderRadius.circular(width * 0.04),
                        ),
                      ),
                      style: TextStyle(
                        color: textColor,
                        fontSize: width * 0.04,
                        fontFamily: 'ABeeZee',
                      ),
                    ),
                  ),
                  SizedBox(width: width * 0.04),
                  SizedBox(
                    height: width * 0.15,
                    width: width * 0.15,
                    child: FloatingActionButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        focusNode.unfocus();
                        textEditingController.clear();
                        if (image != null && text.isEmpty) {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => ResultScreen(
                                image: File(image!.path),
                              ),
                            ),
                          ).then(
                            (value) {
                              setState(() {
                                image = null;
                              });
                            },
                          );
                        } else if (text.isNotEmpty && image == null) {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => ResultScreen(text: text),
                            ),
                          ).then(
                            (value) {
                              setState(() {
                                text = '';
                              });
                            },
                          );
                        } else if (text.isNotEmpty && image != null) {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => ResultScreen(
                                text: text,
                                image: File(image!.path),
                              ),
                            ),
                          ).then(
                            (value) {
                              setState(() {
                                image = null;
                              });
                            },
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Please enter a message or select an image',
                                style: TextStyle(
                                  fontSize: width * 0.04,
                                  fontFamily: 'ABeeZee',
                                ),
                              ),
                            ),
                          );
                        }
                      },
                      elevation: 0,
                      backgroundColor: sendButtonColor,
                      child: Icon(
                        Icons.send_rounded,
                        size: width * 0.056,
                        color: backgroundColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _iconButton(BuildContext context, IconData icon, ImageSource source) {
    final width = MediaQuery.of(context).size.width;

    return IconButton(
      onPressed: () async {
        XFile? pickedImage = await ImagePicker().pickImage(source: source);
        setState(
          () {
            image = pickedImage;
          },
        );
      },
      padding: EdgeInsets.all(width * 0.036),
      icon: Icon(
        icon,
        size: width * 0.06,
        color: iconButtonText,
      ),
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(iconButtonColor),
      ),
    );
  }
}
