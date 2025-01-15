import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:toonflix/models/webtoon_detail_model.dart';
import 'package:toonflix/models/webtoon_episode_model.dart';
import 'package:toonflix/models/webtoon_model.dart';

class ApiService {
  static const String baseUrl =
      "http://webtoon-crawler.nomadcoders.workers.dev";
  static const String today = "today";

// get함수의 리턴값은 Future 즉, 통신후에 값이 정해지고
// 이를 위해선 비동기 처리를 해줘야함
// 그래서 get함수의 값이 나올때까지 코드를 기다려 달라는 키워드가 await
// 그리고 그 await은 async 가 붙은 함수에서만 쓸 수 있음
// async가 들어간 함수의 리턴값은 Future 여야함
  static Future<List<WebtoonModel>> getTodaysToons() async {
    // Dart에서 메서드나 변수에 static을 사용하면 인스턴스를 생성하지 않고도 직접 접근하여 사용 가능함
    //-> 인스턴스 만들필요 없이 바로 호출해서 쓰니까 메모리 절약
    List<WebtoonModel> webtoonInstances = [];
    final url = Uri.parse('$baseUrl/$today');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> webtoons = jsonDecode(response.body);
      for (var webtoon in webtoons) {
        final toon = WebtoonModel.fromJson(webtoon);
        webtoonInstances.add(toon);
      }
      return webtoonInstances;
    }
    throw Error();
  }

  static Future<WebtoonDetailModel> getToonById(String id) async {
    final url = Uri.parse("$baseUrl/$id");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final webtoon = jsonDecode(response.body);
      return WebtoonDetailModel.fromJson(webtoon);
    }
    throw Error();
  }

  static Future<List<WebtoonEpisodeModel>> getLatestEpisodesById(
      String id) async {
    List<WebtoonEpisodeModel> episodesInstances = [];
    final url = Uri.parse("$baseUrl/$id/episodes");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final episodes = jsonDecode(response.body);
      for (var episode in episodes) {
        episodesInstances.add(WebtoonEpisodeModel.fromJson(episode));
      }
      return episodesInstances;
    }
    throw Error();
  }
}
