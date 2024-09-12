import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:mime/mime.dart';

class Api {
  static Future<String> generateText({String? prompt, File? file}) async {
    const apiKey = '**YOUR API KEY HERE**';
    Uint8List? bytes;
    String? mimeType;
    List<Content> contentList = [];
    if (prompt != null) {
      Uint8List promptBytes = Uint8List.fromList(utf8.encode(prompt));
      contentList.add(Content.data('text/plain', promptBytes));  // Add text prompt to content list
    }
    if (file != null) {
      bytes = await file.readAsBytes();
      mimeType = lookupMimeType(file.path);

      if (mimeType == null) {
        return 'Error: Unsupported file type';
      }
      contentList.add(Content.data(mimeType, bytes));
    }
    if (contentList.isEmpty) {
      return 'Error: You must provide either a prompt, a file, or both';
    }

    final model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey,
    );

    try {
      final response = await model.generateContent(contentList);
      return response.text!;
    } catch (e) {
      log('Error: $e');
      return 'Error generating text: $e';
    }
  }
}
