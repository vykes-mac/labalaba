import 'dart:io';

import 'package:http/http.dart';

class ImageUploader {
  final String _url;

  ImageUploader(this._url);

  Future<String> uploadImage(File image) async {
    final request = MultipartRequest('POST', Uri.parse(_url));
    request.files.add(await MultipartFile.fromPath('picture', image.path));
    final result = await request.send();
    if (result.statusCode != 200) return null;
    final response = await Response.fromStream(result);
    return Uri.parse(_url).origin + response.body;
  }
}
