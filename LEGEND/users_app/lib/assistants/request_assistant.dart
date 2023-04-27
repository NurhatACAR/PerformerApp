import 'dart:convert';

import 'package:flutter/src/animation/animation_controller.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/ticker_provider.dart';
import 'package:http/http.dart' as http;

class RequestAssistant {
  static Future<dynamic> receiveRequest(String url) async {
    http.Response httpResponse = await http.get(Uri.parse(url));

    try {
      if (httpResponse.statusCode == 200) {
        String responseData = httpResponse.body; //json

        var decodeResponseData = jsonDecode(responseData);

        return decodeResponseData;
      } else {
        return "Hata oluştu, yanıt verilemiyor.";
      }
    } catch (exp) {
      return "Hata oluştu, yanıt verilemiyor.";
    }
  }
}
