import 'package:flutter/material.dart';
import 'package:toonflix/screens/detail_screen.dart';

class Webtoon extends StatelessWidget {
  final String title, thumb, id;

  const Webtoon({
    super.key,
    required this.title,
    required this.thumb,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            // MaterialPageRoute는 StatelessWidget을 route로 감싸서 다른 스크린처럼 보이게 만들어줌
            builder: (context) => DetailScreen(
              title: title,
              thumb: thumb,
              id: id,
            ),
            fullscreenDialog: true, // fullscreenDialog를 반영하면 뒤로가기버튼이 x버튼으로 바뀜
          ),
        );
      },
      child: Column(
        children: [
          Hero(
            tag: id,
            child: Container(
              width: 250,
              clipBehavior:
                  Clip.hardEdge, // clipBehavior는 자식의 부모 영역 침범을 제어하는 방법임
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    offset: Offset(10, 10), // 그림자의 위치를 정함
                    color: Colors.black.withAlpha(128),
                  ),
                ],
              ),
              child: Image.network(
                thumb,
                headers: const {
                  "User-Agent":
                      "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36"
                },
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 22,
            ),
          ),
        ],
      ),
    );
  }
}
