import 'package:flutter/material.dart';
import 'package:toonflix/models/webtoon_model.dart';
import 'package:toonflix/services/api_service.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final Future<List<WebtoonModel>> webtoons = ApiService.getTodaysToons();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        shadowColor: Colors.black, // 그림자 색상
        elevation: 9.0, // 그림자 깊이 (값을 높이면 그림자가 더 길어짐)
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        title: const Text(
          "오늘의 웹툰s",
          style: TextStyle(
            fontSize: 24,
          ),
        ),
      ),
      body: FutureBuilder(
        // futurebuilder는 await 을 해주는 위젯, future 값을 기다리고 데이터가 존재하는지 알려줌
        future: webtoons,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
              // ListView.builder는 사용자가 보고 있는 아이템만 build함
              // ListView.separated는 필수인자를 하나 더가짐(separatorBuilder)
              // separatorBuilder는 Widget을 리턴하고 그 widget은 리스트 아이템 사이에 렌더링됨
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                print(index);
                var webtoon = snapshot.data![index];
                return Text(webtoon.title);
              },
              separatorBuilder: (context, index) => SizedBox(
                width: 20,
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
