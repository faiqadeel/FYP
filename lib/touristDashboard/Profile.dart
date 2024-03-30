import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_app/components/Colors.dart';
import 'package:my_app/components/textFieldComponent.dart';

class Profile extends StatefulWidget {
  final String friendName;
  final String name;
  const Profile({super.key, required this.friendName, required this.name});
  _Profile createState() => _Profile();
}

class _Profile extends State<Profile> {
  String? email;
  String? mobilenumber;
  String? downURL;
  void fetchData() async {
    QuerySnapshot docs = await FirebaseFirestore.instance
        .collection("tourists")
        .where("name", isEqualTo: widget.friendName)
        .get();
    DocumentSnapshot doc = docs.docs.first;
    setState(() {
      email = doc['email'];
      mobilenumber = doc['Mobile Number'];
      downURL = doc['Profile URL'];
    });
  }

  void unFriend() async {
    QuerySnapshot myDocs = await FirebaseFirestore.instance
        .collection("tourists")
        .where("name", isEqualTo: widget.name)
        .get();
    QuerySnapshot FrDocs = await FirebaseFirestore.instance
        .collection("tourists")
        .where("name", isEqualTo: widget.friendName)
        .get();
    DocumentReference myDoc = myDocs.docs.first.reference;
    DocumentReference frDoc = FrDocs.docs.first.reference;
    await myDoc.update({
      "Friends": FieldValue.arrayRemove([widget.friendName])
    });

    await frDoc.update({
      "Friends": FieldValue.arrayRemove([widget.name])
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile",
          style: AppBarTextStyle(),
        ),
        centerTitle: true,
        backgroundColor: AppBarBackground(),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(width: 400, height: 30),
              Stack(children: [
                downURL != null
                    ? CircleAvatar(
                        radius: 35,
                        backgroundImage: NetworkImage(downURL!),
                      )
                    : const CircleAvatar(
                        radius: 35,
                        backgroundImage: NetworkImage(
                            'https://static.vecteezy.com/system/resources/thumbnails/005/544/718/small/profile-icon-design-free-vector.jpg')),
              ]),
              const SizedBox(width: 400, height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    width: widget.friendName!.length * 8 + 60,
                    height: 40,
                    alignment: Alignment.center,
                    child: Text(
                      widget.friendName,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    )),
              ),
              const SizedBox(width: 400, height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                        style: ButtonStyle(
                          alignment: Alignment.centerLeft,
                          fixedSize: MaterialStateProperty.all<Size>(
                              const Size(150, 50.0)),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(button1()),
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  10.0), // Adjust the radius as needed
                              side: BorderSide(
                                  color: button1()), // Set the border color
                            ),
                          ),
                        ),
                        onPressed: () {},
                        icon: const Icon(
                          Icons.person_remove_sharp,
                          color: Colors.white,
                          size: 33,
                        ),
                        label: const Text("unfriend",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                overflow: TextOverflow.clip))),
                    TextButton.icon(
                        style: ButtonStyle(
                          alignment: Alignment.centerLeft,
                          fixedSize: MaterialStateProperty.all<Size>(
                              const Size(150, 50.0)),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(button1()),
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  10.0), // Adjust the radius as needed
                              side: BorderSide(
                                  color: button1()), // Set the border color
                            ),
                          ),
                        ),
                        onPressed: () {},
                        icon: const Icon(
                          Icons.telegram_outlined,
                          color: Colors.white,
                          size: 33,
                        ),
                        label: const Text("Message",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                overflow: TextOverflow.clip))),
                  ],
                ),
              ),
              const SizedBox(width: 400, height: 15),
              TextButton.icon(
                  style: ButtonStyle(
                    alignment: Alignment.centerLeft,
                    fixedSize:
                        MaterialStateProperty.all<Size>(const Size(300, 50.0)),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.transparent),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            10.0), // Adjust the radius as needed
                        side: const BorderSide(
                            color: Color.fromRGBO(
                                48, 55, 72, 1.00)), // Set the border color
                      ),
                    ),
                  ),
                  onPressed: () {},
                  icon: const Icon(
                    Icons.email,
                    color: Colors.black,
                    size: 33,
                  ),
                  label: Text("${email}",
                      style: const TextStyle(
                          color: Color.fromRGBO(48, 55, 72, 1.0),
                          fontSize: 20,
                          overflow: TextOverflow.clip))),
              const SizedBox(width: 400, height: 15),
              TextButton.icon(
                  style: ButtonStyle(
                    alignment: Alignment.centerLeft,
                    fixedSize:
                        MaterialStateProperty.all<Size>(const Size(300, 50.0)),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.transparent),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            10.0), // Adjust the radius as needed
                        side: const BorderSide(
                            color: Color.fromRGBO(
                                48, 55, 72, 1.00)), // Set the border color
                      ),
                    ),
                  ),
                  onPressed: () {},
                  icon: const Icon(
                    Icons.phone,
                    color: Colors.black,
                    size: 33,
                  ),
                  label: Text("${mobilenumber}",
                      style: const TextStyle(
                          color: Color.fromRGBO(48, 55, 72, 1.0),
                          fontSize: 20,
                          overflow: TextOverflow.clip))),
              const SizedBox(width: 400, height: 15),
              TextButton.icon(
                  style: ButtonStyle(
                    alignment: Alignment.centerLeft,
                    fixedSize:
                        MaterialStateProperty.all<Size>(const Size(300, 50.0)),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.transparent),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            10.0), // Adjust the radius as needed
                        side: const BorderSide(
                            color: Color.fromRGBO(
                                48, 55, 72, 1.00)), // Set the border color
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
            ],
          ),
        ),
      ),
    );
  }
}
