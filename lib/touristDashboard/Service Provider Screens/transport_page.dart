import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:my_app/components/Colors.dart';
import 'package:my_app/components/textFieldComponent.dart';

import '../../components/dialogBox.dart';

class Transport extends StatefulWidget {
  @override
  _createTransport createState() => _createTransport();
}

class _createTransport extends State<Transport> {
  late Future<List<TransportVehicle>> futureVehicles;

  @override
  void initState() {
    super.initState();
  }

  Future<List<TransportVehicle>> fetchVehicles() async {
    List<TransportVehicle> vehicles = [];
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Service Providers')
          .where('Service Type', isEqualTo: 'TransportOwner')
          .get();
      for (var doc in querySnapshot.docs) {
        QuerySnapshot vehicleSnapshot =
            await doc.reference.collection("Vehicles").get();
        var vehicleDocs = vehicleSnapshot.docs.map((doc) {
          return TransportVehicle(
              name: doc['Vehicle Name'],
              seatCount: doc['Seats'],
              vehicleOwner: doc["Owner"],
              perDayCharges: doc["Per Day Charges"]
              // Make sure to fetch the Picture URL field
              );
        }).toList();
        vehicles.addAll(vehicleDocs);
      }
    } catch (e) {
      print(e.toString());
    }
    return vehicles;
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
        "Pickup Location": request.pickpLocation,
        "Pickup Date": request.pickupDate,
        "Customer Contact": request.customerContact,
        "Vehicle Name": request.vehicleName
      });
      success_dialogue_box(context, "Request Sent Successfully");
    } catch (e) {
      error_dialogue_box(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Transport",
            style: AppBarTextStyle(),
          ),
          centerTitle: true,
          backgroundColor: AppBarBackground(),
        ),
        backgroundColor: const Color.fromRGBO(228, 253, 225, 1),
        body: FutureBuilder<List<TransportVehicle>>(
            future: fetchVehicles(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text("Error fetching vehicles"));
              } else {
                final vehicles = snapshot.data ?? [];

                return ListView.builder(
                  itemCount: vehicles.length,
                  itemBuilder: (context, index) {
                    final vehicle = vehicles[index];
                    return Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: CardBackground(),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Card(
                            elevation: 4, // Adds a shadow effect
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(
                                  height:
                                      200, // Set the height of the background image
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(12.0)),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          "data:image/png;base64,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"), // Load image from URL
                                      fit: BoxFit
                                          .cover, // Adjusts the image to cover the entire container
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 22,
                                          ),
                                          children: [
                                            const WidgetSpan(
                                                child: Text("   ")),
                                            TextSpan(
                                              text: '${vehicle.name}\n',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const WidgetSpan(
                                                child: Text("   ")),
                                            TextSpan(
                                              text:
                                                  'Seat Capacity: ${vehicle.seatCount}\n',
                                            ),
                                            const WidgetSpan(
                                                child: Text("   ")),
                                            TextSpan(
                                              text:
                                                  'Per Day: Pkr ${vehicle.perDayCharges}',
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                TextEditingController customerContact =
                                    TextEditingController();
                                TextEditingController pickupLoc =
                                    TextEditingController();
                                TextEditingController roomType =
                                    TextEditingController();
                                String date = '';
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text("Booking Details"),
                                        backgroundColor:
                                            dialogueBoxBackground(),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: ElevatedButton(
                                                      style: buttonStyle(),
                                                      onPressed: () async {
                                                        DateTime? datePicker =
                                                            await showDatePicker(
                                                                context:
                                                                    context,
                                                                firstDate:
                                                                    DateTime
                                                                        .now(),
                                                                lastDate:
                                                                    DateTime(
                                                                        2025),
                                                                initialDate:
                                                                    DateTime
                                                                        .now());
                                                        setState(() {
                                                          date = formatDate(
                                                              datePicker
                                                                  .toString());
                                                        });
                                                      },
                                                      child: const Text(
                                                        "Select Date",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            const TextField(
                                              decoration: InputDecoration(
                                                labelText:
                                                    'Enter Pickup Location',
                                                labelStyle: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            TextField(
                                              inputFormatters: <TextInputFormatter>[
                                                FilteringTextInputFormatter
                                                    .digitsOnly, // Allow only digits (numbers)
                                              ],
                                              keyboardType:
                                                  TextInputType.number,
                                              controller: customerContact,
                                              maxLength: 11,
                                              decoration: const InputDecoration(
                                                labelText:
                                                    'Enter your Contact#',
                                                labelStyle: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              if (date == '' ||
                                                  customerContact
                                                      .text.isEmpty ||
                                                  pickupLoc.text.isEmpty) {
                                                error_dialogue_box(context,
                                                    "Please fill out all the fields");
                                              } else {
                                                sendBookingRequest(
                                                    BookingRequests(
                                                        pickpLocation: pickupLoc
                                                            .text
                                                            .trim(),
                                                        customerContact:
                                                            customerContact.text
                                                                .trim(),
                                                        vehicleName:
                                                            vehicle.name,
                                                        pickupDate: date),
                                                    vehicle.vehicleOwner);
                                                Navigator.of(context).pop();
                                              }
                                            },
                                            child: Text(
                                              'Confirm Booking',
                                              style: TextStyle(
                                                  color: button2(),
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      );
                                    });
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromRGBO(14, 28, 54, 1),
                                  fixedSize: const Size(170, 40)),
                              child: const Text(
                                'Request Booking',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
            }));
  }
}

class TransportVehicle {
  final String name;
  final String seatCount; // Added field for the picture URL
  final String vehicleOwner; // Added field for the picture URL
  final String perDayCharges;
  TransportVehicle(
      {required this.name,
      required this.seatCount,
      required this.vehicleOwner,
      required this.perDayCharges});
}

class BookingRequests {
  String pickpLocation;
  String pickupDate;
  String vehicleName;
  String customerContact;

  BookingRequests(
      {required this.pickpLocation,
      required this.customerContact,
      required this.vehicleName,
      required this.pickupDate});
}
