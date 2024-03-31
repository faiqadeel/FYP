import 'dart:async';
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/Trip%20Itineraries/TripScreen.dart';
import 'package:my_app/components/Colors.dart';
import 'package:my_app/components/dialogBox.dart';
import 'package:my_app/components/textFieldComponent.dart';

class NewTrip extends StatefulWidget {
  final String createdBy;
  const NewTrip({super.key, required this.createdBy});

  @override
  State<NewTrip> createState() => _newTrip();
}

class _newTrip extends State<NewTrip> {
  String date = "";
  bool isChecked = false;
  bool _isVisible = false;
  List<String> partners = [];
  List<String> friends = [];
  Map<String, bool> checkboxStates = {};
  TextEditingController nameController = TextEditingController();
  TextEditingController originController = TextEditingController();
  TextEditingController destController = TextEditingController();
  TextEditingController stopsController = TextEditingController();
  bool highlight = false;

  void highlightTextField() {
    setState(() {
      highlight = true; // Set highlight state to true
    });

    // Reset highlight state after 2 seconds
    Timer(const Duration(seconds: 2), () {
      setState(() {
        highlight = false; // Reset highlight state
      });
    });
  }

  @override
  void initState() {
    super.initState();
    // Initialize checkbox states with partners list items set to false

    friends.forEach((item) {
      checkboxStates[item] = false;
    });
  }

  void showText() {
    setState(() {
      _isVisible = true;
    });

    Timer(const Duration(seconds: 2), () {
      setState(() {
        _isVisible = false;
      });
    });
  }

  void toggleCheckboxState(String item) {
    setState(() {
      if (checkboxStates[item]!) {
        partners.remove(item);
        checkboxStates[item] = false;
      } else {
        partners.add(item);
        checkboxStates[item] = true;
      }
    });
  }

  Future<List<String>> fetchFriends() async {
    try {
      QuerySnapshot docs = await FirebaseFirestore.instance
          .collection("tourists")
          .where("email", isEqualTo: widget.createdBy)
          .get();
      DocumentSnapshot doc = docs.docs.first;
      friends = doc['friends'];
      friends.forEach((item) {
        checkboxStates[item] = false;
      });
      return friends;
    } catch (e) {
      // ignore: use_build_context_synchronously
      error_dialogue_box(context, "Error while fetching friends");
    }
    return friends;
  }

  void addTrip() async {
    String name = nameController.text.trim();
    String origin = originController.text.trim();
    String dest = destController.text.trim();
    String stop = stopsController.text.trim();
    List<String> stops = [stop];
    if (name == "" || origin == "") {
      highlightTextField();
    } else {
      partners.toSet().toList();
      stops.toSet().toList();

      Map<String, dynamic> tripData = {
        "Trip Name": name,
        "Origin": origin,
        "Destination": dest,
        "Stops": stops,
        "Departure Date": date,
        "Trip Partners": partners,
        "Created By": widget.createdBy
      };
      await FirebaseFirestore.instance
          .collection("Trip Itinerary")
          .add(tripData);
      // ignore: use_build_context_synchronously
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  TripScreen(tripName: tripData['Trip Name'])));
    }
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppBarBackground(),
        centerTitle: true,
        title: Text("Create New Trip", style: AppBarTextStyle()),
      ),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text(
                "Trip name",
                style: LabelTextStyle(),
              ),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: TextFieldBackground(),
                    disabledBorder: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromARGB(255, 61, 62, 65)),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 61, 62, 65), width: 0.0),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: highlight
                                ? Colors.red.shade900
                                : const Color.fromARGB(255, 61, 62, 65)),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    labelText: "E.g Summer Trip",
                    labelStyle: const TextStyle(
                      color: Color.fromRGBO(48, 55, 72, 1.00),
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                    ),
                    border: const OutlineInputBorder()),
              ),
              const SizedBox(width: 100, height: 20),
              Text(
                "Origin",
                style: LabelTextStyle(),
              ),
              TextField(
                controller: originController,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: TextFieldBackground(),
                    disabledBorder: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromARGB(255, 61, 62, 65)),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 61, 62, 65), width: 0.0),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: highlight
                                ? Colors.red.shade900
                                : const Color.fromARGB(255, 61, 62, 65)),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    labelText: "E.g Isb, Lahore",
                    labelStyle: const TextStyle(
                      color: Color.fromRGBO(48, 55, 72, 1.00),
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                    ),
                    border: const OutlineInputBorder()),
              ),
              const SizedBox(width: 100, height: 20),
              Text(
                "Destination",
                style: LabelTextStyle(),
              ),
              TextField(
                controller: destController,
                decoration: tripTextfielddecor("E.g Islamabad, Lahore"),
              ),
              const SizedBox(width: 100, height: 20),
              Text(
                "Add a Stop",
                style: LabelTextStyle(),
              ),
              TextField(
                controller: stopsController,
                decoration: tripTextfielddecor("E.g Lunch at abc.."),
              ),
              const SizedBox(width: 100, height: 20),
              Text(
                "Select Departure Date",
                style: LabelTextStyle(),
              ),
              ElevatedButton(
                  style: buttonStyle(),
                  onPressed: () async {
                    DateTime? datePicker = await showDatePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2025),
                        initialDate: DateTime.now());
                    setState(() {
                      date = formatDate(datePicker.toString());
                    });
                  },
                  child: const Text(
                    "Select Date",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  )),
              const SizedBox(width: 100, height: 20),
              TextButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return StatefulBuilder(builder: (context, setState) {
                          return AlertDialog(
                            title: Text(
                              'Add Trip Partners',
                              style: TextStyle(color: button1()),
                            ),
                            content: Container(
                              width: double.maxFinite,
                              height: 200,
                              child: FutureBuilder<List<String>>(
                                  future: fetchFriends(),
                                  builder: (context, snapshot) {
                                    return SingleChildScrollView(
                                      child: Column(
                                        children: friends
                                            .map(
                                              (item) => CheckboxListTile(
                                                title: Text(item),
                                                value: checkboxStates[item] ??
                                                    false,
                                                onChanged: (value) {
                                                  setState(() {
                                                    toggleCheckboxState(item);
                                                  });
                                                },
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    );
                                  }),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  showText();
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
                  icon: Icon(Icons.add, color: button1()),
                  label: Text(
                    "Add Trip Partners",
                    style: TextStyle(
                        color: button1(),
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  )),
              const SizedBox(width: 100, height: 20),
              const SizedBox(width: 100, height: 5),
              ElevatedButton(
                  style: buttonStyle(),
                  onPressed: () {
                    addTrip();
                  },
                  child: Text(
                    "Create Trip",
                    style: buttonTextStyle(),
                  )),
              const SizedBox(height: 10),
              Text(
                "You can edit locations,dates,stops and travel partners in the trip plan later",
                style: TextStyle(
                  color: AppBarBackground(),
                  overflow: TextOverflow.visible,
                  fontSize: 18,
                ),
              ),
              AnimatedOpacity(
                duration: const Duration(seconds: 2),
                opacity: _isVisible ? 1.0 : 0.0,
                child: Container(
                  padding: const EdgeInsets.all(
                      8.0), // Add padding for better appearance
                  decoration: BoxDecoration(
                    color: Colors.blue, // Set the background color
                    borderRadius: BorderRadius.circular(
                        8.0), // Optional: Add border radius for rounded corners
                  ),
                  child: const Text(
                    'Selected friends added to the trip partners',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors
                            .white), // Set text color to contrast with background
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
