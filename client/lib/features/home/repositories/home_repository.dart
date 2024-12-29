import 'dart:convert';
import 'dart:io';

import 'package:client/core/constants/constants.dart';
import 'package:client/core/failure/failure.dart';
import 'package:client/features/home/models/song_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_repository.g.dart';

@riverpod
HomeRepository homeRepository(Ref ref) {
  return HomeRepository();
}

class HomeRepository {
  Future<Either<AppFailure, String>> uploadSong({
    required File selectedAudio,
    required File selectedImage,
    required String songName,
    required String artist,
    required String hexCode,
    required String token,
  }) async {
    try {
      final request = http.MultipartRequest(
          'POST', Uri.parse('${ServerConstants.baseUrl}/song/upload'));

      request
        ..files.addAll([
          await http.MultipartFile.fromPath('song', selectedAudio.path),
          await http.MultipartFile.fromPath('thumbnail', selectedImage.path),
        ])
        ..fields.addAll({
          'artist': artist,
          'song_name': songName,
          'hex_code': hexCode,
        })
        ..headers.addAll({
          'x-auth-token': token,
        });

      final res = await request.send();
      if (res.statusCode != 201) {
        return Left(AppFailure('Failed to upload song'));
      }

      return Right(await res.stream.bytesToString());
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, List<SongModel>>> getAllSongs({
    required String token,
  }) async {
    try {
      final res = await http
          .get(Uri.parse('${ServerConstants.baseUrl}/songs'), headers: {
        'Content-Type': 'application/json',
        'x-auth-token': token,
      });

      var body = jsonDecode(res.body);

      if (res.statusCode != 200) {
        body = body as Map<String, dynamic>;
        return Left(AppFailure(body['detail']));
      }

      body = body as List;

      List<SongModel> songs = [];

      for (final map in body) {
        songs.add(SongModel.fromMap(map));
      }

      return Right(songs);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, bool>> favSong({
    required String token,
    required String songId,
  }) async {
    try {
      final res =
          await http.post(Uri.parse('${ServerConstants.baseUrl}/song/favorite'),
              headers: {
                'Content-Type': 'application/json',
                'x-auth-token': token,
              },
              body: jsonEncode({
                'song_id': songId,
              }));

      var body = jsonDecode(res.body);

      if (res.statusCode != 200) {
        body = body as Map<String, dynamic>;
        return Left(AppFailure(body['detail']));
      }

      return Right(body['message']);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, List<SongModel>>> getAllFavoriteSongs({
    required String token,
  }) async {
    try {
      final res = await http.get(
          Uri.parse('${ServerConstants.baseUrl}/song/list/faviorite'),
          headers: {
            'Content-Type': 'application/json',
            'x-auth-token': token,
          });

      var body = jsonDecode(res.body);

      if (res.statusCode != 200) {
        body = body as Map<String, dynamic>;
        return Left(AppFailure(body['detail']));
      }

      body = body as List;

      List<SongModel> songs = [];

      for (final map in body) {
        songs.add(SongModel.fromMap(map['song']));
      }

      return Right(songs);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}
