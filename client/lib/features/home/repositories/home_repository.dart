import 'dart:io';

import 'package:client/core/constants/constants.dart';
import 'package:http/http.dart' as http;

class HomeRepository {
  Future<void> uploadSong(File selectedAudio, File selectedImage) async {
    final request = http.MultipartRequest(
        'POST', Uri.parse('${ServerConstants.baseUrl}/song/upload'));

    request
      ..files.addAll([
        await http.MultipartFile.fromPath('song', selectedAudio.path),
        await http.MultipartFile.fromPath('thumbnail', selectedImage.path),
      ])
      ..fields.addAll({
        'artist': 'Taylor',
        'song_name': 'Exxxx',
        'hex_code': '000000',
      })
      ..headers.addAll({
        'x-auth-token': 'asdf',
      });

    final res = await request.send();
    print(res);
  }
}
