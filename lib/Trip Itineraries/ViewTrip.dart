import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_app/components/Colors.dart';

import '../components/textFieldComponent.dart';

class ViewTrip extends StatefulWidget {
  final String tripName;
  const ViewTrip({super.key, required this.tripName});

  @override
  State<ViewTrip> createState() => _ViewTripState();
}

class _ViewTripState extends State<ViewTrip> {
  String tripName = '';
  String origin = '';
  String dest = '';
  String date = '';
  String createdBy = '';
  bool dataLoaded = false;

  Map<String, dynamic> tripInfo = {};
  List<dynamic> partners = [];
  List<dynamic> stops = [];
  Future<void> fetchData() async {
    try {
      CollectionReference tripCollection =
          await FirebaseFirestore.instance.collection('Trip Itinerary');
      QuerySnapshot tripDocs = await tripCollection
          .where("Trip Name", isEqualTo: widget.tripName)
          .get();
      if (tripDocs.docs.isNotEmpty) {
        DocumentReference doc = tripCollection.doc(tripDocs.docs.first.id);
        DocumentSnapshot docData = await doc.get();
        await Future.delayed(const Duration(seconds: 1));
        while (tripInfo.isEmpty) {
          setState(() {
            tripInfo = docData.data() as Map<String, dynamic>;
            tripName = tripInfo['Trip Name'];
            origin = tripInfo['Origin'];
            dest = tripInfo['Destination'];
            createdBy = tripInfo['Created By'];
            date = tripInfo['Departure Date'];
            stops = tripInfo['Stops'];
            partners = tripInfo['Trip Partners'];
            dataLoaded = true;
          });
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppBarBackground(),
        centerTitle: true,
        title: Text('Trip Information', style: AppBarTextStyle()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: tripInfo.isEmpty
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
                children: [
                  const SizedBox(height: 10),
                  _buildEditableField('Trip Name', tripName),
                  const SizedBox(height: 10),
                  _buildEditableField('Origin', origin),
                  const SizedBox(height: 10),
                  _buildEditableField('Destination', dest),
                  const SizedBox(height: 10),
                  Center(
                      child: Text(
                    "Stops",
                    style: LabelTextStyle(),
                  )),
                  for (var stop in stops) _buildEditableField('Stop', stop),
                  const SizedBox(height: 10),
                  Center(
                      child: Text(
                    "Trip Partners",
                    style: buttonTextStyle(),
                  )),
                  for (var partner in partners)
                    _buildEditableField('partner', partner),
                  const SizedBox(height: 10),
                  _buildEditableField('Departure Date', date),
                  const SizedBox(height: 10),
                  _buildEditableField('Created By', createdBy),
                ],
              ),
      ),
    );
  }

  Widget _buildEditableField(String label, String text) {
    if (label == "Departure Date") {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                readOnly: true,
                controller: TextEditingController(text: text),
                decoration: InputDecoration(
                  labelText: label,
                  labelStyle: LabelTextStyle(),
                  border: const OutlineInputBorder(),
                ),
              ),
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
            TextFormField(
              readOnly: true,
              controller: TextEditingController(text: text),
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
            const Text("          •\n          •"),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
        child: TextFormField(
          readOnly: true,
          controller: TextEditingController(text: text),
          decoration: InputDecoration(
            labelText: label == 'partner' ? "" : label,
            labelStyle: LabelTextStyle(),
            border: const OutlineInputBorder(),
          ),
        ),
      );
    }
  }
}
