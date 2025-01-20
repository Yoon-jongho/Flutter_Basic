import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toonflix/models/webtoon_detail_model.dart';
import 'package:toonflix/models/webtoon_episode_model.dart';
import 'package:toonflix/services/api_service.dart';
import 'package:toonflix/widgets/episode_widget.dart';

class DetailScreen extends StatefulWidget {
  final String title, thumb, id;

  // stateless 위젯일땐 webtoon property를 초기화할 때 다른 property인 id에 대한 접근이 불가능하다
  // 우리가 할 수 있는건 class의 member들을 define하고 초기화하는 것 뿐임
  // 따라서 어떤 property를 초기화 할 때 다른 property로는 접근할 수 없음 -> 접근하기 위해서 stateful위젯으로 바꿔줘야함
  // Future<WebtoonDetailModel> webtoon = ApiService.getToonById(id);

  const DetailScreen({
    super.key,
    required this.title,
    required this.thumb,
    required this.id,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<WebtoonDetailModel> webtoon;
  late Future<List<WebtoonEpisodeModel>> episodes;
  late SharedPreferences prefs;
  bool isLiked = false;

  Future initPrefs() async {
    prefs = await SharedPreferences
        .getInstance(); // 사용자의 저장소에 connection 인스턴스가 생김(핸드폰 내부의 저장공간얻음)
    final likedToons = prefs.getStringList('likedToons');

    if (likedToons != null) {
      if (likedToons.contains(widget.id)) {
        setState(() {
          isLiked = true;
        });
      }
    } else {
      await prefs.setStringList(
        'likedToons',
        [],
      );
    }
  }

  @override
  void initState() {
    super.initState();
    webtoon = ApiService.getToonById(widget.id);
    episodes = ApiService.getLatestEpisodesById(widget.id);
    initPrefs();
  }

  onHeartTap() async {
    prefs = await SharedPreferences.getInstance();
    final likedToons = prefs.getStringList('likedToons');
    if (likedToons != null) {
      if (isLiked) {
        likedToons.remove(widget.id);
      } else {
        likedToons.add(widget.id);
      }
      await prefs.setStringList('likedToons', likedToons);
      setState(() {
        isLiked = !isLiked;
      });
    }
  }

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
        actions: [
          IconButton(
            onPressed: onHeartTap,
            icon: Icon(
              isLiked ? Icons.favorite : Icons.favorite_outline_rounded,
            ),
          ),
        ],
        title: Text(
          // stateless일 땐 초기화된 property인 title만 적혀 있었다 -> stateful 위젯으로 변환한 순간 state 클래스가 됨
          // stateful로 변환하는 순간 별개의 클래스가 되고 그 안에서 title이라는 property를 찾을 수 없다.
          // 사용자가 webtoon_widget 을 탭하면 Navifator가 진행이되고 DetailScreen을 빌드하고 title, thumbnail, id 를 전달함
          // 이러한 데이터들은 여기 state 까지 전달되지 않았는데 여전히 해당 dara에 접근하고 싶음
          // 그러려면 widget.데이터 를 써주면됨.
          // 여기에서 쓰인 widget 이란건 현재 이 state클래스의 위에있는 클래스임 (DetailScreen)
          //-> 이것이 state가 속한 StatefulWidget의 데이터를 받아오는 방법
          widget.title,
          style: TextStyle(
            fontSize: 24,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 30,
            horizontal: 17,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: widget.id,
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
                        widget.thumb,
                        headers: const {
                          "User-Agent":
                              "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36"
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 25,
              ),
              FutureBuilder(
                future: webtoon,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          snapshot.data!.about,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          '${snapshot.data!.genre} / ${snapshot.data!.age}',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    );
                  }
                  return Text("...");
                },
              ),
              SizedBox(
                height: 25,
              ),
              FutureBuilder(
                  future: episodes,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: [
                          for (var episode in snapshot.data!)
                            Episode(
                              episode: episode,
                              webtoonId: widget.id,
                            )
                        ],
                      );
                    }
                    return Container();
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
