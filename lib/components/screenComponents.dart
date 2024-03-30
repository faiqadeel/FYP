import 'package:flutter/material.dart';
import 'package:my_app/components/Colors.dart';
import 'package:my_app/components/textFieldComponent.dart';

Scaffold MainTripScreen(BuildContext context, String email, Function func) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        "My Trips",
        style: AppBarTextStyle(),
      ),
      backgroundColor: AppBarBackground(),
      centerTitle: true,
    ),
    body: FutureBuilder<List<String>>(
      future: func(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No data available'));
        } else {
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Two buttons per row
            ),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 30, // Adjust the size as needed
                      backgroundImage: NetworkImage(
                          'URL_OF_THE_PHOTO'), // Replace with your photo URL
                    ),
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hotel Name", // Replace with your variable for hotel name
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Room Count: X", // Replace X with your variable for room count
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Add your button onPressed logic here
                        print('Request Booking');
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        backgroundColor: Colors.blue, // Text color
                      ),
                      child: const Text("Request Book"),
                    ),
                  ],
                ),
              );
            },
          );
        }
      },
    ),
  );
}

Widget _buildCircleButton(
    {required IconData icon,
    required String label,
    required VoidCallback onPressed}) {
  return Column(
    mainAxisSize: MainAxisSize.min, // To make the column as big as its children
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      IconButton(
        icon: CircleAvatar(
          backgroundColor: Colors.blue, // Your desired background color
          child: Icon(icon, color: Colors.white), // Your desired icon
        ),
        onPressed: onPressed,
      ),
      Text(label,
          style:
              const TextStyle(fontSize: 12)), // Your desired styling for labels
    ],
  );
}
