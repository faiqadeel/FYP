// ignore_for_file: use_build_context_synchronously, no_leading_underscores_for_local_identifiers

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:my_app/Trip%20Itineraries/NewTrip.dart';
import 'package:my_app/Trip%20Itineraries/TripScreen.dart';
import 'package:my_app/Trip%20Itineraries/ViewTrip.dart';
import 'package:my_app/components/Colors.dart';
import 'package:my_app/components/dialogBox.dart';
import 'package:my_app/touristDashboard/Service%20Provider%20Screens/local_guide.dart';
import 'package:my_app/touristDashboard/Service%20Provider%20Screens/transport_page.dart';
import 'package:my_app/touristDashboard/friends.dart';
import 'package:my_app/touristDashboard/social.dart';
import 'package:my_app/user_management/login_page.dart';

import '../components/textFieldComponent.dart';
import '../touristDashboard/Service Provider Screens/hotels_page.dart';

class HomeScreen extends StatefulWidget {
  final String email;
  const HomeScreen({Key? key, required this.email}) : super(key: key);

  @override
  State<HomeScreen> createState() => _Home();
}

class _Home extends State<HomeScreen> {
  List<String> popPlaces = [];
  List<String> placeURLs = [];
  bool newTrip = false;
  int _currentIndex = 0;
  Uint8List? _image;
  String name = '';
  String email = '';
  String profileURL = '';
  List<dynamic>? friends;
  bool editName = false;
  String current = 'home';
  String mobileNumber = "";
  Map<String, String> userData = {};
  TextEditingController nameController = TextEditingController();

  List<String> imagePaths = [
    "assets/icons/trips/trip_image1.png",
    "assets/icons/trips/trip_image2.png",
    "assets/icons/trips/trip_image3.png",
    "assets/icons/trips/trip_image4.png",
  ];
  Future<Uint8List> getImageFromUrl() async {
    Uint8List? image = _image;
    try {
      Future<String> downloadUrl = FirebaseStorage.instance
          .ref()
          .child("Profile Pics/github profile.JPG")
          .getDownloadURL();
      http.Response response = await http.get(Uri.parse(downloadUrl as String));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      }
    } catch (e) {
      error_dialogue_box(context, "Error Fetching image");
    }
    throw Null;
  }

  Future<List<String>> getWebsiteData() async {
    print("inside");
    final url = Uri.parse(
        "https://www.thebrokebackpacker.com/beautiful-places-in-pakistan/");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      dom.Document html = parser.parse(response.body);

      final places = html
          .querySelectorAll(
              'h2.wp-block-heading.has-text-align-center') // Corrected
          .map((element) =>
              element.text.trim()) // Use text for just the text content
          .toList();

      final imageURLs = html
          .querySelectorAll(
              "#content > article > div > div > div.col-12.order-2.offset-md-1.col-md-10.offset-lg-0.col-lg-8.order-lg-1 > div > article > div:nth-child(48) > figure > img") // Corrected
          .map((e) =>
              e.attributes['src'] ??
              "") // Check for null and provide a default value
          .toList();

      // Assuming this is a Flutter Stateful Widget method
      setState(() {
        this.popPlaces = places;
        this.placeURLs = imageURLs;
      });

      return imageURLs;
    } else {
      throw Exception('Failed to load website data');
    }
  }

  Future<String> getUserData() async {
    CollectionReference myCollection =
        await FirebaseFirestore.instance.collection('tourists');
    QuerySnapshot docs =
        await myCollection.where("email", isEqualTo: widget.email).get();
    DocumentSnapshot myDoc = docs.docs.first;
    setState(() {
      name = myDoc['name'];
      mobileNumber = myDoc['mobile number'];
      profileURL = myDoc['Profile URL'];
    });
    return myDoc['name'];
  }

  @override
  void init() {
    super.initState();
    getUserData();
    setState(() {
      email = widget.email;
      nameController.text = name;
    });
  }

  Future<List<Map<String, dynamic>>> fetchTripItinerary() async {
    List<Map<String, dynamic>> trips = [];
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('Trip Itinerary').get();
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          var partners = data['Trip Partners'];
          if (name == data['Created By'] || partners.contains(name)) {
            trips.add({
              'pictureUrl': data[
                  'Picture URL'], // Assuming this is the field name for the picture URL
              'tripName': data['Trip Name'],
              'createdBy': data['Created By'],
            });
          }
        }
      }
    } catch (e) {
      print('Error fetching trip itinerary: $e');
    }
    return trips;
  }

  void updateName(String updatedName) async {
    if (name != updatedName) {
      try {
        CollectionReference myCollection =
            await FirebaseFirestore.instance.collection('tourists');
        QuerySnapshot docs =
            await myCollection.where("name", isEqualTo: name).get();
        DocumentReference docRef = myCollection.doc(docs.docs.first.id);
        await docRef.update({'name': updatedName});
        // ignore: use_build_context_synchronously
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('SUCCESS'),
                content: const Text("Name Updated Successfully"),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'))
                ],
              );
            });
      } catch (e) {
        error_dialogue_box(context, "An error occured while updating the name");
      }
    }
  }

  void uploadPic(XFile image) async {
    try {
      Uint8List fileBytes = await image.readAsBytes();
      Reference ref =
          FirebaseStorage.instance.ref("Profile_Pics").child("${widget.email}");
      TaskSnapshot task = await ref.putData(fileBytes);
      String downloadurl = await task.ref.getDownloadURL();
      print(downloadurl);
    } catch (e) {
      error_dialogue_box(context, e.toString());
    }

    //   UploadTask uploadTask = FirebaseStorage.instance
    //       .ref()
    //       .child("profilepictures")
    //       .child(const Uuid().v1())
    //       .putFile(profilePic!);
    //   print(docid);
    //   TaskSnapshot taskSnapshot = await uploadTask;
    //   String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    //   await FirebaseFirestore.instance
    //       .collection("tourists")
    //       .doc(docid)
    //       .update({"profilepic": downloadUrl});
    //   await FirebaseFirestore.instance
    //       .collection("tourists")
    //       .doc(docid)
    //       .update({"profilepic": "helllo"});
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

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Scaffold(
      backgroundColor: backgroundColor(),
      resizeToAvoidBottomInset: true,
      body: FutureBuilder<String>(
          future: getUserData(),
          builder: (context, snapshot) {
            // if (snapshot.connectionState == ConnectionState.waiting) {
            //   return const Center(
            //       child:
            //           CircularProgressIndicator()); // Show a loading indicator while fetching data
            // } else {
            return SafeArea(
              child: IndexedStack(
                index: _currentIndex,
                children: [
                  // Home Page
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10, right: 0, bottom: 0, left: 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 0),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                height: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: AppBarBackground(),
                                  shape: BoxShape.rectangle,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Hello ${name}",
                                      style: TextStyle(
                                        color: button1(),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25,
                                      ),
                                    ),
                                    Stack(
                                      children: [
                                        profileURL != ""
                                            ? CircleAvatar(
                                                radius: 35,
                                                backgroundImage:
                                                    NetworkImage(profileURL),
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
                                                      alignment:
                                                          Alignment.center,
                                                      child: const Icon(
                                                          Icons
                                                              .add_a_photo_rounded,
                                                          size: 24.0),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.search,
                                    size: 25,
                                    color: Colors.grey,
                                  ),
                                  disabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  labelText:
                                      'Search country, city, or any place',
                                  labelStyle: TextStyle(
                                    color: button1(),
                                    fontSize: 16,
                                    fontStyle: FontStyle.italic,
                                  ),
                                  border: const OutlineInputBorder(),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        height: 70,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: button1(),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            padding: const EdgeInsets.all(16.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Start a Trip",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => NewTrip(
                                        createdBy: widget.email,
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.arrow_circle_right_outlined,
                                  size: 40,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 20),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildCircleButton(
                                    icon: Icons.home_outlined,
                                    label: "Hotels",
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => HotelScreen(),
                                        ),
                                      );
                                    }),
                                _buildCircleButton(
                                    icon: Icons.car_rental_outlined,
                                    label: "Transport",
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Transport(),
                                        ),
                                      );
                                    }),
                                _buildCircleButton(
                                    icon: Icons.tour_outlined,
                                    label: "Local Guide",
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => LocalGuide(),
                                        ),
                                      );
                                    }),
                              ])),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              "Popular Places",
                              style: TextStyle(
                                color: button1(),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // FutureBuilder<List<String>>(
                            //     future: getWebsiteData(),
                            //     builder: (context, snapshot) {
                            //       return SizedBox(
                            //         height: 150,
                            //         child: ListView.builder(
                            //           scrollDirection: Axis.horizontal,
                            //           itemCount: popPlaces.length,
                            //           itemBuilder:
                            //               (BuildContext context, int index) {
                            //             final names = popPlaces[index];
                            //             final url = placeURLs[index];
                            //             return Container(
                            //               decoration: BoxDecoration(
                            //                 borderRadius:
                            //                     BorderRadius.circular(10.0),
                            //                 // image: DecorationImage(
                            //                 //   image: NetworkImage(url),
                            //                 //   fit: BoxFit.cover,
                            //                 // ),
                            //               ),
                            //               child: Center(child: Text(names)),
                            //               width:
                            //                   250.0, // Adjust the width as needed
                            //               margin: const EdgeInsets.all(8.0),
                            //             );
                            //           },
                            //         ),
                            //       );
                            //     }),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Center(
                    child: Text("Groups"),
                  ),
                  const Center(
                    child: Text("Groups"),
                  ),
                  Scaffold(
                    appBar: AppBar(
                      title: Text(
                        "My Trips",
                        style: AppBarTextStyle(),
                      ),
                      backgroundColor: AppBarBackground(),
                      centerTitle: true,
                    ),
                    body: FutureBuilder<List<Map<String, dynamic>>>(
                      future: fetchTripItinerary(),
                      builder: (context, snapshot) {
                        // if (snapshot.connectionState ==
                        //     ConnectionState.waiting) {
                        //   return const Center(
                        //       child: CircularProgressIndicator());
                        // } else if (snapshot.hasError) {
                        //   return Center(
                        //       child: Text('Error: ${snapshot.error}'));
                        // } else if (!snapshot.hasData ||
                        //     snapshot.data!.isEmpty) {
                        //   return const Center(child: Text('No data available'));
                        // } else {
                        return GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // Two items per row
                          ),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            var trip = snapshot.data![index];
                            return Container(
                              margin: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(trip['pictureUrl']),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: 10,
                                    left: 10,
                                    child: Text(
                                      trip['tripName'],
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        backgroundColor:
                                            Colors.black.withOpacity(0.5),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 60,
                                    left: 10,
                                    child: Text(
                                      trip['createdBy'] == name
                                          ? "By You"
                                          : 'By ${trip['createdBy']}',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        backgroundColor:
                                            Colors.black.withOpacity(0.5),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 10,
                                    bottom: 10,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        trip['createdBy'] == name
                                            ? Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        TripScreen(
                                                          tripName:
                                                              trip['tripName'],
                                                        )))
                                            : Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ViewTrip(
                                                          tripName:
                                                              trip['tripName'],
                                                        )));
                                      },
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor:
                                            button1(), // Button text color
                                      ),
                                      child: trip['createdBy'] == name
                                          ? const Text("Edit Trip")
                                          : const Text("View Trip"),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Center(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(width: 400, height: 30),
                          Stack(children: [
                            _image != null
                                ? CircleAvatar(
                                    radius: 35,
                                    backgroundImage: MemoryImage(_image!),
                                  )
                                : const CircleAvatar(
                                    radius: 35,
                                    backgroundImage: NetworkImage(
                                        'https://static.vecteezy.com/system/resources/thumbnails/005/544/718/small/profile-icon-design-free-vector.jpg')),
                            Positioned(
                                bottom: -12,
                                left: 35,
                                child: IconButton(
                                    color: Colors.black,
                                    icon: const Icon(Icons.add_a_photo_rounded),
                                    onPressed: uploadImage)),
                          ]),
                          const SizedBox(width: 400, height: 10),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: name!.length * 8 + 60,
                              alignment: Alignment.center,
                              child: TextField(
                                onTap: () {
                                  setState(() {
                                    editName = true;
                                  });
                                },
                                onTapOutside: (text) {
                                  setState(() {
                                    editName = false;
                                  });
                                  updateName(nameController.text);
                                },
                                readOnly: false,
                                autofocus: editName,
                                controller: nameController,
                                // Allow the TextField to expand vertically based on content
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    suffixIcon: Icon(Icons.edit)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 400, height: 15),
                          TextButton.icon(
                              style: ButtonStyle(
                                alignment: Alignment.centerLeft,
                                fixedSize: MaterialStateProperty.all<Size>(
                                    const Size(300, 50.0)),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.transparent),
                                shape:
                                    MaterialStateProperty.all<OutlinedBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        10.0), // Adjust the radius as needed
                                    side: const BorderSide(
                                        color: Color.fromRGBO(48, 55, 72,
                                            1.00)), // Set the border color
                                  ),
                                ),
                              ),
                              onPressed: () {},
                              icon: const Icon(
                                Icons.email,
                                color: Colors.black,
                                size: 33,
                              ),
                              label: Text("${widget.email}",
                                  style: const TextStyle(
                                      color: Color.fromRGBO(48, 55, 72, 1.0),
                                      fontSize: 20,
                                      overflow: TextOverflow.clip))),
                          const SizedBox(width: 400, height: 15),
                          TextButton.icon(
                              style: ButtonStyle(
                                alignment: Alignment.centerLeft,
                                fixedSize: MaterialStateProperty.all<Size>(
                                    const Size(300, 50.0)),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.transparent),
                                shape:
                                    MaterialStateProperty.all<OutlinedBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        10.0), // Adjust the radius as needed
                                    side: const BorderSide(
                                        color: Color.fromRGBO(48, 55, 72,
                                            1.00)), // Set the border color
                                  ),
                                ),
                              ),
                              onPressed: () {},
                              icon: const Icon(
                                Icons.phone,
                                color: Colors.black,
                                size: 33,
                              ),
                              label: Text("${mobileNumber}",
                                  style: const TextStyle(
                                      color: Color.fromRGBO(48, 55, 72, 1.0),
                                      fontSize: 20,
                                      overflow: TextOverflow.clip))),
                          const SizedBox(width: 400, height: 15),
                          TextButton.icon(
                              style: ButtonStyle(
                                alignment: Alignment.centerLeft,
                                fixedSize: MaterialStateProperty.all<Size>(
                                    const Size(300, 50.0)),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.transparent),
                                shape:
                                    MaterialStateProperty.all<OutlinedBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        10.0), // Adjust the radius as needed
                                    side: const BorderSide(
                                        color: Color.fromRGBO(48, 55, 72,
                                            1.00)), // Set the border color
                                  ),
                                ),
                              ),
                              onPressed: () {},
                              icon: const Icon(
                                Icons.pending_actions_outlined,
                                color: Colors.black,
                                size: 33,
                              ),
                              label: const Text("My Trips",
                                  style: TextStyle(
                                      color: Color.fromRGBO(48, 55, 72, 1.0),
                                      fontSize: 20,
                                      overflow: TextOverflow.clip))),
                          const SizedBox(width: 400, height: 15),
                          TextButton.icon(
                              style: ButtonStyle(
                                alignment: Alignment.centerLeft,
                                fixedSize: MaterialStateProperty.all<Size>(
                                    const Size(300, 50.0)),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.transparent),
                                shape:
                                    MaterialStateProperty.all<OutlinedBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        10.0), // Adjust the radius as needed
                                    side: const BorderSide(
                                        color: Color.fromRGBO(48, 55, 72,
                                            1.00)), // Set the border color
                                  ),
                                ),
                              ),
                              onPressed: () {},
                              icon: const Icon(
                                Icons.payment_rounded,
                                color: Colors.black,
                                size: 33,
                              ),
                              label: const Text("Payments",
                                  style: TextStyle(
                                      color: Color.fromRGBO(48, 55, 72, 1.0),
                                      fontSize: 20,
                                      overflow: TextOverflow.clip))),
                          const SizedBox(width: 400, height: 15),
                          TextButton.icon(
                              style: ButtonStyle(
                                alignment: Alignment.centerLeft,
                                fixedSize: MaterialStateProperty.all<Size>(
                                    const Size(300, 50.0)),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.transparent),
                                shape:
                                    MaterialStateProperty.all<OutlinedBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        10.0), // Adjust the radius as needed
                                    side: const BorderSide(
                                        color: Color.fromRGBO(48, 55, 72,
                                            1.00)), // Set the border color
                                  ),
                                ),
                              ),
                              onPressed: () {},
                              icon: const Icon(
                                Icons.book_online_outlined,
                                color: Colors.black,
                                size: 33,
                              ),
                              label: const Text("My Bookings",
                                  style: TextStyle(
                                      color: Color.fromRGBO(48, 55, 72, 1.0),
                                      fontSize: 20,
                                      overflow: TextOverflow.clip))),
                          const SizedBox(width: 400, height: 15),
                          TextButton.icon(
                              style: ButtonStyle(
                                alignment: Alignment.centerLeft,
                                fixedSize: MaterialStateProperty.all<Size>(
                                    const Size(300, 50.0)),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.transparent),
                                shape:
                                    MaterialStateProperty.all<OutlinedBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        10.0), // Adjust the radius as needed
                                    side: const BorderSide(
                                        color: Color.fromRGBO(48, 55, 72,
                                            1.00)), // Set the border color
                                  ),
                                ),
                              ),
                              onPressed: () {},
                              icon: const Icon(
                                Icons.monochrome_photos_outlined,
                                color: Colors.black,
                                size: 33,
                              ),
                              label: const Text("Posts",
                                  style: TextStyle(
                                      color: Color.fromRGBO(48, 55, 72, 1.0),
                                      fontSize: 20,
                                      overflow: TextOverflow.clip))),
                          const SizedBox(width: 400, height: 15),
                          TextButton.icon(
                              style: ButtonStyle(
                                alignment: Alignment.centerLeft,
                                fixedSize: MaterialStateProperty.all<Size>(
                                    const Size(300, 50.0)),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.transparent),
                                shape:
                                    MaterialStateProperty.all<OutlinedBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        10.0), // Adjust the radius as needed
                                    side: const BorderSide(
                                        color: Color.fromRGBO(48, 55, 72,
                                            1.00)), // Set the border color
                                  ),
                                ),
                              ),
                              onPressed: () {
                                Navigator.popUntil(
                                    context, (route) => route.isFirst);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginPage()));
                              },
                              icon: const Icon(
                                Icons.logout,
                                color: Colors.black,
                                size: 33,
                              ),
                              label: const Text("Logout",
                                  style: TextStyle(
                                      color: Color.fromRGBO(48, 55, 72, 1.0),
                                      fontSize: 20,
                                      overflow: TextOverflow.clip))),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined,
                color: _currentIndex == 0 ? AppBarBackground() : button1()),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.south_america,
                color: _currentIndex == 1 ? AppBarBackground() : button1()),
            label: 'Social',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.groups_2_rounded,
                color: _currentIndex == 2 ? AppBarBackground() : button1()),
            label: 'Friends',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt,
                color: _currentIndex == 3 ? AppBarBackground() : button1()),
            label: 'Trips',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_pin,
                color: _currentIndex == 4 ? AppBarBackground() : button1()),
            label: 'Profile',
          ),
        ],
        backgroundColor: const Color.fromRGBO(0, 0, 0, 1),
        selectedItemColor: AppBarBackground(),
        unselectedItemColor: button1(),
        selectedFontSize: 20,
        unselectedFontSize: 18,
        showUnselectedLabels: true,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            if (index == 1) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Social(name: name)));
            } else if (index == 2) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Friends(name: name!, email: widget.email)));
            } else {
              _currentIndex = index;
            }
          });
        },
      ),
    );
  }
}

Widget _buildCircleButton(
    {required IconData icon, required String label, required onPressed}) {
  return Column(
    mainAxisSize: MainAxisSize.min, // To make the column as big as its children
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      IconButton(
        iconSize: 50,
        icon: CircleAvatar(
          radius: 35,
          backgroundColor: button1(), // Your desired background color
          child: Icon(
            icon,
            color: Colors.white,
            size: 45,
          ), // Your desired icon
        ),
        onPressed: onPressed,
      ),
      Text(label,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: button1())), // Your desired styling for labels
    ],
  );
}
