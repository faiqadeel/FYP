import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:my_app/api.dart';
import 'package:my_app/components/Colors.dart';
import 'package:my_app/components/textFieldComponent.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';

import '../components/dialogBox.dart';

class TripScreen extends StatefulWidget {
  final String tripName;

  const TripScreen({super.key, required this.tripName});

  @override
  State<TripScreen> createState() => _TripScreenState();
}

class _TripScreenState extends State<TripScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController nameController = TextEditingController();
  TextEditingController originController = TextEditingController();
  TextEditingController destController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController createdByController = TextEditingController();
  List<TextEditingController> partnerControllers = [];
  List<TextEditingController> stopControllers = [];
  List listOfPoints = [];
  List<LatLng> points = [];
  LatLng originLatLngs = LatLng(0, 0);
  LatLng destLatLngs = LatLng(0, 0);
  double totalDistance = 0;

  // API function
  getCoordinates() async {
    String org = originLatLngs.longitude.toString() +
        "," +
        originLatLngs.latitude.toString();

    String dest = destLatLngs.longitude.toString() +
        "," +
        destLatLngs.latitude.toString();
    var response = await http.get(getRouteUrl(org, dest));
    try {
      final distance = await getDistance(originLatLngs.latitude,
          originLatLngs.longitude, destLatLngs.latitude, destLatLngs.longitude);
      setState(() {
        totalDistance = distance;
      });
    } catch (e) {
      print(e);
    }
    setState(() {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        listOfPoints = data["features"][0]["geometry"]["coordinates"];
        points = listOfPoints
            .map((e) => LatLng(e[1] as double, e[0] as double))
            .toList();
      }
    });
  }

  Map<String, bool> checkboxStates = {};
  Map<String, dynamic> tripInfo = {};
  List<dynamic> friends = [];
  List<String> partners = [];
  List<String> stops = [];
  bool status = false;
  bool fetched = true;

  void updateTrip(Map<String, dynamic> updTripData) async {
    try {
      CollectionReference tripCollection =
          await FirebaseFirestore.instance.collection('Trip Itinerary');
      QuerySnapshot docs = await tripCollection
          .where("Trip Name", isEqualTo: nameController.text.trim())
          .get();
      if (docs.docs.isNotEmpty) {
        DocumentReference tripRef = tripCollection.doc(docs.docs.first.id);
        await tripRef.update(updTripData);
      }
      setState(() {
        status = true;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void fetchFriends() async {
    try {
      QuerySnapshot tripDocs = await FirebaseFirestore.instance
          .collection("tourists")
          .where('name', isEqualTo: tripInfo['Created By'])
          .get();
      if (tripDocs.docs.isNotEmpty) {
        DocumentSnapshot doc = tripDocs.docs.first;
        setState(() {
          friends = (doc.data() as Map<String, dynamic>)['friends'];
          friends.forEach((item) {
            checkboxStates[item] = false;
          });
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void fetchData() async {
    try {
      CollectionReference tripCollection =
          await FirebaseFirestore.instance.collection('Trip Itinerary');
      QuerySnapshot tripDocs = await tripCollection
          .where("Trip Name", isEqualTo: widget.tripName)
          .get();
      if (tripDocs.docs.isNotEmpty) {
        DocumentReference doc = tripCollection.doc(tripDocs.docs.first.id);
        DocumentSnapshot docData = await doc.get();
        setState(() {
          tripInfo = docData.data() as Map<String, dynamic>;
          nameController = TextEditingController(text: tripInfo['Trip Name']);
          originController = TextEditingController(text: tripInfo['Origin']);
          destController = TextEditingController(text: tripInfo['Destination']);
          dateController =
              TextEditingController(text: tripInfo['Departure Date']);
          createdByController =
              TextEditingController(text: tripInfo['Created By']);
          for (var stop in tripInfo["Stops"]) {
            stopControllers.add(TextEditingController(text: stop));
          }
          for (var partner in tripInfo["Trip Partners"]) {
            partnerControllers.add(TextEditingController(text: partner));
          }
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  late TabController tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    fetchData();
    fetchFriends();
  }

  void toggleCheckboxState(String item) {
    setState(() {
      if (checkboxStates[item]!) {
        partners.remove(item);
        checkboxStates[item] = false;
      } else {
        checkboxStates[item] = true;
      }
      partnerControllers.add(TextEditingController(text: item));
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    originController.dispose();
    destController.dispose();
    dateController.dispose();
    createdByController.dispose();
    stopControllers.forEach((controller) => controller.dispose());
    partnerControllers.forEach((controller) => controller.dispose());
    tabController.dispose();
    super.dispose();
  }

  void addStopField() {
    setState(() {
      for (var controller in stopControllers) {
        if (controller.text.isEmpty) {
          stopControllers.remove(controller);
        }
      }
      stopControllers.add(TextEditingController());
    });
  }

  String formatDate(String inputDateStr) {
    DateTime inputDate = DateTime.parse(inputDateStr);

    // Define the output date format
    DateFormat outputFormat =
        DateFormat("d'${_getDaySuffix(inputDate.day)}' MMMM, y");

    // Format the date using the defined format
    return outputFormat.format(inputDate);
  }

  String _getDaySuffix(int day) {
    if (day >= 11 && day <= 13) {
      return 'th';
    }
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: AppBarBackground(),
          centerTitle: true,
          title: Text('Trip Information', style: AppBarTextStyle()),
          bottom: TabBar(
            controller: tabController,
            tabs: [
              Tab(text: "Edit Trip"),
              Tab(
                text: "Trip Details",
              )
            ],
          )),
      resizeToAvoidBottomInset: true,
      body: TabBarView(controller: tabController, children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: tripInfo.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(
                      backgroundColor: Colors.lightBlue),
                )
              : ListView(
                  children: [
                    const SizedBox(height: 10),
                    _buildEditableField('Trip Name', nameController),
                    const SizedBox(height: 10),
                    _buildEditableField('Origin', originController),
                    const SizedBox(height: 10),
                    _buildEditableField('Destination', destController),
                    const SizedBox(height: 10),
                    Center(
                        child: Text(
                      "Stops",
                      style: LabelTextStyle(),
                    )),
                    for (var controller in stopControllers)
                      _buildEditableField('Stop', controller),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      style: buttonStyle(),
                      onPressed: addStopField,
                      child: Text(
                        'Add Stop',
                        style: buttonTextStyle(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                        child: Text(
                      "Trip Partners",
                      style: buttonTextStyle(),
                    )),
                    for (var controller in partnerControllers)
                      _buildEditableField('partner', controller),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      style: buttonStyle(),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return StatefulBuilder(
                                builder: (context, setState) {
                              return AlertDialog(
                                title: const Text('Add Trip Partners'),
                                content: Container(
                                  width: double.maxFinite,
                                  height: 200,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: friends
                                          .map(
                                            (item) => CheckboxListTile(
                                              title: Text(item),
                                              value:
                                                  checkboxStates[item] ?? false,
                                              onChanged: (value) {
                                                setState(() {
                                                  toggleCheckboxState(item);
                                                });
                                              },
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Close'),
                                  ),
                                ],
                              );
                            });
                          },
                        );
                      },
                      child: Text('Add a Partner', style: buttonTextStyle()),
                    ),
                    const SizedBox(height: 10),
                    _buildEditableField('Departure Date', dateController),
                    const SizedBox(height: 10),
                    _buildEditableField('Created By', createdByController),
                    const SizedBox(height: 10),
                    ElevatedButton(
                        style: buttonStyle(),
                        onPressed: () {
                          stopControllers.forEach((element) {
                            if (!stops.contains(element.text.trim())) {
                              stops.add(element.text.trim());
                            }
                          });
                          partnerControllers.forEach((element) {
                            if (!partners.contains(element.text.trim())) {
                              partners.add(element.text.trim());
                            }
                          });
                          stops.toSet().toList;
                          partners.toSet().toList;
                          Map<String, dynamic> updatedTrip = {
                            "Trip Name": nameController.text.trim(),
                            "Origin": originController.text.trim(),
                            "Destination": destController.text.trim(),
                            "Stops": stops,
                            "Departure Date": dateController.text.trim(),
                            "Trip Partners": partners,
                            "Created By": createdByController.text.trim()
                          };
                          updateTrip(updatedTrip);
                          stops = [];
                          partners = [];
                          if (status) {
                            success_dialogue_box(
                                context, 'Trip Info updated!!');
                          }
                        },
                        child: Text(
                          "Save Changes",
                          style: buttonTextStyle(),
                        )),
                    const SizedBox(height: 10),
                    originLatLngs.latitude == 0 || destLatLngs.latitude == 0
                        ? const Text("")
                        : ElevatedButton(
                            onPressed: () {
                              getCoordinates();
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    insetPadding: const EdgeInsets.all(
                                        10), // Adjust the padding as needed
                                    child: Container(
                                      padding: EdgeInsets.all(5),
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.8, // 80% of the screen height
                                      width: MediaQuery.of(context).size.width *
                                          0.8, // 80% of the screen width
                                      child: Column(
                                        children: [
                                          Expanded(
                                              child: FlutterMap(
                                            options: MapOptions(
                                              initialZoom: 15,
                                              initialCenter: originLatLngs,
                                            ),
                                            children: [
                                              TileLayer(
                                                urlTemplate:
                                                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                                userAgentPackageName:
                                                    'dev.fleaflet.flutter_map.example',
                                                // Plenty of other options available!
                                              ),
                                              MarkerLayer(
                                                markers: [
                                                  Marker(
                                                    point: originLatLngs,
                                                    width: 80,
                                                    height: 80,
                                                    child: IconButton(
                                                        onPressed: () {},
                                                        icon: const Icon(
                                                            Icons.location_on),
                                                        color: Colors.green,
                                                        iconSize: 45),
                                                  ),
                                                  Marker(
                                                    point: destLatLngs,
                                                    width: 80,
                                                    height: 80,
                                                    child: IconButton(
                                                        onPressed: () {},
                                                        icon: const Icon(
                                                            Icons.location_on),
                                                        color: Colors.red,
                                                        iconSize: 45),
                                                  ),
                                                ],
                                              ),
                                              PolylineLayer(
                                                polylineCulling: false,
                                                polylines: [
                                                  Polyline(
                                                      points: points,
                                                      color: Colors.blue,
                                                      strokeWidth: 5),
                                                ],
                                              ),
                                            ],
                                          )),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            style: buttonStyle(),
                            child: Text(
                              "Show route on map",
                              style: buttonTextStyle(),
                            ),
                          ),
                    ElevatedButton(
                        onPressed: () {},
                        child:
                            Text("Generate Budget", style: buttonTextStyle()),
                        style: buttonStyle()),
                  ],
                ),
        ),
        Center(
          child: Text("$totalDistance"),
        )
      ]),
    );
  }

  Widget _buildEditableField(String label, TextEditingController controller) {
    if (label == "Origin" || label == "Destination") {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
        child: SizedBox(
          width: 350,
          height: 45,
          child: TextFormField(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      child: Container(
                        child: OpenStreetMapSearchAndPick(
                            locationPinText: "",
                            locationPinIconColor: Colors.red,
                            locationPinTextStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.red),
                            buttonColor: button1(),
                            buttonText: 'Set Location',
                            onPicked: (pickedData) {
                              List<String> lst = pickedData.address
                                  .toString()
                                  .split(",")[0]
                                  .split(" ");
                              lst.removeAt(0);
                              setState(() {
                                if (label == "Origin") {
                                  originLatLngs = LatLng(
                                      pickedData.latLong.latitude,
                                      pickedData.latLong.longitude);
                                } else if (label == "Destination") {
                                  destLatLngs = LatLng(
                                      pickedData.latLong.latitude,
                                      pickedData.latLong.longitude);
                                  getCoordinates();
                                }
                                label == "Origin"
                                    ? originController.text = lst.join(" ")
                                    : destController.text = lst.join(" ");
                                Navigator.pop(context);
                              });
                            }),
                      ),
                    );
                  });
            },
            readOnly: true,
            controller: controller,
            decoration: InputDecoration(
              labelText: "Tap to select Location on Map",
              labelStyle: LabelTextStyle(),
              border: const OutlineInputBorder(),
            ),
          ),
        ),
      );
    } else if (label == "Departure Date") {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                width: 350,
                height: 45,
                child: TextFormField(
                  readOnly: true,
                  controller: controller,
                  decoration: InputDecoration(
                    labelText: label,
                    labelStyle: LabelTextStyle(),
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            IconButton(
              iconSize: 30,
              icon: const Icon(Icons.calendar_month_rounded),
              onPressed: () async {
                DateTime? datePicker = await showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2025),
                    initialDate: DateTime.now());
                setState(() {
                  controller.text = formatDate(datePicker.toString());
                });
              },
            ),
          ],
        ),
      );
    } else if (label == "Stop") {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 350,
              height: 45,
              child: TextFormField(
                controller: controller,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: "",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                        10.0), // Adjust the border radius as needed
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 12.0),
                ),
              ),
            ),
            const Text("          •\n          •"),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
        child: SizedBox(
          width: 350,
          height: 45,
          child: TextFormField(
            readOnly:
                label == "Created By" || label == 'partner' ? true : false,
            controller: controller,
            decoration: InputDecoration(
              labelText: label == 'partner' ? "" : label,
              labelStyle: LabelTextStyle(),
              border: const OutlineInputBorder(),
            ),
          ),
        ),
      );
    }
  }
}
