import 'dart:io';
import 'package:findra/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ResultScreen extends StatefulWidget {
  final File? image;
  final String? text;

  const ResultScreen({super.key, this.image, this.text});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

const Color backgroundColor = Color(0xff1c202b);
const Color appBarColor = Color(0xff1c202b);
const Color buttonColor = Color(0xff7d5260);
const Color iconButtonText = Color(0xffb9b7bf);
const Color iconButtonColor = Color(0xff242A38);
const Color sendButtonColor = Color(0xffb9b7bf);
const Color textFieldBorderColor = Color(0xff88888e);
const Color textColor = Colors.white;

class _ResultScreenState extends State<ResultScreen> {

  late FlutterTts flutterTts;

  @override
  void initState() {
    flutterTts = FlutterTts();
    super.initState();
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  Future<void> _speak(String text) async {
    await flutterTts.setLanguage('en-US');
    await flutterTts.setPitch(1);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        forceMaterialTransparency: true,
        automaticallyImplyLeading: false,
        title: Container(
          width: width * 0.64,
          alignment: Alignment.center,
          child: Text(
            widget.text != null
                ? '${widget.text![0].toUpperCase()}${widget.text!.substring(1)}'
                : 'Result on Findra',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: textColor,
              fontSize: width * 0.052,
              fontWeight: FontWeight.w400,
              fontFamily: 'ABeeZee',
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.restart_alt_rounded),
            tooltip: 'Regenerate the prompt',
            iconSize: width * 0.052,
            onPressed: () {
              setState(() {});
            },
            color: textColor,
          ),
        ],
        centerTitle: true,
        backgroundColor: appBarColor,
      ),
      body: FutureBuilder<String>(
        future: Api.generateText(
          file: widget.image,
          prompt: widget.text,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'An error occurred!',
                    style: TextStyle(color: textColor, fontSize: width * 0.05),
                  ),
                  SizedBox(height: height * 0.02),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {});
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(buttonColor),
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No data available',
                style: TextStyle(color: textColor, fontSize: width * 0.05),
              ),
            );
          }

          final snapshotData = snapshot.data!;
          return Column(
            children: [
              if (widget.image != null)
                Center(
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: width * 0.9, // Ensure the image does not exceed screen width
                    ),
                    height: height * 0.25,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: FileImage(widget.image!),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              Expanded(
                child: Scrollbar(
                  thickness: 2.5,
                  radius: Radius.circular(width * 0.02),
                  child: SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.all(width * 0.04),
                      child: Padding(
                        padding: EdgeInsets.all(width * 0.04),
                        child: Text(
                          snapshotData,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: width * 0.052,
                            fontFamily: 'ABeeZee',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(buttonColor),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    icon: Icon(
                      Icons.restart_alt,
                      color: iconButtonText,
                      size: width * 0.052,
                    ),
                    label: Text(
                      'Chat with Findra again',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: width * 0.04,
                        fontFamily: "ABeeZee"
                      ),
                    ),
                  ),
                  IconButton.filledTonal(
                    onPressed: () {
                      _speak(snapshotData);
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(buttonColor),
                    ),
                    icon: Icon(
                      Icons.volume_up_outlined,
                      color: iconButtonText,
                      size: width * 0.052,
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * 0.02)
            ],
          );
        },
      ),
    );
  }
}
