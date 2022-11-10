import 'package:beats_online/controller/main_controller.dart';
import 'package:beats_online/models/loading_enum.dart';
import 'package:beats_online/repositery/get_genre_data.dart';
import 'package:beats_online/screens/genre_page/cubit/genre_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GenereCubit extends Cubit<GenreState> {
  final repo = GenereRepository();
  GenereCubit() : super(GenreState.initial());
  void init(String tag) async {
    try {
      emit(state.copyWith(status: LoadPage.loading));
      var users = await repo.getUsers(tag);
      var songs = await repo.getSongs(tag);
      emit(state.copyWith(
        status: LoadPage.loaded,
        users: users,
        songs: songs,
      ));
    } catch (e) {
      emit(state.copyWith(status: LoadPage.error));
    }
  }

  void playSong(MainController controller, int initial) {
    controller.playSong(controller.convertToAudio(state.songs), initial);
  }
}
