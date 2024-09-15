import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:my_app/components/Colors.dart';
import 'package:my_app/components/dialogBox.dart';
import 'package:my_app/components/textFieldComponent.dart';

class LocalGuide extends StatefulWidget {
  @override
  _LocalGuideState createState() => _LocalGuideState();
}

class BookingRequests {
  String arrivalDate;
  String customerContact;

  BookingRequests({required this.arrivalDate, required this.customerContact});
}

class Guide {
  String name;
  String chargesPerDay;
  String Location;

  Guide({
    required this.name,
    required this.chargesPerDay,
    required this.Location,
  });
}

class _LocalGuideState extends State<LocalGuide> {
  String date = '';
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

  List<Guide> guides = [];
  Future<List<Guide>> fetchGuides() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Service Providers')
          .where('Service Type', isEqualTo: 'TourGuide')
          .get();
      setState(() {
        guides = querySnapshot.docs.map((doc) {
          return Guide(
            name: doc['Name'],
            Location: doc['Location'],
            chargesPerDay: doc['Charges Per Day'],
            // Make sure to fetch the Picture URL field
          );
        }).toList();
      });
    } catch (e) {
      error_dialogue_box(context, e.toString());
    }
    return guides;
  }

  Future<void> sendBookingRequest(
      BookingRequests request, String ownerName) async {
    try {
      FirebaseFirestore db = FirebaseFirestore.instance;
      QuerySnapshot docs = await db
          .collection("Service Providers")
          .where("Owner Name", isEqualTo: ownerName)
          .get();
      DocumentReference docRef =
          db.collection("Service Providers").doc(docs.docs.first.id);
      CollectionReference collRef = docRef.collection("Booking Requests");
      await collRef.add({
        "Arrival Date": request.arrivalDate,
        "Customer Contact": request.customerContact,
      });
      success_dialogue_box(context, "Request Sent Successfully");
    } catch (e) {
      error_dialogue_box(context, e.toString());
    }
  }

  void sendRequest(String name) async {
    TextEditingController customerContact = TextEditingController();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Booking Details"),
            backgroundColor: dialogueBoxBackground(),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
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
                            "Select Arrival Date",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          )),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter
                        .digitsOnly, // Allow only digits (numbers)
                  ],
                  keyboardType: TextInputType.number,
                  controller: customerContact,
                  maxLength: 11,
                  decoration: const InputDecoration(
                    labelText: 'Enter your Contact#',
                    labelStyle: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (date == '' || customerContact.text.isEmpty) {
                    error_dialogue_box(
                        context, "Please fill out all the fields");
                  } else {
                    BookingRequests newRequest = BookingRequests(
                      arrivalDate: date,
                      customerContact: customerContact.text.trim(),
                    );
                    sendBookingRequest(newRequest, name);
                    Navigator.of(context).pop();
                  }
                },
                child: Text(
                  'Confirm Booking',
                  style:
                      TextStyle(color: button2(), fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Tour Guides',
          style: AppBarTextStyle(),
        ),
        backgroundColor: AppBarBackground(),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Service Providers')
            .where("Service Type", isEqualTo: "TourGuide")
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var guide = snapshot.data!.docs[index];
              return guideCard(guide);
            },
          );
        },
      ),
    );
  }

  Widget guideCard(DocumentSnapshot guide) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Column(
          children: <Widget>[
            Image(
                image: NetworkImage(guide.get("Profile URL")),
                height: 200, // Set a fixed height or make it dynamic
                width: double.infinity,
                fit: BoxFit.cover),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(guide.get('Name'),
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                          "Charges per day: PKR. ${guide.get('Charges Per Day')}"),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    sendRequest(guide.get('Name'));
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(14, 28, 54, 1),
                      fixedSize: const Size(100, 40)),
                  child: const Text(
                    'Hire',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
