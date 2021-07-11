import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blueAccent,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> nav = ['Мои фото', 'Галерея'];

  Map<String, dynamic> data = {
    'Мои фото': [
      'https://picsum.photos/1200/501',
      'https://picsum.photos/1200/502',
      'https://picsum.photos/1200/503',
      'https://picsum.photos/1200/504',
      'https://picsum.photos/1200/505',
      'https://picsum.photos/1200/506',
      'https://picsum.photos/1200/507',
      'https://picsum.photos/1200/508',
      'https://picsum.photos/1200/509',
      'https://picsum.photos/1200/510',
    ],
    'Галерея': [
      'https://picsum.photos/1200/511',
      'https://picsum.photos/1200/512',
      'https://picsum.photos/1200/513',
      'https://picsum.photos/1200/514',
      'https://picsum.photos/1200/515',
      'https://picsum.photos/1200/516',
      'https://picsum.photos/1200/517',
      'https://picsum.photos/1200/518',
      'https://picsum.photos/1200/519',
      'https://picsum.photos/1200/520',
    ]
  };

  @override
  Widget build(BuildContext context) {
    // Получим ширину экрана устройства
    double widthScreen = MediaQuery.of(context).size.width;

    return DefaultTabController(
      length: nav.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text('Домашняя работа №4'),
          ),
          elevation: 0,
          bottom: TabBar(
            tabs: nav.map((String item) => Tab(text: item)).toList(),
          ),
        ),
        body: TabBarView(
          children: nav.map((tabName) {
            return ListView(
              key: PageStorageKey(tabName),
              children: <Widget>[
                // Дополнительно передаем в Карточку реальную ширину экрана
                for (var item in data[tabName])
                  PhotoCard(urlImage: item, widthScreen: widthScreen),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

class PhotoCard extends StatelessWidget {
  final String urlImage;
  // Обещаем что позже эта переменная не будет NULL
  late Map<String, double> sizeImage;
  double widthScreen;
  // Дефолтная заглушка если null
  static const String nullUrl = 'https://picsum.photos/200/200';

  PhotoCard({Key? key, this.urlImage = nullUrl, this.widthScreen = 300})
      : super(key: key) {
    // На этапе конструктора получаем ширину и высоту для плэйсхолдера
    sizeImage = getSizeImage(urlImage, widthScreen);
  }

  // Функция для получения идеально точного плэйсхолдера из ссылки
  Map<String, double> getSizeImage(String url, double widthScreen) {
    // Разбиваем ссылку
    List<String> list = url.split('/');
    // Знаем что в конце высота, берем ее
    double height = double.parse(list.last);
    // Удаляем высоту из массива
    list.removeLast();
    // Теперь последний элемент это ширина
    double width = double.parse(list.last);
    // Считаем коэффициент уменьшения, ширину картинки делим на реальную ширину экрана устройства
    double ratio = width / widthScreen;
    // Возвращаем массив данных
    return <String, double>{
      'height': height / ratio,
      'width': width / ratio,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Image.network(
          urlImage,
          frameBuilder: (BuildContext context, Widget child, int? frame,
              bool wasSynchronouslyLoaded) {
            if (wasSynchronouslyLoaded) return child;
            return Container(
              height: sizeImage['height'],
              width: sizeImage['width'],
              color: Colors.black26,
              child: const Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            );
          },
        ),
      ),
    );
  }
}
