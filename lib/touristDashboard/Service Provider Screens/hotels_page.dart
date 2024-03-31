import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:my_app/components/Colors.dart';
import 'package:my_app/components/textFieldComponent.dart';

import '../../components/dialogBox.dart';

class HotelScreen extends StatefulWidget {
  @override
  _HotelScreenState createState() => _HotelScreenState();
}

class _HotelScreenState extends State<HotelScreen> {
  String date = "";

  late Future<List<Hotel>> futureHotels;

  final hotels = [
    Hotel(
        name: "Grand Hotel",
        roomCount: 5,
        hotelOwner: "Faiq",
        pictureUrl:
            "data:image/jpeg;base64,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"),
    Hotel(
        name: "Grandeur Hotel",
        roomCount: 6,
        hotelOwner: "Shazzy",
        pictureUrl:
            "data:image/jpeg;base64,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"),
  ];

  @override
  void initState() {
    super.initState();
    // futureHotels = fetchHotels();
  }

  Future<List<Hotel>> fetchHotels() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Service Provider')
        .where('Service Type', isEqualTo: 'HotelOwner')
        .get();

    return querySnapshot.docs.map((doc) {
      return Hotel(
          name: doc['Hotel Name'],
          roomCount: doc['Rooms Available'],
          pictureUrl: doc['Picture URL'],
          hotelOwner:
              doc['Owner Name'] // Make sure to fetch the Picture URL field
          );
    }).toList();
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
      HotelBooking request, String ownerName) async {
    try {
      FirebaseFirestore db = FirebaseFirestore.instance;
      QuerySnapshot docs = await db
          .collection("Service Providers")
          .where("Owner Name", isEqualTo: ownerName)
          .get();
      DocumentReference docRef =
          db.collection("Service Providers").doc(docs.docs.first.id);
      CollectionReference collRef = docRef.collection("Booking Requests");
      await collRef.add(request as Map<String, dynamic>);
      success_dialogue_box(context, "Request Sent Successfully");
    } catch (e) {
      error_dialogue_box(context, "Error sending request");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Hotels',
            style: AppBarTextStyle(),
          ),
          centerTitle: true,
          backgroundColor: AppBarBackground(),
        ),
        backgroundColor: Color.fromRGBO(228, 253, 225, 1),
        body:
            //  FutureBuilder<List<Hotel>>(
            // future: futureHotels,
            // builder: (context, snapshot) {
            //   if (snapshot.connectionState == ConnectionState.waiting) {
            //     return Center(child: CircularProgressIndicator());
            //   } else if (snapshot.hasError) {
            //     return Center(child: Text("Error fetching hotels"));
            //   }

            // final hotels = snapshot.data ?? [];

            ListView.builder(
          itemCount: hotels.length,
          itemBuilder: (context, index) {
            final hotel = hotels[index];
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
                  // Display the hotel picture
                  Image.network(
                    hotel.pictureUrl,
                    height: 200, // Set a fixed height or make it dynamic
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        hotel.name,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Rooms Available: ${hotel.roomCount}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        TextEditingController customerContact =
                            TextEditingController();
                        TextEditingController requiredRooms =
                            TextEditingController();
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
                                                DateTime? datePicker =
                                                    await showDatePicker(
                                                        context: context,
                                                        firstDate:
                                                            DateTime.now(),
                                                        lastDate:
                                                            DateTime(2025),
                                                        initialDate:
                                                            DateTime.now());
                                                setState(() {
                                                  date = formatDate(
                                                      datePicker.toString());
                                                });
                                              },
                                              child: const Text(
                                                "Select Date",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                      controller: requiredRooms,
                                      decoration: const InputDecoration(
                                        labelText: 'Number of rooms required',
                                        labelStyle: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
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
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      if (date == '' ||
                                          customerContact.text.isEmpty ||
                                          requiredRooms.text.isEmpty) {
                                        error_dialogue_box(context,
                                            "Please fill out all the fields");
                                      } else {
                                        sendBookingRequest(
                                            HotelBooking(
                                                checkinDate: date,
                                                requiredRooms:
                                                    requiredRooms.text,
                                                customerContact:
                                                    customerContact.text),
                                            hotel.hotelOwner);
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
                          backgroundColor: Color.fromRGBO(14, 28, 54, 1),
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
        ));
  }
}

class Hotel {
  final String name;
  final int roomCount;
  final String pictureUrl; // Added field for the picture URL
  final String hotelOwner; // Added field for the picture URL

  Hotel(
      {required this.name,
      required this.roomCount,
      required this.pictureUrl,
      required this.hotelOwner});
}

class HotelBooking {
  final String checkinDate;
  final String requiredRooms;
  final String customerContact;

  HotelBooking({
    required this.checkinDate,
    required this.requiredRooms,
    required this.customerContact,
  });
}
