import 'package:beats_online/models/loading_enum.dart';
import 'package:beats_online/models/song_model.dart';
import 'package:beats_online/models/user_model.dart';

class ArtistProfileState {
  final UserModel user;
  final LoadPage status;
  final List<SongModel> songs;
  ArtistProfileState({
    required this.user,
    required this.status,
    required this.songs,
  });
  factory ArtistProfileState.initial() {
    return ArtistProfileState(
        user: UserModel(), songs: [], status: LoadPage.initial);
  }
  ArtistProfileState copyWith({
    UserModel? user,
    LoadPage? status,
    List<SongModel>? songs,
  }) {
    return ArtistProfileState(
      user: user ?? this.user,
      status: status ?? this.status,
      songs: songs ?? this.songs,
    );
  }
}
