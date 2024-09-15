// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../components/Colors.dart';
import '../../components/dialogBox.dart';
import '../../components/textFieldComponent.dart';

class HotelOwner extends StatefulWidget {
  final String provider_id;
  const HotelOwner({super.key, required this.provider_id});

  @override
  State<HotelOwner> createState() => _HotelOwnerState();
}

class Room {
  String roomNo;
  String roomType;
  bool occupied;
  String capacity;
  String chargesPerNight;

  Room({
    required this.roomNo,
    required this.roomType,
    required this.occupied,
    required this.capacity,
    required this.chargesPerNight,
  });
}

class Dish {
  String dishName;
  String price;

  Dish({
    required this.dishName,
    required this.price,
  });
}

class BookingRequests {
  String checkinDate;
  String roomsRequired;
  String roomType;
  String customerContact;

  BookingRequests(
      {required this.checkinDate,
      required this.customerContact,
      required this.roomType,
      required this.roomsRequired});
}

class _HotelOwnerState extends State<HotelOwner>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Room> roomList = [];
  String name = '';
  List<Dish> dishList = [];
  List<BookingRequests> bookingRequests = [];
  List<BookingRequests> acceptedRequests = [];
  TextEditingController _textEditingController = TextEditingController();
  bool _isReadOnly = true;
  TextEditingController nameController = TextEditingController();
  void addRoom() async {
    TextEditingController roomNo = TextEditingController();
    TextEditingController roomType = TextEditingController();
    TextEditingController capacity = TextEditingController();
    TextEditingController chargesPerNight = TextEditingController();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Room Details"),
            backgroundColor: dialogueBoxBackground(),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter
                        .digitsOnly, // Allow only digits (numbers)
                  ],
                  keyboardType: TextInputType.number,
                  controller: roomNo,
                  decoration: const InputDecoration(
                    labelText: 'Enter Room No',
                    labelStyle: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: roomType,
                  decoration: const InputDecoration(
                    labelText: 'Enter Room Type',
                    labelStyle: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter
                        .digitsOnly, // Allow only digits (numbers)
                  ],
                  keyboardType: TextInputType.number,
                  controller: capacity,
                  decoration: const InputDecoration(
                    labelText: 'Enter Seating capacity of the room',
                    labelStyle: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter
                        .digitsOnly, // Allow only digits (numbers)
                  ],
                  keyboardType: TextInputType.number,
                  controller: chargesPerNight,
                  decoration: const InputDecoration(
                    labelText: 'Enter Charges per Night',
                    labelStyle: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  if (roomNo.text.isEmpty ||
                      roomType.text.isEmpty ||
                      capacity.text.isEmpty ||
                      chargesPerNight.text.isEmpty) {
                    error_dialogue_box(
                        context, "Please fill out all the fields");
                  } else {
                    Room newRoom = Room(
                        roomNo: roomNo.text.trim(),
                        roomType: roomType.text.trim(),
                        capacity: capacity.text.trim(),
                        chargesPerNight: chargesPerNight.text.trim(),
                        occupied: false);
                    setState(() {
                      roomList.add(newRoom);
                    });
                    final CollectionReference collRef = FirebaseFirestore
                        .instance
                        .collection("Service Providers");
                    final QuerySnapshot hotelDocs = await collRef
                        .where("Phone Number", isEqualTo: widget.provider_id)
                        .get();
                    String docId = hotelDocs.docs.first.id;
                    await collRef.doc(docId).collection("Rooms").add({
                      'Room No': newRoom.roomNo,
                      'Room Type': newRoom.roomType,
                      'Occupied': newRoom.occupied,
                      'Capacity': newRoom.capacity,
                      'Charges Per Night': newRoom.chargesPerNight,
                    });
                    Navigator.of(context).pop();
                  }
                },
                child: Text(
                  'Confirm Details',
                  style:
                      TextStyle(color: button2(), fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        });
  }

  void addDish() {
    // Add a new dish to the dishList
    TextEditingController dishName = TextEditingController();
    TextEditingController price = TextEditingController();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Dish Details"),
            backgroundColor: dialogueBoxBackground(),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: dishName,
                  decoration: const InputDecoration(
                    labelText: 'Enter Dish Name',
                    labelStyle: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter
                        .digitsOnly, // Allow only digits (numbers)
                  ],
                  keyboardType: TextInputType.number,
                  controller: price,
                  decoration: const InputDecoration(
                    labelText: 'Enter price of dish',
                    labelStyle: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  if (dishName.text.isEmpty || price.text.isEmpty) {
                    error_dialogue_box(
                        context, "Please fill out all the fields");
                  } else {
                    Dish newDish = Dish(
                        dishName: dishName.text.trim(),
                        price: price.text.trim());
                    setState(() {
                      dishList.add(newDish);
                    });
                    final CollectionReference collRef = FirebaseFirestore
                        .instance
                        .collection("Service Providers");
                    final QuerySnapshot hotelDocs = await collRef
                        .where("Phone Number", isEqualTo: widget.provider_id)
                        .get();
                    String docId = hotelDocs.docs.first.id;
                    await collRef.doc(docId).collection("Dishes").add({
                      "Dish Name": newDish.dishName,
                      "Price": newDish.price
                    });
                    Navigator.of(context).pop();
                  }
                },
                child: Text(
                  'Confirm Details',
                  style:
                      TextStyle(color: button2(), fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _textEditingController.dispose();
    nameController.dispose();

    super.dispose();
  }

  Uint8List? _image;
  Future<List<Room>> getData() async {
    try {
      final CollectionReference hotelOwner =
          FirebaseFirestore.instance.collection("Service Providers");
      final QuerySnapshot ownerDocs = await hotelOwner
          .where("Phone Number", isEqualTo: widget.provider_id)
          .get();
      final DocumentSnapshot current = ownerDocs.docs.first;
      setState(() {
        if (current["Hotel Name"] == "") {
          nameController.text = current["Hotel Name"];
          _isReadOnly = false;
        }
        name = current['Owner Name'];
      });

      final CollectionReference roomsRef =
          hotelOwner.doc(current.id).collection("Rooms");
      final CollectionReference dishRef =
          hotelOwner.doc(current.id).collection("Dishes");
      final CollectionReference reqRef =
          hotelOwner.doc(current.id).collection("Booking Requests");
      final CollectionReference accRef =
          hotelOwner.doc(current.id).collection("Accepted Requests");
      QuerySnapshot rooms = await roomsRef.get();
      QuerySnapshot dishes = await dishRef.get();
      QuerySnapshot requests = await reqRef.get();
      QuerySnapshot accReq = await accRef.get();
      roomList = [];
      for (var room in rooms.docs) {
        Room newRoom = Room(
            roomNo: room["Room No"],
            roomType: room["Room Type"],
            occupied: room["Occupied"],
            capacity: room["Capacity"],
            chargesPerNight: room["Charges Per Night"]);
        roomList.add(newRoom);
      }
      dishList = [];
      for (var dish in dishes.docs) {
        Dish newDish = Dish(
          dishName: dish["Dish Name"],
          price: dish["Price"],
        );
        dishList.add(newDish);
      }
      bookingRequests = [];
      for (var request in requests.docs) {
        BookingRequests newRequest = BookingRequests(
            checkinDate: request['Check in Date'],
            customerContact: request['Customer Contact'],
            roomType: request['Room Type'],
            roomsRequired: request['Rooms Required']);
        bookingRequests.add(newRequest);
      }
      acceptedRequests = [];
      for (var request in accReq.docs) {
        BookingRequests newRequest = BookingRequests(
            checkinDate: request['Check in Date'],
            customerContact: request['Customer Contact'],
            roomType: request['Room Type'],
            roomsRequired: request['Rooms Required']);
        acceptedRequests.add(newRequest);
      }
    } catch (e) {
      error_dialogue_box(context, e.toString());
    }
    return roomList;
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
        body: FutureBuilder<List<Room>>(
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
                      Tab(text: 'My Hotel'),
                      Tab(text: 'Booking Requests'),
                      Tab(text: 'Accepted Bookings'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        Scaffold(
                            body: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            TextField(
                              controller: nameController,
                              readOnly: nameController.text.isEmpty
                                  ? !_isReadOnly
                                  : _isReadOnly,
                              onTapOutside: (event) async {
                                if (nameController.text.isNotEmpty &&
                                    _isReadOnly) {
                                  final CollectionReference hotelOwner =
                                      FirebaseFirestore.instance
                                          .collection("Service Providers");
                                  final QuerySnapshot ownerDocs =
                                      await hotelOwner
                                          .where("Phone Number",
                                              isEqualTo: widget.provider_id)
                                          .get();
                                  await hotelOwner
                                      .doc(ownerDocs.docs.first.id)
                                      .update(
                                          {"Hotel Name": nameController.text});
                                }
                              },
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: TextFieldBackground(),
                                  disabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromARGB(255, 61, 62, 65)),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromARGB(255, 61, 62, 65),
                                          width: 0.0),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: const Color.fromARGB(
                                              255, 61, 62, 65)),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10))),
                                  labelText: nameController.text.isEmpty
                                      ? "Enter Hotel Name"
                                      : "",
                                  labelStyle: const TextStyle(
                                    color: Color.fromRGBO(48, 55, 72, 1.00),
                                    fontSize: 20,
                                    fontStyle: FontStyle.italic,
                                  ),
                                  border: const OutlineInputBorder()),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Rooms Information:",
                              style: TextStyle(
                                  color: button1(),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                            SingleChildScrollView(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                dataRowMinHeight: 2,
                                headingTextStyle: const TextStyle(
                                    fontSize: 19, fontWeight: FontWeight.bold),
                                border: TableBorder.all(
                                    width: 2,
                                    color: Colors.black,
                                    style: BorderStyle.solid,
                                    borderRadius: BorderRadius.circular(5)),
                                columns: const [
                                  DataColumn(label: Text('Room No')),
                                  DataColumn(label: Text('Room Type')),
                                  DataColumn(label: Text('Occupied')),
                                  DataColumn(label: Text('Capacity')),
                                  DataColumn(label: Text('Charges Per Night')),
                                ],
                                rows: roomList.map((room) {
                                  return DataRow(cells: [
                                    DataCell(TextField(
                                        controller: TextEditingController(
                                            text: room.roomNo))),
                                    DataCell(TextField(
                                        controller: TextEditingController(
                                            text: room.roomType))),
                                    DataCell(Checkbox(
                                        value: room.occupied,
                                        onChanged: (value) {
                                          setState(() {
                                            room.occupied = !room.occupied;
                                          });
                                        })),
                                    DataCell(TextField(
                                        controller: TextEditingController(
                                            text: room.capacity.toString()))),
                                    DataCell(TextField(
                                        controller: TextEditingController(
                                            text: room.chargesPerNight
                                                .toString()))),
                                  ]);
                                }).toList(),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: button2()),
                                    onPressed: addRoom,
                                    child: const Text('Add Room',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold))),
                                const SizedBox(
                                  width: 15,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Hotel Menu:",
                              style: TextStyle(
                                  color: button1(),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                            SingleChildScrollView(
                              padding: EdgeInsets.only(left: 20),
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                dataRowMinHeight: 2,
                                headingTextStyle: const TextStyle(
                                    fontSize: 19, fontWeight: FontWeight.bold),
                                border: TableBorder.all(
                                    width: 2,
                                    color: Colors.black,
                                    style: BorderStyle.solid,
                                    borderRadius: BorderRadius.circular(5)),
                                columns: const [
                                  DataColumn(label: Text('Dish Name')),
                                  DataColumn(label: Text('Price (PKR)')),
                                ],
                                rows: dishList.map((dish) {
                                  return DataRow(cells: [
                                    DataCell(TextField(
                                        controller: TextEditingController(
                                            text: dish.dishName))),
                                    DataCell(TextField(
                                        controller: TextEditingController(
                                            text: dish.price.toString()))),
                                  ]);
                                }).toList(),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: button2()),
                                    onPressed: addDish,
                                    child: const Text('Add Dish',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold))),
                                const SizedBox(
                                  width: 15,
                                ),
                              ],
                            ),
                          ],
                        )),
                        Scaffold(
                          body: ListView.builder(
                            itemCount: bookingRequests.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                elevation: 5,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          'Check in Date: ${bookingRequests[index].checkinDate}'),
                                      Text(
                                          'Rooms Required: ${bookingRequests[index].roomsRequired}'),
                                      Text(
                                          'Customer Contact: ${bookingRequests[index].customerContact}'),
                                      Text(
                                          'Room Type: ${bookingRequests[index].roomType}"]}'),
                                      SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              setState(() {
                                                acceptedRequests.add(
                                                    bookingRequests[index]);
                                                bookingRequests.remove(
                                                    bookingRequests[index]);
                                              });
                                            },
                                            child: Text('Accept'),
                                          ),
                                          SizedBox(width: 10),
                                          TextButton(
                                            onPressed: () {},
                                            child: Text('Decline'),
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
                                margin: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          'Check in Date: ${acceptedRequests[index].checkinDate}'),
                                      Text(
                                          'Rooms Required: ${acceptedRequests[index].roomsRequired}'),
                                      Text(
                                          'Customer Contact: ${acceptedRequests[index].customerContact}'),
                                      Text(
                                          'Room Type: ${acceptedRequests[index].roomType}"]}'),
                                      SizedBox(height: 10),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
