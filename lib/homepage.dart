import 'package:flutter/material.dart';
import 'main.dart';
import 'widgets/catcard.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<String> images = [
    'https://i.pinimg.com/564x/7e/48/47/7e4847c66a792d46fa3a4a718a44e0c9.jpg',
    'https://thumbs.dreamstime.com/z/back-to-school-vector-illustration-cartoon-kids-going-isolated-white-background-108997382.jpg',
    'https://image.shutterstock.com/image-vector/man-woman-traveling-together-260nw-157226846.jpg',
    'https://i.pinimg.com/564x/ed/bf/ca/edbfca9d899421946f8f4c36362e9ba5.jpg',
    'https://p.globalsources.com/IMAGES/PDT/BIG/737/B1103998737.jpg',
    'https://previews.123rf.com/images/jtanki/jtanki1703/jtanki170300004/73111576-simple-business-cartoon-vector-illustration-icon-running-late-to-go-to-office.jpg',
    'https://d2j1mo4repc142.cloudfront.net/cdn/337447/media/catalog/product/cache/1/image/265x/9df78eab33525d08d6e5fb8d27136e95/placeholder/default/skybags-placeholder.jpg'
  ];

  List<String> categories = [
    'College',
    'Kids',
    'Travelling',
    'Trekking',
    'Laptop',
    'Office',
    'Skybags'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Astron Bags',
          style: TextStyle(color: astronColor),
        ),
      ),
      body: SafeArea(
        child: GridView.builder(
            itemCount: 7,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0),
            itemBuilder: (context, index) {
              return catCard(
                imgLink: images[index],
                title: categories[index],
              );
            }),
      ),
    );
  }
}