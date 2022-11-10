import 'dart:ui';

import 'package:beats_online/controller/main_controller.dart';
import 'package:beats_online/methods/snackbar.dart';
import 'package:beats_online/models/song_model.dart';
import 'package:beats_online/utils/bottom_sheet_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PlaylistSongs extends StatelessWidget {
  final MainController con;
  final String name;
  final String coverImage;
  const PlaylistSongs(
      {Key? key,
      required this.con,
      required this.name,
      required this.coverImage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final devicePexelRatio = MediaQuery.of(context).devicePixelRatio;
    List<dynamic> data = [];
    return Scaffold(
        body: FutureBuilder<Box<dynamic>>(
      future: Hive.openBox(name),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 200,
                backgroundColor: Colors.black,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  collapseMode: CollapseMode.pin,
                  background: ClipRRect(
                    child: Stack(
                      children: [
                        CachedNetworkImage(
                          imageUrl: coverImage,
                          height: 200,
                          memCacheHeight: (200 * devicePexelRatio).round(),
                          memCacheWidth: (MediaQuery.of(context).size.width *
                                  MediaQuery.of(context).devicePixelRatio)
                              .round(),
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.cover,
                        ),
                        BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.center,
                                colors: [
                                  Colors.black,
                                  Colors.black.withOpacity(0.5),
                                ],
                              ),
                            ),
                            height: 250,
                            width: MediaQuery.of(context).size.width,
                          ),
                        ),
                      ],
                    ),
                  ),
                  title: Text(
                    name,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 170.0),
                  child: Text(
                    "${Hive.box('playlists').length} Songs",
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14.0,
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: ValueListenableBuilder<Box>(
                  valueListenable: Hive.box(name).listenable(),
                  builder: (context, box, child) {
                    if (box.isEmpty) {
                      return const SizedBox(
                        height: 300,
                        child: Center(
                          child: Text(
                            "You don't have any songs in this playlist",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: box.length,
                      itemBuilder: (context, i) {
                        final info = Hive.box(name).getAt(i);
                        data.add(info);
                        return Dismissible(
                          key: Key(info['songname'].toString()),
                          onDismissed: (directon) {
                            box.deleteAt(i);
                            context.showSnackBar(
                                message: "Removed from playlist");
                          },
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            child: const Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Icon(
                                CupertinoIcons.delete,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          child: ListTile(
                            onTap: () {
                              con.playSong(con.converLocalSongToAudio(data), i);
                            },
                            leading: CachedNetworkImage(
                              imageUrl: info['cover'],
                              height: 50,
                              width: 50,
                              memCacheHeight: (70 * devicePexelRatio).round(),
                              memCacheWidth: (70 * devicePexelRatio).round(),
                              maxHeightDiskCache:
                                  (70 * devicePexelRatio).round(),
                              maxWidthDiskCache:
                                  (70 * devicePexelRatio).round(),
                              fit: BoxFit.cover,
                            ),
                            title: Text(
                              info['songname'],
                              maxLines: 1,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            subtitle: Text(
                              info['fullname'],
                              style: const TextStyle(color: Colors.grey),
                            ),
                            trailing: IconButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    useRootNavigator: true,
                                    isScrollControlled: true,
                                    elevation: 100,
                                    backgroundColor: Colors.black38,
                                    builder: (context) {
                                      return BottomSheetWidget(
                                        con: con,
                                        song: SongModel(
                                          songid: info['id'],
                                          songname: info['songname'],
                                          userid: info['username'],
                                          trackid: info['track'],
                                          duration: '',
                                          coverImageUrl: info['cover'],
                                          name: info['fullname'],
                                        ),
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(
                                  Icons.more_vert,
                                  color: Colors.white,
                                )),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 150,
                ),
              )
            ],
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    ));
  }
}
