import 'package:beats_online/controller/main_controller.dart';
import 'package:beats_online/models/loading_enum.dart';
import 'package:beats_online/repositery/get_artist_data.dart';
import 'package:beats_online/screens/artist_profile/cubit/artist_profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ArtistProfileCubit extends Cubit<ArtistProfileState> {
  final repo = GetArtistData();
  ArtistProfileCubit() : super(ArtistProfileState.initial());
  void getUser(String id) async {
    try {
      emit(state.copyWith(status: LoadPage.loaded));
      emit(state.copyWith(
          songs: await repo.getSongs(id),
          user: await repo.getUserData(id),
          status: LoadPage.loaded));
    } catch (e) {
      emit(state.copyWith(status: LoadPage.error));
    }
  }

  void playSongs(MainController controller, int initial) {
    controller.playSong(controller.convertToAudio(state.songs), initial);
  }
}
