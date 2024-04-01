import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_app/components/Colors.dart';
import 'package:my_app/components/textFieldComponent.dart';

class LocalGuide extends StatefulWidget {
  @override
  _LocalGuideState createState() => _LocalGuideState();
}

class _LocalGuideState extends State<LocalGuide> {
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
            Image(image: NetworkImage(
                guide.get("Profile URL")),height: 200, // Set a fixed height or make it dynamic
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
                  onPressed: () {},
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
