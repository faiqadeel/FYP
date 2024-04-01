import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_app/components/Colors.dart';
import 'package:my_app/components/textFieldComponent.dart';

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
              pictureUrl: doc['Picture URL'],
              vehicleOwner:
                  doc["Owner"] // Make sure to fetch the Picture URL field
              );
        }).toList();
        vehicles.addAll(vehicleDocs);
      }
    } catch (e) {
      print(e.toString());
    }
    return vehicles;
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
                          // Display the hotel picture
                          Image(image: NetworkImage(
                              vehicle.pictureUrl),height: 200, // Set a fixed height or make it dynamic
                              width: double.infinity,
                              fit: BoxFit.cover),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                vehicle.name,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Accomodation Capacity: ${vehicle.seatCount}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                print('Requesting booking for ${vehicle.name}');
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
  final String seatCount;
  final String pictureUrl; // Added field for the picture URL
  final String vehicleOwner; // Added field for the picture URL

  TransportVehicle(
      {required this.name,
      required this.seatCount,
      required this.pictureUrl,
      required this.vehicleOwner});
}
