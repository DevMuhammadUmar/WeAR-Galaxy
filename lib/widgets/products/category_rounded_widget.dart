import 'package:flutter/material.dart';
import 'package:weargalaxy/Screens/search_screen.dart';
import 'package:weargalaxy/widgets/subtitles_text.dart';

class CategoryRoundedWidget extends StatelessWidget {
  final String image,name;
  const CategoryRoundedWidget({super.key, required this.image, required this.name});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, SearchScreen.routeName, arguments: name);
      },
      child: Column(
        children: [
          Image.asset(image,height: 100,width: 100,),
          SubtitleTextWidget(label: name,fontSize: 14,fontWeight: FontWeight.bold),
        ],
      ),
    );
  }
}