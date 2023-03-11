import 'package:flutter/material.dart';
import 'package:term_project_mobile/pages/home/home.page.dart';
import '../../../entities/Plant.dart';
import '../componets/plantCard.componet.dart';

class PlantSlider extends StatelessWidget {
  const PlantSlider({
    required this.plantList,
  });
  final List<Plant> plantList;

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];
    for (int i = 0; i < plantList.length; i++) {
      widgetList.add(
        PlantCard(
          image: plantList[i].imageUrl,
          title: plantList[i].name,
          country: plantList[i].optimumHum.toString(),
          price: plantList[i].optimumTemp,
          press: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ),
            );
          },
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: widgetList),
    );
  }
}
