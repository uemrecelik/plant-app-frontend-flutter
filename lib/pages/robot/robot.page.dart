import 'package:flutter/material.dart';
import 'package:roslib/roslib.dart';

class RobotPage extends StatefulWidget {
  const RobotPage({Key? key});

  @override
  State<RobotPage> createState() => _RobotPageState();
}

class _RobotPageState extends State<RobotPage> {
  late Ros ros;
  late Topic cmdVel;
  late Topic testStdMessage;
  late Topic poseMsg;

  @override
  void initState() {
    super.initState();

    // Initialize ROSBridge client
    ros = Ros(url: 'ws://172.20.10.3:9090');
    ros.connect();

    // Set up topic for sending commands
    cmdVel = Topic(
      ros: ros,
      name: 'turtle1/cmd_vel',
      type: 'geometry_msgs/Twist',
    );
    poseMsg = Topic(
      ros: ros,
      name: '/words',
      type: 'geometry_msgs/Pose',
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text('Go to 1'),
          onPressed: () {
            /*cmdVel.publish({
              'linear': {'x': 5, 'y': 0.0, 'z': 0.0},
              'angular': {'x': 2.0, 'y': 1.0, 'z': 2.0},
            });
*/
            //Map<String, dynamic> json = {"data": 'HElllloooooo'};
            //testStdMessage.publish(json);
            /* Map<String, dynamic> json = {
              'Point': {'x': 1, 'y': 4, 'z': 0},
            };*/
            poseMsg.publish({
              'position': {'x': 1, 'y': 4, 'z': 0},
            });
          },
        ),
      ),
    );
  }
}
