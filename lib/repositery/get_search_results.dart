import 'dart:convert';

import 'package:beats_online/api/url.dart';
import 'package:beats_online/methods/get_response.dart';
import 'package:beats_online/models/song_model.dart';
import 'package:beats_online/models/user.dart';
import 'package:http/http.dart';

class SearchRepository {
  Future<List<User>> getUsers(String tag) async {
    final query = {
      'page': 0.toString(),
      'limit': 50.toString(),
      'q': tag,
    };
    Response res = await getResponse(
        Uri.https(baseUrl, '$basePath/search/artists', query));
    if (res.statusCode == 200) {
      var body = jsonDecode(res.body);
      return (body['results'] as List).map((e) => User.fromJson(e)).toList();
    } else {
      throw Exception('failed fetch users');
    }
  }

  Future<List<SongModel>> getSongs(String tag) async {
    final query = {
      'page': 0.toString(),
      'limit': 50.toString(),
      'q': tag,
    };
    Response res =
        await getResponse(Uri.https(baseUrl, '$basePath/search/songs', query));
    if (res.statusCode == 200) {
      var body = jsonDecode(res.body);
      return (body['results'] as List)
          .map((e) => SongModel.fromJson(e))
          .toList();
    } else {
      throw Exception("failed fetch songs");
    }
  }
}
