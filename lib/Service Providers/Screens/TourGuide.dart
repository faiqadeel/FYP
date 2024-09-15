import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app/components/Colors.dart';

import '../../components/dialogBox.dart';
import '../../components/textFieldComponent.dart';

class TourGuide extends StatefulWidget {
  final String provider_id;
  const TourGuide({super.key, required this.provider_id});

  @override
  State<TourGuide> createState() => _TourGuideState();
}

class BookingRequests {
  String arrivalDate;
  String customerContact;

  BookingRequests({required this.arrivalDate, required this.customerContact});
}

class _TourGuideState extends State<TourGuide>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<BookingRequests> bookingRequests = [];
  List<BookingRequests> acceptedRequests = [];
  String name = '';
  Uint8List? _image;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
  }

  Future<List<BookingRequests>> getData() async {
    try {
      final CollectionReference hotelOwner =
          FirebaseFirestore.instance.collection("Service Providers");
      final QuerySnapshot ownerDocs = await hotelOwner
          .where("Phone Number", isEqualTo: widget.provider_id)
          .get();
      final DocumentSnapshot current = ownerDocs.docs.first;
      setState(() {
        name = current['Owner Name'];
      });
      final CollectionReference reqRef =
          hotelOwner.doc(current.id).collection("Booking Requests");
      final CollectionReference accRef =
          hotelOwner.doc(current.id).collection("Accepted Requests");

      QuerySnapshot requests = await reqRef.get();
      QuerySnapshot accReq = await accRef.get();

      bookingRequests = [];
      for (var request in requests.docs) {
        BookingRequests newRequest = BookingRequests(
            customerContact: request['Customer Contact'],
            arrivalDate: request['Arrival Date']);
        bookingRequests.add(newRequest);
      }
      acceptedRequests = [];
      for (var request in accReq.docs) {
        BookingRequests newRequest = BookingRequests(
            customerContact: request['Customer Contact'],
            arrivalDate: request['Arrival Date']);
        acceptedRequests.add(newRequest);
      }
    } catch (e) {
      error_dialogue_box(context, e.toString());
    }
    return bookingRequests;
  }

  void uploadImage() async {
    try {
      final ImagePicker _imgPicker = ImagePicker();
      XFile? _file = await _imgPicker.pickImage(source: ImageSource.gallery);
      if (_file != null) {
        Uint8List img = await _file.readAsBytes();
        setState(() {
          _image = img;
        });
        uploadPic(_file);
      } else {
        print("File is null");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  String profileURL = '';
  void uploadPic(XFile image) async {
    try {
      Uint8List fileBytes = await image.readAsBytes();
      Reference ref = FirebaseStorage.instance
          .ref("Profile_Pics")
          .child("${widget.provider_id}");
      TaskSnapshot task = await ref.putData(fileBytes);
      String downloadurl = await task.ref.getDownloadURL();
      setState(() {
        profileURL = downloadurl;
      });
      CollectionReference myCollection =
          await FirebaseFirestore.instance.collection('Service Providers');
      QuerySnapshot docs = await myCollection
          .where("Phone Number", isEqualTo: widget.provider_id)
          .get();
      DocumentReference docRef = myCollection.doc(docs.docs.first.id);
      await docRef.update({"Profile URL": downloadurl});
      success_dialogue_box(context, "Profile Photo Updated Successfully!!");
    } catch (e) {
      error_dialogue_box(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Welcome, ${name}", style: AppBarTextStyle()),
          backgroundColor: AppBarBackground(),
          actions: [
            Stack(
              children: [
                profileURL != ""
                    ? CircleAvatar(
                        radius: 35,
                        backgroundImage: NetworkImage(profileURL),
                      )
                    : const CircleAvatar(
                        radius: 35,
                        backgroundImage: NetworkImage(
                            'https://static.vecteezy.com/system/resources/thumbnails/005/544/718/small/profile-icon-design-free-vector.jpg'),
                      ),
                profileURL != ''
                    ? const Text('')
                    : Positioned(
                        bottom: -12,
                        left: 35,
                        child: Material(
                          color: Colors
                              .transparent, // Keep the Material widget transparent
                          child: InkWell(
                            onTap: uploadImage,
                            child: Container(
                              width:
                                  48, // Increase the width for a larger touch area
                              height:
                                  48, // Increase the height for a larger touch area
                              alignment: Alignment.center,
                              child: const Icon(Icons.add_a_photo_rounded,
                                  size: 24.0),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ],
        ),
        body: FutureBuilder(
            future: getData(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text(
                      "An error occured while fetching data from database."),
                );
              }
              return Column(
                children: [
                  TabBar(
                    labelColor: CardBackground(),
                    labelStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    unselectedLabelColor: button1(),
                    unselectedLabelStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                    indicatorColor: button2(),
                    controller: _tabController,
                    tabs: const [
                      Tab(text: 'Booking Requests'),
                      Tab(text: 'Accepted Bookings'),
                    ],
                  ),
                  Expanded(
                      child: TabBarView(children: [
                    Scaffold(
                      body: ListView.builder(
                        itemCount: bookingRequests.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            elevation: 5,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'Arrival Date: ${bookingRequests[index].arrivalDate}'),
                                  Text(
                                      'Customer Contact: ${bookingRequests[index].customerContact}'),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            acceptedRequests
                                                .add(bookingRequests[index]);
                                            bookingRequests
                                                .remove(bookingRequests[index]);
                                          });
                                        },
                                        child: const Text('Accept'),
                                      ),
                                      const SizedBox(width: 10),
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            bookingRequests
                                                .remove(bookingRequests[index]);
                                          });
                                        },
                                        child: const Text('Decline'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Scaffold(
                      body: ListView.builder(
                        itemCount: acceptedRequests.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            elevation: 5,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'Arrival Date: ${bookingRequests[index].arrivalDate}'),
                                  Text(
                                      'Customer Contact: ${bookingRequests[index].customerContact}'),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ]))
                ],
              );
            }),
      ),
    );
  }
}
