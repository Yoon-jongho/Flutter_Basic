class WebtoonModel {
  final String title, thumb, id;

  // dart식 생성자 만드는 방법 다시 찾아볼것
  WebtoonModel.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        thumb = json['thumb'],
        id = json['id'];
}
