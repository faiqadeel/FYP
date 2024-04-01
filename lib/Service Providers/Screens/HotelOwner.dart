// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  int capacity;
  double chargesPerNight;

  Room({
    required this.roomNo,
    required this.roomType,
    required this.occupied,
    required this.capacity,
    required this.chargesPerNight,
  });
}

class DishData {
  String dishName;
  double price;

  DishData({
    required this.dishName,
    required this.price,
  });
}

class _HotelOwnerState extends State<HotelOwner>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<Room> roomList = [
    Room(
        roomNo: '101',
        roomType: 'Standard',
        occupied: false,
        capacity: 2,
        chargesPerNight: 100),
    Room(
        roomNo: '110',
        roomType: 'Deluxe',
        occupied: true,
        capacity: 4,
        chargesPerNight: 5000), // Add more room data as needed
  ];

  final List<Map<String, dynamic>> dishList = [
    {'dishName': 'Pizza', 'price': '10'},
    {'dishName': 'Burger', 'price': '8'},
    // Add more dish data as needed
  ];

  void addRoom() {
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
                onPressed: () {
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
                        capacity: int.parse(capacity.text.trim()),
                        chargesPerNight:
                            double.parse(chargesPerNight.text.trim()),
                        occupied: false);
                    setState(() {
                      roomList.add(newRoom);
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
    dishList.add({'dishName': '', 'price': ''});
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<String> Hotelphotos = [
    'https://img.freepik.com/premium-photo/minsk-belarus-august-2017-columns-guestroom-hall-reception-modern-luxury-hotel_97694-6572.jpg',
    'https://img.freepik.com/premium-photo/minsk-belarus-august-2017-columns-guestroom-hall-reception-modern-luxury-hotel_97694-6572.jpg'
  ]; // Initial photos
  List<String> Menuphotos = [
    'https://img.freepik.com/premium-photo/minsk-belarus-august-2017-columns-guestroom-hall-reception-modern-luxury-hotel_97694-6572.jpg',
    'https://img.freepik.com/premium-photo/minsk-belarus-august-2017-columns-guestroom-hall-reception-modern-luxury-hotel_97694-6572.jpg'
  ];
  // final CollectionReference hotelOwner =
  //     FirebaseFirestore.instance.collection("Service Providers");
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text("Welcome, GrandHotel", style: AppBarTextStyle()),
            backgroundColor: AppBarBackground(),
            actions: const [
              CircleAvatar(
                backgroundImage: NetworkImage(
                    'data:image/jpeg;base64,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'),
              ),
              SizedBox(width: 16.0),
            ],
          ),
          body:
              // FutureBuilder<QuerySnapshot>(
              //     future: hotelOwner
              //         .where("Phone Number", isEqualTo: widget.provider_id)
              //         .get(),
              //     builder: (context, snapshot) {
              //       if (snapshot.connectionState == ConnectionState.waiting) {
              //         return const Center(
              //           child: CircularProgressIndicator(),
              //         );
              //       }
              //       DocumentSnapshot currentInstance = snapshot.data!.docs.first;
              Column(
            children: [
              TabBar(
                labelColor: CardBackground(),
                labelStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelColor: button1(),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                indicatorColor: button2(),
                controller: _tabController,
                tabs: const [
                  Tab(text: 'My Hotel'),
                  Tab(text: 'My Bookings'),
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
                        Text(
                          "Rooms Information:",
                          style: TextStyle(
                              color: button1(),
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
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
                                        text:
                                            room.chargesPerNight.toString()))),
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
                                        text: dish['dishName']))),
                                DataCell(TextField(
                                    controller: TextEditingController(
                                        text: dish['price']))),
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
                      appBar: AppBar(
                        title: const Text('Second Page'),
                      ),
                      body: const Center(
                        child: Text('Second Page Content'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
          // }),
          ),
    );
  }
}
