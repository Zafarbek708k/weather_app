


import 'dart:convert';
import 'dart:developer';
import 'dart:io';

class HttpClientService{

  const HttpClientService._internal();
  static const HttpClientService _service = HttpClientService._internal();
  factory HttpClientService(){
    return _service;
  }

  static Future<String?> getData({required String baseUrl, required String api, Map<String, dynamic>? param})async {
    HttpClient httpClient = HttpClient();
    Uri url = Uri.https(baseUrl, api, param);
    log(url.toString());
    HttpClientRequest request = await httpClient.getUrl(url);
    request.headers.set("x-api-key", "n9Q2Rw3jvtqd2zIskqjSnQ==VaVRlsKdBASzv2eM");
    HttpClientResponse response = await request.close();
    log("1111111111111111");
    log(response.toString());
    log("1111111111111111");
    if(response.statusCode == HttpStatus.ok){
      String result = await response.transform(utf8.decoder).join();
      log(result.toString());
      httpClient.close();
      return result;
    }else{
      httpClient.close();
      return null;
    }
  }

}