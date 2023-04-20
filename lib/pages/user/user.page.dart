import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:numberpicker/numberpicker.dart';

import '../../constants.dart';
import '../../entities/Plant.dart';
import '../../entities/User.dart';
import '../home/home.service.dart';
import '../login/login.page.dart';
import '../login/login.servide.dart';
import 'package:http/http.dart' as http;

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  int _value1 = 1;
  int _value2 = 1;
  int _selectedIndex = -1;
  late User userData;
  late User currentUser;
  late List<Plant> userPlants;
  bool isUserLoading = true;
  bool isPlantDataLoading = true;
  bool isLoaded = false;
  FlutterSecureStorage storage = LoginService().storage;

  TextEditingController _textEditingController1 = TextEditingController();
  TextEditingController _textEditingController2 = TextEditingController();

  bool _isEditable1 = false;
  bool _isEditable2 = false;

  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    currentUser = await HomeService().fetchUser();
    getUserPlants(currentUser);
    getUserData(currentUser);
  }

  void getUserPlants(user) async {
    userPlants = await HomeService().fetchPlants(user) as List<Plant>;
    setState(() {
      isPlantDataLoading = false;
      isLoaded = true;
    });
  }

  void getUserData(currentUser) async {
    userData = await HomeService().getUserData(currentUser);
    setState(() {
      isUserLoading = false;
    });
  }

  void updateUserName(username) async {
    int userId = currentUser.userId ?? 1;
    final String? token = await storage.read(key: 'jwt');
    String url =
        'https://yu-term-project.herokuapp.com/user/update-username?username=$username&id=$userId';
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    getUserData(currentUser);
  }

  void updateUserEmail(email) async {
    int userId = currentUser.userId ?? 1;
    final String? token = await storage.read(key: 'jwt');
    String url =
        'https://yu-term-project.herokuapp.com/user/update-email?email=$email&id=$userId';
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    getUserData(currentUser);
  }

  void updateHumOrTemp(value, plantId, isTemp) async {
    String path = isTemp ? 'update-temp' : 'update-hum';
    final String? token = await storage.read(key: 'jwt');
    String url =
        'https://yu-term-project.herokuapp.com/plants/$path?value=$value&id=$plantId';
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    getUserData(currentUser);
  }

  @override
  Widget build(BuildContext context) {
    String image = '';
    String email = '';
    String username = '';
    if (isLoaded) {
      setState(() {
        image = userData.imgUrl ?? '';
        email = userData.email ?? '';
        username = userData.username ?? '';
      });
    }
    return !isLoaded
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(
              title: const Text('User Settings'),
              backgroundColor: deepGreenColor,
              leading: IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ));
                },
              ),
            ),
            body: Center(
                child: Container(
              child: Column(children: [
                const SizedBox(
                  height: 20,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                      50), // 50, yarım çapa karşılık gelir ve bu değer profil fotoğrafının yuvarlaklığını belirler.
                  child: Image.network(
                    image,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10, left: 30, top: 20),
                  child: Row(children: [
                    Expanded(
                      child: TextField(
                        controller: _textEditingController1,
                        enabled: _isEditable1,
                        decoration: InputDecoration(
                          hintText: username,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: _isEditable1
                          ? IconButton(
                              icon: const Icon(Icons.save),
                              onPressed: () {
                                updateUserName(_textEditingController1.text);
                                setState(() {
                                  _isEditable1 = !_isEditable1;
                                  if (!_isEditable1) {
                                    // Save Text 1
                                  }
                                });
                              },
                            )
                          : Icon(Icons.edit),
                      onPressed: () {
                        setState(() {
                          _isEditable1 = !_isEditable1;
                          if (!_isEditable1) {
                            // Save Text 1
                          }
                        });
                      },
                    ),
                    Expanded(
                      child: TextField(
                        controller: _textEditingController2,
                        enabled: _isEditable2,
                        decoration: InputDecoration(
                          hintText: email,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: _isEditable2
                          ? IconButton(
                              icon: const Icon(Icons.save),
                              onPressed: () {
                                updateUserEmail(_textEditingController2.text);
                                setState(() {
                                  _isEditable2 = !_isEditable2;
                                  if (!_isEditable2) {
                                    // Save Text 1
                                  }
                                });
                              },
                            )
                          : Icon(Icons.edit),
                      onPressed: () {
                        setState(() {
                          _isEditable2 = !_isEditable2;
                          if (!_isEditable2) {
                            // Save Text 2
                          }
                        });
                      },
                    ),
                  ]),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Divider(
                  color: darkGreyColor,
                  thickness: 0.5,
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 300,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: userPlants.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: Card(
                          child: ListTile(
                            title: Text('Card ${index + 1}'),
                            subtitle: Text(
                                'This is the subtitle of Card ${index + 1}'),
                            leading: Image.network(
                              userPlants[index].imageUrl,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.arrow_upward),
                              onPressed: () {
                                setState(() {
                                  _selectedIndex = index;
                                });
                                _showModalPage(context, index);
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ]),
            )),
          );
  }

  void _showModalPage(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        String optimumTemp = userPlants[index].optimumTemp.toString() ?? '0';
        String optimumHum = userPlants[index].optimumHum.toString() ?? '0';
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      userPlants[index].name,
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[800],
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        userPlants[index].imageUrl,
                        height: 200.0,
                        width: 200.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      userPlants[index].description,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 40),
                      child: Row(
                        children: [
                          ElevatedButton(
                            child: Text('Temperature: $optimumTemp'),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red, // background color
                            ),
                            onPressed: () async {
                              final result = await showDialog<int>(
                                context: context,
                                builder: (context) => NumberPickerModal(
                                  minValue: 1,
                                  maxValue: 100,
                                  isTemp: true,
                                  userPlant: userPlants[index],
                                ),
                              );
                              if (result != null) {
                                setState(() {
                                  _value1 = result;
                                });
                              }
                            },
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                            child: Text('Humidity: $optimumHum'),
                            onPressed: () async {
                              final result = await showDialog<int>(
                                context: context,
                                builder: (context) => NumberPickerModal(
                                  minValue: 1,
                                  maxValue: 100,
                                  isTemp: false,
                                  userPlant: userPlants[index],
                                ),
                              );
                              if (result != null) {
                                setState(() {
                                  _value2 = result;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class NumberPickerModal extends StatefulWidget {
  final int minValue;
  final int maxValue;
  final Plant userPlant;
  final bool isTemp;

  NumberPickerModal(
      {required this.minValue,
      required this.maxValue,
      required this.userPlant,
      required this.isTemp});

  @override
  _NumberPickerModalState createState() => _NumberPickerModalState();
}

class _NumberPickerModalState extends State<NumberPickerModal> {
  @override
  Widget build(BuildContext context) {
    int _selectedValue = widget.isTemp
        ? widget.userPlant.optimumTemp
        : widget.userPlant.optimumHum;
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: NumberPicker(
                    value: _selectedValue,
                    minValue: widget.minValue,
                    maxValue: widget.maxValue,
                    onChanged: (value) {
                      setState(() {
                        _selectedValue = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              child: Text('Save'),
              onPressed: () {
                _UserPageState().updateHumOrTemp(
                    _selectedValue, widget.userPlant.id, widget.isTemp);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
