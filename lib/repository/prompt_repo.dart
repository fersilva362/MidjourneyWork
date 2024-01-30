// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class PromptRepo {
  static Future<Uint8List?> generateImage(String prompt) async {
    final dio = Dio();
    String url = 'https://api.vyro.ai/v1/imagine/api/generations';
    //String url = 'https://api.vyro.ai/v1/imagine/api/edits/remix';
    dio.options = BaseOptions(headers: {
      'Authorization':
          'Bearer vk-4pBaOfr5qy4uJqvpM1U5Bg232Vc206DMBBu6ONKJ4mEIEk',
    }, responseType: ResponseType.bytes);

    Map<String, dynamic> data = {
      //'futuristic player soccer, robotic shape, eight legs, color red'
      'prompt': prompt,
      //'image': image,
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