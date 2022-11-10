import 'package:beats_online/models/loading_enum.dart';
import 'package:beats_online/models/song_model.dart';
import 'package:beats_online/models/user.dart';

class SearchResultsState {
  final LoadPage status;
  final List<SongModel> songs;
  final List<User> users;
  final bool isSong;
  final bool isNull;
  SearchResultsState({
    required this.status,
    required this.songs,
    required this.users,
    required this.isSong,
    required this.isNull,
  });

  factory SearchResultsState.initial() => SearchResultsState(
        songs: [],
        users: [],
        isNull: true,
        isSong: true,
        status: LoadPage.initial,
      );

  SearchResultsState copyWith({
    LoadPage? status,
    List<SongModel>? songs,
    List<User>? users,
    bool? isSong,
    bool? isNull,
  }) {
    return SearchResultsState(
      status: status ?? this.status,
      songs: songs ?? this.songs,
      users: users ?? this.users,
      isSong: isSong ?? this.isSong,
      isNull: isNull ?? this.isNull,
    );
  }
}
