import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_app/components/Colors.dart';
import 'package:my_app/components/textFieldComponent.dart';

class HotelScreen extends StatefulWidget {
  @override
  _HotelScreenState createState() => _HotelScreenState();
}

class _HotelScreenState extends State<HotelScreen> {
  late Future<List<Hotel>> futureHotels;

  @override
  void initState() {
    super.initState();
    futureHotels = fetchHotels();
  }

  Future<List<Hotel>> fetchHotels() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Service Provider')
        .where('Service Type', isEqualTo: 'HotelOwner')
        .get();

    return querySnapshot.docs.map((doc) {
      return Hotel(
        name: doc['Hotel Name'],
        roomCount: doc['Room Count'],
        pictureUrl:
            doc['Picture URL'], // Make sure to fetch the Picture URL field
      );
    }).toList();
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
      body: FutureBuilder<List<Hotel>>(
        future: futureHotels,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error fetching hotels"));
          }

          final hotels = snapshot.data ?? [];

          return ListView.builder(
            itemCount: hotels.length,
            itemBuilder: (context, index) {
              final hotel = hotels[index];
              return Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: Offset(0, 3),
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
                    SizedBox(height: 8),
                    Text(
                      hotel.name,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('Room Count: ${hotel.roomCount}'),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        print('Requesting booking for ${hotel.name}');
                      },
                      child: Text('Request Booking'),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class Hotel {
  final String name;
  final int roomCount;
  final String pictureUrl; // Added field for the picture URL

  Hotel(
      {required this.name, required this.roomCount, required this.pictureUrl});
}
