import 'package:beats_online/controller/main_controller.dart';
import 'package:beats_online/models/loading_enum.dart';
import 'package:beats_online/screens/home/cubit/home_cubit.dart';
import 'package:beats_online/screens/home/cubit/home_state.dart';
import 'package:beats_online/utils/horizontal_songs.dart';
import 'package:beats_online/utils/recent_users.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  final MainController con;
  const HomeScreen({
    Key? key,
    required this.con,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()..getUsers(),
      child: BlocBuilder<HomeCubit, Homestate>(
        builder: (context, state) {
          if (state.status == LoadPage.loading) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (state.status == LoadPage.loaded) {
            return Scaffold(
              body: ListView(
                children: [
                  RecentUsers(
                    con: con,
                    users: state.users.sublist(0, 6),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8),
                    child: Text(
                      "Popular Hits",
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ),
                  HorizontalSongList(
                      con: con, songs: state.songs.sublist(0, 10)),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8),
                    child: Text(
                      "Best Picks For You",
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ),
                  HorizontalArtistList(
                      con: con, users: state.users.sublist(6, 16)),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8),
                    child: Text(
                      "New Releases",
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ),
                  HorizontalSongList(
                      con: con, songs: state.songs.sublist(10, 20)),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8),
                    child: Text(
                      "You might also like",
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ),
                  HorizontalArtistList(
                      con: con, users: state.users.sublist(16)),
                  const SizedBox(height: 12),
                ],
              ),
            );
          }
          if (state.status == LoadPage.error) {
            return const Scaffold(
              body: Center(
                child: Text(
                  "Error",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          }

          return Container();
        },
      ),
    );
  }
}
