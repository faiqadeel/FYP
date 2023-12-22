import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_app/components/textFieldComponent.dart';

class NewTrip extends StatefulWidget {
  final String createdBy;
  final List<String> friends;
  const NewTrip({super.key, required this.createdBy, required this.friends});

  @override
  State<NewTrip> createState() => _newTrip();
}

class _newTrip extends State<NewTrip> {
  String date = "";
  bool isChecked = false;
  List<String> partners = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController originController = TextEditingController();
  TextEditingController destController = TextEditingController();
  TextEditingController stopsController = TextEditingController();

  void add_trip() async {
    String name = nameController.text.trim();
    String origin = originController.text.trim();
    String dest = destController.text.trim();
    String stop = stopsController.text.trim();
    List<String> stops = [stop];

    if (name != "" || origin != "" || dest != "" || stop != "" || date != "") {
      Map<String, dynamic> tripData = {
        "Trip Name": name,
        "Origin": origin,
        "Destination": dest,
        "Stops": stops,
        "Departure Date": date,
        "Trip Partners": partners,
        "Created By": widget.createdBy
      };
      FirebaseFirestore.instance.collection("Trip Itinerary").add(tripData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 235, 239, 250),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 235, 239, 250),
        centerTitle: true,
        title: const Text(
          "Create New Trip",
          style: TextStyle(
              color: Colors.black, fontSize: 28, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Trip name",
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
            TextField(
              controller: nameController,
              decoration: tripTextfielddecor("E.g Summer Trip"),
            ),
            const SizedBox(width: 100, height: 10),
            const Text(
              "Origin",
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
            TextField(
              controller: originController,
              decoration: tripTextfielddecor("E.g Islamabad, Lahore"),
            ),
            const SizedBox(width: 100, height: 10),
            const Text(
              "Destination",
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
            TextField(
              controller: destController,
              decoration: tripTextfielddecor("E.g Islamabad, Lahore"),
            ),
            const SizedBox(width: 100, height: 10),
            const Text(
              "Add a Stop",
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
            TextField(
              controller: stopsController,
              decoration: tripTextfielddecor("E.g Lunch at abc.."),
            ),
            const SizedBox(width: 100, height: 10),
            const Text(
              "Select Departure Date",
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
            ElevatedButton(
                style: ButtonStyle(
                  fixedSize:
                      MaterialStateProperty.all<Size>(const Size(455, 50.0)),
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromRGBO(16, 136, 174, 1.0)),
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          10.0), // Adjust the radius as needed
                      side: const BorderSide(
                          color: Color.fromRGBO(
                              48, 55, 72, 1.00)), // Set the border color
                    ),
                  ),
                ),
                onPressed: () async {
                  DateTime? datePicker = await showDatePicker(
                      context: context,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2024),
                      initialDate: DateTime.now());
                  setState(() {
                    date = datePicker.toString();
                  });
                },
                child: const Text(
                  "Select Date",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                  ),
                )),
            const SizedBox(width: 100, height: 10),
            TextButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Add Trip Partners'),
                        content: Container(
                          width: double.maxFinite,
                          height: 200,
                          child: SingleChildScrollView(
                            child: Column(
                              children: widget.friends
                                  .map(
                                    (item) => CheckboxListTile(
                                      title: Text(item),
                                      value: isChecked,
                                      onChanged: (value) {
                                        if (!partners.contains(item)) {
                                          setState(() {
                                            partners.add(item);
                                          });
                                        }
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
                            child: Text('Close'),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(Icons.add,
                    color: Color.fromRGBO(16, 136, 174, 1.0)),
                label: const Text(
                  "Add Trip Partners",
                  style: TextStyle(
                      color: Color.fromRGBO(16, 136, 174, 1.0), fontSize: 20),
                )),
            const SizedBox(width: 100, height: 10),
            const Text(
              "You can edit locations,dates,stops and travel partners in the trip plan later",
              style: TextStyle(
                color: Colors.black54,
                overflow: TextOverflow.visible,
                fontSize: 18,
              ),
            ),
            const SizedBox(width: 100, height: 5),
            ElevatedButton(
                style: ButtonStyle(
                  fixedSize:
                      MaterialStateProperty.all<Size>(const Size(455, 50.0)),
                  backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromRGBO(16, 136, 174, 1.0)),
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          10.0), // Adjust the radius as needed
                      side: const BorderSide(
                          color: Color.fromRGBO(
                              48, 55, 72, 1.00)), // Set the border color
                    ),
                  ),
                ),
                onPressed: () {
                  add_trip();
                },
                child: const Text(
                  "Create Trip",
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ))
          ],
        ),
      ),
    );
  }
}
