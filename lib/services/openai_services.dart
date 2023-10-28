import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:insource/const/open_ai.dart';
import 'package:insource/model/open_ai.dart';

class RecomendationServices {
  static Future<GptData> getRecomendation() async {
    late GptData gpt = GptData(
      warning: "",
      id: "",
      object: "",
      created: 0,
      model: "",
      choices: [],
      usage: Usage(
        promptTokens: 0,
        completionTokens: 0,
        totalTokens: 0,
      ),
    );

    final Dio dio = Dio();

    try {
      const url = 'https://api.openai.com/v1/completions';

      Map<String, String> header = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      String promptData =
          "You're the most creative artist in this world, you only can answer question that related with art, so give me a random art idea for today";

      final data = jsonEncode({
        "model": "text-davinci-003",
        "prompt": promptData,
        "temperature": 0.4,
        "max_tokens": 64,
        "top_p": 1,
        "frequency_penalty": 0,
        "presence_penalty": 0,
      });

      dio.options.headers['Authorization'] = "Bearer $apiKey";
      final response =
          await dio.post(url, options: Options(headers: header), data: data);
      if (response.statusCode == 200) {
        debugPrint('data : ${response.data.toString()}');
        gpt = gptDataFromJson(response.data);
      }
    } catch (e) {
      throw Exception('Error occured when sending request : ${e.toString()}');
    }

    return gpt;
  }
}
