import 'dart:io';
import 'dart:ui';

import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/core/utils/util.dart';
import 'package:client/features/auth/models/fav_song_model.dart';
import 'package:client/features/home/models/song_model.dart';
import 'package:client/features/home/repositories/home_local_repository.dart';
import 'package:client/features/home/repositories/home_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_viewmodel.g.dart';

@riverpod
Future<List<SongModel>> getAllSongs(Ref ref) async {
  final token =
      ref.watch(currentUserNotifierProvider.select((user) => user!.token));
  final res = await ref.watch(homeRepositoryProvider).getAllSongs(
        token: token,
      );

  return switch (res) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };
}

@riverpod
Future<List<SongModel>> getAllFavoriteSongs(Ref ref) async {
  final token =
      ref.watch(currentUserNotifierProvider.select((user) => user!.token));
  final res = await ref.watch(homeRepositoryProvider).getAllFavoriteSongs(
        token: token,
      );

  return switch (res) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };
}

@riverpod
class HomeViewModel extends _$HomeViewModel {
  late HomeRepository _homeRepository;
  late HomeLocalRepository _homeLocalRepository;

  @override
  AsyncValue? build() {
    _homeRepository = ref.watch(homeRepositoryProvider);
    _homeLocalRepository = ref.watch(homeLocalRepositoryProvider);
    return null;
  }

  Future<void> uploadSong({
    required File selectedAudio,
    required File selectedImage,
    required String songName,
    required String artist,
    required Color hexCode,
  }) async {
    state = const AsyncValue.loading();
    final res = await _homeRepository.uploadSong(
      selectedAudio: selectedAudio,
      selectedImage: selectedImage,
      songName: songName,
      artist: artist,
      hexCode: rgbToHex(hexCode),
      token: ref.watch(currentUserNotifierProvider)!.token,
    );

    final val = switch (res) {
      Left(value: final l) => state =
          AsyncValue.error(l.message, StackTrace.current),
      Right(value: final r) => state = AsyncValue.data(r),
    };
  }

  List<SongModel> getRecentlyPlayedSongs() {
    return _homeLocalRepository.loadSongs();
  }

  Future<void> favorite({
    required String songId,
  }) async {
    state = const AsyncValue.loading();
    final res = await _homeRepository.favSong(
      token: ref.read(currentUserNotifierProvider)!.token,
      songId: songId,
    );

    final val = switch (res) {
      Left(value: final l) => state =
          AsyncValue.error(l.message, StackTrace.current),
      Right(value: final r) => _favSongSuccess(r, songId),
    };
  }

  AsyncValue _favSongSuccess(bool isFavoried, String songId) {
    final userNotifier = ref.read(currentUserNotifierProvider.notifier);
    if (isFavoried) {
      userNotifier.addUser(
        ref.read(currentUserNotifierProvider)!.copyWith(
          favorites: [
            ...ref.read(currentUserNotifierProvider)!.favorites,
            FavSongModel(id: '', song_id: songId, user_id: '')
          ],
        ),
      );
    } else {
      userNotifier.addUser(
        ref.read(currentUserNotifierProvider)!.copyWith(
          favorites: [
            ...ref
                .read(currentUserNotifierProvider)!
                .favorites
                .where((element) => element.song_id != songId),
          ],
        ),
      );
    }
    ref.invalidate(getAllFavoriteSongsProvider);
    return state = AsyncValue.data(isFavoried);
  }
}
