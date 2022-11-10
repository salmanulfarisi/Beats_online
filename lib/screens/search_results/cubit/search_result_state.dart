import 'package:beats_online/controller/main_controller.dart';
import 'package:beats_online/models/loading_enum.dart';
import 'package:beats_online/repositery/get_search_results.dart';
import 'package:beats_online/screens/search_results/cubit/search_results_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchResultsCubit extends Cubit<SearchResultsState> {
  final repo = SearchRepository();
  SearchResultsCubit() : super(SearchResultsState.initial());
  void searchSongs(String tag) async {
    if (state.isSong) {
      try {
        emit(state.copyWith(status: LoadPage.loading));
        var songs = await repo.getSongs(tag.toString());
        emit(state.copyWith(status: LoadPage.loaded, songs: songs));
      } catch (e) {
        emit(state.copyWith(status: LoadPage.error));
      }
    } else {
      try {
        emit(state.copyWith(status: LoadPage.loading));
        var users = await repo.getUsers(tag.toString());
        emit(state.copyWith(status: LoadPage.loaded, users: users));
      } catch (e) {
        emit(state.copyWith(status: LoadPage.error));
      }
    }
  }

  void playSongs(MainController controller, int initial) {
    controller.playSong(controller.convertToAudio(state.songs), initial);
  }

  void isNullToggle() {
    emit(state.copyWith(isNull: !state.isNull));
  }

  void isSongToggle() {
    emit(state.copyWith(isSong: !state.isSong));
  }
}
