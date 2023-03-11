import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../../constants.dart';

class graphCard extends StatelessWidget{

    graphCard({
            required this.value,
            required this.isTemp,
          });
        int value;
        bool isTemp = true;

  @override
  Widget build(BuildContext context) {    
    return 
    Card(
      shape: RoundedRectangleBorder(
      side: BorderSide(
      color: darkGreyColor.withOpacity(0.20),
    ),
    borderRadius: BorderRadius.circular(20.0), //<-- SEE HERE
  ),
      child: Container(
        width: 140,
      margin: const EdgeInsets.only(
          left: defaultPadding,
          top: defaultPadding / 2,
          bottom: defaultPadding * 2.5,
          right: 10
        ),
           
          child: Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircularPercentIndicator(
                  animation: true,
                  animationDuration: 1000,
                  radius: 150,
                  lineWidth: 20,
                  percent: value/100,
                  progressColor: isTemp ? Colors.red : Colors.blue,
                  backgroundColor: darkGreyColor.withOpacity(0.25),
                  circularStrokeCap: CircularStrokeCap.round,
                  center: Text(
                    isTemp ? '$value C' : '$value %',
                    style: TextStyle(fontSize: 25,color: isTemp ? Colors.red : Colors.blue),
                  
                  ),
                ),
               
              ],
            ),
          ),
        ),
    );  
    throw UnimplementedError();
  }

}