// ignore_for_file: avoid_print

import 'dart:developer';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PromptRepo {
  static Future<Uint8List?> generateImage(
      String prompt, Uint8List image) async {
    final dio = Dio();

    // String url = 'https://api.vyro.ai/v1/imagine/api/generations';
    String url = 'https://api.vyro.ai/v1/imagine/api/edits/remix';
    dio.options = BaseOptions(headers: {
      'Authorization': 'Bearer ${dotenv.env['API_KEY_MIDJOURNEY']}',
    }, responseType: ResponseType.bytes);

    final imageUploaded =
        MultipartFile.fromBytes(image, filename: 'peakpx.jpg');

    Map<String, dynamic> data = {
      //'futuristic player soccer, robotic shape, eight legs, color red'
      'prompt': prompt,
      'image': imageUploaded,
      "style_id": "21",
      "cfg": "3",
      "steps": "30",
      "seed": "1",
    };

    var formData = FormData.fromMap(data);
    print(formData);

    Response response = await dio.post(url, data: formData);
    if (response.statusCode == 200) {
      log("Success: ${response.statusCode}");
      try {
        log('response: ${response.data}');
        //!
        Uint8List uint8list = Uint8List.fromList(response.data);
        return uint8list;
      } on Exception catch (e) {
        log('error in repo ${e.toString()}');
        return null;
      }
    } else {
      log("Error in Repo: ${response.statusCode}");
      return null;
    }
  }
}
