import 'package:beats_online/models/loading_enum.dart';
import 'package:beats_online/repositery/get_home_page.dart';
import 'package:beats_online/screens/home/cubit/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<Homestate> {
  final repo = GetHomePage();
  HomeCubit() : super(Homestate.initial());
  void getUsers() async {
    try {
      emit(state.copyWith(status: LoadPage.loading));
      emit(state.copyWith(
        users: await repo.getUsers(),
        songs: await repo.getSongs(),
        status: LoadPage.loaded,
      ));
    } catch (e) {
      print(e.toString());
      emit(state.copyWith(status: LoadPage.error));
    }
  }
}
