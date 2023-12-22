import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app/NewTrip.dart';
import 'package:my_app/Service%20Providers/hotels_page.dart';
import 'package:my_app/Service%20Providers/local_guide.dart';
import 'package:my_app/Service%20Providers/transport_page.dart';
import 'package:my_app/touristDashboard/friends.dart';
import 'package:my_app/touristDashboard/social.dart';
import 'package:my_app/user_management/login_page.dart';
import 'package:uuid/uuid.dart';

class HomeScreen extends StatefulWidget {
  final String email;
  const HomeScreen({Key? key, required this.email}) : super(key: key);

  @override
  State<HomeScreen> createState() => _Home();
}

class _Home extends State<HomeScreen> {
  bool newTrip = false;
  int _currentIndex = 0;

  List<String> imagePaths = [
    "assets/icons/trips/trip_image1.png",
    "assets/icons/trips/trip_image2.png",
    "assets/icons/trips/trip_image3.png",
    "assets/icons/trips/trip_image4.png",
  ];

  File? profilePic;
  void uploadPic(String docid) async {
    UploadTask uploadTask = FirebaseStorage.instance
        .ref()
        .child("profilepictures")
        .child(const Uuid().v1())
        .putFile(profilePic!);
    print(docid);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    await FirebaseFirestore.instance
        .collection("tourists")
        .doc(docid)
        .update({"profilepic": downloadUrl});
    await FirebaseFirestore.instance
        .collection("tourists")
        .doc(docid)
        .update({"profilepic": "helllo"});
  }

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 235, 239, 250),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("tourists")
              .where('email', isEqualTo: widget.email)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData && snapshot.data != null) {
                Map<String, dynamic> userMap =
                    snapshot.data!.docs.first.data() as Map<String, dynamic>;
                return IndexedStack(
                  index: _currentIndex,
                  children: [
                    // Home Page
                    Center(
                      child: Column(children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 0, left: 0, top: 10, bottom: 0),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 10, left: 0, right: 10, bottom: 20),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      disabledBackgroundColor:
                                          const Color.fromARGB(
                                              255, 71, 187, 216),
                                      // foregroundColor:
                                      //     Color.fromARGB(255, 71, 187, 216),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      fixedSize: const Size(400, 80)),
                                  onPressed: null,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Hello ${userMap['name']}",
                                        style: const TextStyle(
                                          color: Color.fromRGBO(11, 11, 12, 1),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25,
                                        ),
                                      ),
                                      MaterialButton(
                                        onPressed: () async {
                                          XFile? selectedImage =
                                              await ImagePicker().pickImage(
                                                  source: ImageSource.gallery);

                                          if (selectedImage != null) {
                                            File convertedFile =
                                                File(selectedImage.path);
                                            setState(() {
                                              profilePic = convertedFile;
                                            });
                                            DocumentSnapshot snp =
                                                snapshot.data!.docs.first;
                                            uploadPic(snp.id);
                                            print("Image selected!");
                                          } else {
                                            print("No image selected!");
                                          }
                                        },
                                        padding:
                                            const EdgeInsets.only(left: 70),
                                        child: CircleAvatar(
                                          radius: 36,
                                          backgroundImage: (profilePic != null)
                                              ? FileImage(profilePic!)
                                              : null,
                                          backgroundColor: Colors.red,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: TextFormField(
                                    decoration: const InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.search,
                                          size: 25,
                                          color: Color.fromRGBO(
                                              121, 130, 155, 1.0),
                                        ),
                                        disabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        labelText:
                                            'Search country,city or any place',
                                        labelStyle: TextStyle(
                                          color: Color.fromRGBO(
                                              121, 130, 155, 1.0),
                                          fontSize: 16,
                                          fontStyle: FontStyle.italic,
                                        ),
                                        border: OutlineInputBorder(),
                                        filled: true,
                                        fillColor: Color.fromRGBO(
                                            243, 246, 255, 1.0))),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10, right: 20, left: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 30, top: 10),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Hotels()));
                                      },
                                      style: ElevatedButton.styleFrom(
                                        fixedSize: const Size(130, 120),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        padding: const EdgeInsets.all(16.0),
                                        backgroundColor: Colors
                                            .blue, // Change the button color as needed
                                      ),
                                      child: const Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons
                                                .home_outlined, // Replace this with the desired icon
                                            size: 50.0,
                                            color: Colors
                                                .white, // Change the icon color as needed
                                          ),
                                          SizedBox(height: 8.0),
                                          Text(
                                            'Hotels',
                                            style: TextStyle(
                                              fontSize: 24.0,
                                              color: Colors
                                                  .black, // Change the text color as needed
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, right: 10),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Transport()));
                                      },
                                      style: ElevatedButton.styleFrom(
                                        fixedSize: const Size(130, 120),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        padding: const EdgeInsets.all(16.0),
                                        backgroundColor: Colors
                                            .blue, // Change the button color as needed
                                      ),
                                      child: const Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.car_rental_outlined,
                                            size: 50.0,
                                            color: Colors
                                                .white, // Change the icon color as needed
                                          ),
                                          SizedBox(height: 8.0),
                                          Text(
                                            'Transport',
                                            style: TextStyle(
                                              fontSize: 19.0,
                                              color: Colors
                                                  .black, // Change the text color as needed
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 100, height: 30),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LocalGuide()));
                                },
                                style: ElevatedButton.styleFrom(
                                  fixedSize: const Size(180, 100),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  padding: const EdgeInsets.all(16.0),
                                  backgroundColor: Colors
                                      .blue, // Change the button color as needed
                                ),
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.tour_outlined,
                                      size: 50.0,
                                      color: Colors
                                          .white, // Change the icon color as needed
                                    ),
                                    SizedBox(height: 2.0),
                                    Text(
                                      'Local Guides',
                                      style: TextStyle(
                                        fontSize: 22.0,
                                        color: Colors
                                            .black, // Change the text color as needed
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(left: 10, right: 10, top: 10),
                          child: Column(
                            children: [
                              Text("Popular Places",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20)),
                              SizedBox(
                                width: 250,
                                height: 150,
                                child: ListView.builder(
                                  itemCount: imagePaths.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        image: DecorationImage(
                                          image: AssetImage(imagePaths[index]),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      width:
                                          100.0, // Adjust the width as needed
                                      margin: EdgeInsets.all(8.0),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                      ]),
                    ),
                    const Center(
                      child: Text("Groups"),
                    ),
                    const Center(
                      child: Text("Groups"),
                    ),
                    Center(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "My Trips",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: Image.asset(
                                  'assets/icons/trips/trip_image1.png',
                                  width: 150,
                                  height: 160,
                                ),
                              ),
                              Image.asset(
                                'assets/icons/trips/trip_image2.png',
                                width: 150,
                                height: 160,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: Image.asset(
                                  'assets/icons/trips/trip_image3.png',
                                  width: 150,
                                  height: 160,
                                ),
                              ),
                              Image.asset(
                                'assets/icons/trips/trip_image4.png',
                                width: 150,
                                height: 160,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromRGBO(16, 136, 174, 1.0),
                                  fixedSize: const Size(230, 50)),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => NewTrip(
                                              createdBy: userMap["name"],
                                              friends: [
                                                "mahtab",
                                                "shoaib",
                                                "saad"
                                              ],
                                            )));
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 24.0,
                                  ),
                                  Text(
                                    '   Create New Trip',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  )
                                ],
                              )),
                        ),
                      ],
                    )),
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(width: 400, height: 30),
                          const CircleAvatar(
                            radius: 46,
                            backgroundColor: Colors.grey,
                          ),
                          const SizedBox(width: 400, height: 10),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  userMap["name"],
                                  style: const TextStyle(
                                      fontSize: 24,
                                      color: Color.fromRGBO(48, 55, 72, 1.0)),
                                ),
                                IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.black,
                                    ))
                              ],
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
                              label: Text(userMap["email"],
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
                              label: Text(userMap["mobile number"],
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
                  ],
                );
              } else {
                return const Text("No data");
              }
            } else {
              return const Text("No data");
            }
          }),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined,
                color: Color.fromARGB(255, 99, 219, 255)),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.south_america,
                color: Color.fromARGB(255, 99, 219, 255)),
            label: 'Social',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.groups_2_rounded,
                color: Color.fromARGB(255, 99, 219, 255)),
            label: 'Friends',
          ),
          BottomNavigationBarItem(
            icon:
                Icon(Icons.list_alt, color: Color.fromARGB(255, 99, 219, 255)),
            label: 'Trips',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_pin,
                color: Color.fromARGB(255, 99, 219, 255)),
            label: 'Profile',
          ),
        ],
        backgroundColor: Colors.white,
        selectedItemColor: const Color.fromARGB(255, 99, 219, 255),
        unselectedItemColor: const Color.fromRGBO(48, 55, 72, 1.0),
        selectedFontSize: 18,
        unselectedFontSize: 16,
        showUnselectedLabels: true,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            if (index == 1) {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Social()));
            } else if (index == 2) {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Friends()));
            } else {
              _currentIndex = index;
            }
          });
        },
      ),
    );
  }
}
