import 'package:beats_online/models/loading_enum.dart';
import 'package:beats_online/models/song_model.dart';
import 'package:beats_online/models/user.dart';

class Homestate {
  final LoadPage status;
  final List<User> users;
  final List<SongModel> songs;
  Homestate({
    required this.status,
    required this.users,
    required this.songs,
  });
  factory Homestate.initial() {
    return Homestate(
      status: LoadPage.initial,
      users: [],
      songs: [],
    );
  }
  Homestate copyWith({
    LoadPage? status,
    List<User>? users,
    List<SongModel>? songs,
  }) {
    return Homestate(
      status: status ?? this.status,
      users: users ?? this.users,
      songs: songs ?? this.songs,
    );
  }
}
