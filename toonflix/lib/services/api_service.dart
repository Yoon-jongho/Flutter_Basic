import 'dart:convert';

import 'package:http/http.dart' as http;
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
}
