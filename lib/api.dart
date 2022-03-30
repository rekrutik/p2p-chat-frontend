import 'dart:convert';

import 'package:dio/dio.dart';

class Message {
  final String id;
  final String? sender;
  final String text;

  Message({required this.id, required this.sender, required this.text});
}

class Api {
  static final Api _singleton = Api._internal();
  factory Api() => _singleton;
  Api._internal();

  late Uri _host;
  final _dio = Dio();

  Future<void> connect(String host) async {
    final uri = Uri.parse(host).replace(path: "healthcheck");
    final res = await _dio.get(uri.toString());
    if (res.data != "OK") {
      throw "Not OK";
    }
    _host = Uri.parse(host);
  }

  Future<List<Message>> getRecentMessages({int limit = 10}) async {
    final res = await _dio.get(_host.replace(path: "get-recent-messages", queryParameters: {"size": limit.toString()}).toString());
    List<dynamic> data = res.data;
    return data.map((e) => Message(id: e["id"], sender: e["sender"], text: e["text"])).toList();
  }
  
  Future<void> sendMessage(String text) async {
    final res = await _dio.post(_host.replace(path: "broadcast-message", queryParameters: {"text": text}).toString());
    if (res.data != "OK") {
      throw "Not OK";
    }
  }

  Future<String> getQr() async {
    final res = await _dio.get(_host.replace(path: "get-peer").toString(), options: Options(responseType: ResponseType.bytes));
    return "data:image/png;base64," + base64Encode(res.data);
  }

  String getQrUrl() {
    return _host.replace(path: "get-peer").toString();
  }

  Future<String> getJson() async {
    final res = await _dio.get(_host.replace(path: "get-json").toString(), options: Options(responseType: ResponseType.plain));
    return res.data;
  }

  Future<void> addJson(String json) async {
    final res = await _dio.post(_host.replace(path: "add-json").toString(), data: FormData.fromMap({'req': json}));
    if (res.data != "OK") {
      throw "Not OK";
    }
  }
}