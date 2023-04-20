import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:term_project_mobile/entities/GraphData.dart';

class PlantGraph extends StatelessWidget {
  final List<GraphData> graphDataList;
  final String? title;
  final String? plant;

  PlantGraph({Key? key, required this.graphDataList, this.title, this.plant})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<GraphData> tempData = graphDataList.map((graphData) {
      return GraphData(
        date: graphData.date,
        temperature: graphData.temperature,
      );
    }).toList();

    List<GraphData> humData = graphDataList.map((graphData) {
      return GraphData(
        date: graphData.date,
        humidity: graphData.humidity,
      );
    }).toList();

    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: SfCartesianChart(
          primaryXAxis: CategoryAxis(),
          title: ChartTitle(text: '$title graph for $plant'),
          legend: Legend(
            isVisible: true,
          ),
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <ChartSeries<GraphData, String>>[
            LineSeries<GraphData, String>(
                dataSource: tempData,
                xValueMapper: (GraphData graphData, _) => graphData.date,
                yValueMapper: (GraphData graphData, _) => graphData.temperature,
                name: 'Temp',
                dataLabelSettings: DataLabelSettings(isVisible: true),
                color: Color.fromARGB(255, 255, 0, 0)),
            LineSeries<GraphData, String>(
                dataSource: humData,
                xValueMapper: (GraphData graphData, _) => graphData.date,
                yValueMapper: (GraphData graphData, _) => graphData.humidity,
                name: 'Hum',
                dataLabelSettings: DataLabelSettings(isVisible: true),
                color: Color.fromARGB(255, 30, 0, 255)),
          ],
        ),
      ),
    );
  }
}
