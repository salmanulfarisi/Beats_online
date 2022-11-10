import 'dart:ui';

import 'package:beats_online/controller/main_controller.dart';
import 'package:beats_online/methods/string_methods.dart';
import 'package:beats_online/models/catagory.dart';
import 'package:beats_online/models/loading_enum.dart';
import 'package:beats_online/screens/genre_page/cubit/genre_cubit.dart';
import 'package:beats_online/screens/genre_page/cubit/genre_state.dart';
import 'package:beats_online/utils/bottom_sheet_widget.dart';
import 'package:beats_online/utils/horizontal_songs.dart';
import 'package:beats_online/utils/loading.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GenrePage extends StatelessWidget {
  final TagsModel tag;
  final MainController con;
  const GenrePage({Key? key, required this.tag, required this.con})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final devicePexelRatio = MediaQuery.of(context).devicePixelRatio;
    final width = MediaQuery.of(context).size.width;
    return BlocProvider(
      create: (context) => GenereCubit()..init(tag.tag),
      child: BlocBuilder<GenereCubit, GenreState>(
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
              body: CustomScrollView(
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
                              imageUrl: tag.image,
                              height: 200,
                              memCacheHeight: (200 * devicePexelRatio).round(),
                              memCacheWidth: (width * devicePexelRatio).round(),
                              maxHeightDiskCache:
                                  (200 * devicePexelRatio).round(),
                              maxWidthDiskCache:
                                  (width * devicePexelRatio).round(),
                              fit: BoxFit.cover,
                            ),
                            BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                              child: Container(
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Colors.black,
                                    Colors.black.withOpacity(0.3),
                                  ],
                                )),
                                height: 250,
                                width: MediaQuery.of(context).size.width,
                              ),
                            )
                          ],
                        ),
                      ),
                      title: Text(
                        tag.tag.toTitleCase(),
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 24.0, horizontal: 16.0),
                      child: Text(
                        "Best Artists",
                        style: Theme.of(context)
                            .textTheme
                            .headline4!
                            .copyWith(fontSize: 18.0),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: HorizontalArtistList(
                      users: state.users,
                      con: con,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 24.0, horizontal: 16),
                      child: Text(
                        "${tag.tag.toTitleCase()} Songs",
                        style: Theme.of(context).textTheme.headline4!.copyWith(
                              fontSize: 18,
                            ),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (_, i) {
                        bool isPlaying = con.player.getCurrentAudioTitle ==
                            state.songs[i].songname;
                        return InkWell(
                          onTap: () {
                            BlocProvider.of<GenereCubit>(context)
                                .playSong(con, i);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                    child: Row(children: [
                                  Text(
                                    (i + 1).toString(),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(3),
                                    child: CachedNetworkImage(
                                      imageUrl: state.songs[i].coverImageUrl!,
                                      height: 50,
                                      width: 50,
                                      memCacheHeight:
                                          (50 * devicePexelRatio).round(),
                                      memCacheWidth:
                                          (50 * devicePexelRatio).round(),
                                      maxHeightDiskCache:
                                          (50 * devicePexelRatio).round(),
                                      maxWidthDiskCache:
                                          (50 * devicePexelRatio).round(),
                                      progressIndicatorBuilder:
                                          (context, u, l) =>
                                              const LoadingImage(),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            state.songs[i].songname!,
                                            maxLines: 1,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1!
                                                .copyWith(
                                                  color: isPlaying
                                                      ? Colors
                                                          .lightGreenAccent[700]
                                                      : Colors.white,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            state.songs[i].duration!,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1!
                                                .copyWith(
                                                  color: Colors.grey,
                                                ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ])),
                                IconButton(
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
                                          song: state.songs[i],
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.more_vert,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      childCount: state.songs.length,
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(
                      height: 150,
                    ),
                  )
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
