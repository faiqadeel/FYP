// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app/components/dialogBox.dart';
import 'package:my_app/components/textFieldComponent.dart';

import '../../components/Colors.dart';

class TransportOwner extends StatefulWidget {
  final String provider_id;
  const TransportOwner({super.key, required this.provider_id});

  @override
  State<TransportOwner> createState() => _TransportOwnerState();
}

class Vehicle {
  final String vehicleName;
  final String chargesPerDay;
  final String seatCapacity;
  final String photoURL;

  Vehicle(
      {required this.vehicleName,
      required this.chargesPerDay,
      required this.seatCapacity,
      required this.photoURL});
}

class BookingRequests {
  String pickpLocation;
  String pickupDate;
  String vehicleName;
  String customerContact;

  BookingRequests(
      {required this.pickpLocation,
      required this.customerContact,
      required this.vehicleName,
      required this.pickupDate});
}

class _TransportOwnerState extends State<TransportOwner>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> vehicleDetails = [];
  late TabController _tabController;
  String name = '';
  List<BookingRequests> bookingRequests = [];
  List<BookingRequests> acceptedRequests = [];
  List<Vehicle> vehicleList = [];
// Function to pick an image from the gallery and add vehicle details

  Future<void> _pickImage(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      TextEditingController nameController = TextEditingController();
      TextEditingController seatsController = TextEditingController();
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Upload Vehicle Data'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Vehicle Name'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: seatsController,
                  decoration:
                      const InputDecoration(labelText: 'Number of Seats'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  String name = nameController.text.trim();
                  String seats = seatsController.text.trim();
                  if (name.isNotEmpty && seats.isNotEmpty) {
                    await _uploadImage(name, seats, File(pickedImage.path));
                    Navigator.of(context).pop(); // Close the dialog
                  } else {
                    error_dialogue_box(
                        context, "An error occured while uploading the image");
                  }
                },
                child: const Text('Upload Image'),
              ),
            ],
          );
        },
      );
    }
  }

// Function to upload the image to Firebase Storage with vehicle details and unique identifier
  Future<void> _uploadImage(
    String vehicleName,
    String seats,
    File imageFile,
  ) async {
    String unq = widget.provider_id;
    try {
      String fileName =
          '$unq.$vehicleName.$seats'; // Assuming unique ID is used as the file name
      Reference storageReference =
          FirebaseStorage.instance.ref().child('Transport_Details/$fileName');

      // Upload the image file to Firebase Storage
      await storageReference.putFile(imageFile);

      // Get the download URL for the uploaded image
      String downloadURL = await storageReference.getDownloadURL();
      vehicleDetails.add({
        'Vehicle Name': vehicleName,
        'Seats': seats,
        'url': downloadURL,
      });
    } catch (e) {
      print('Error uploading vehicle details: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchVehicleDetails() async {
    try {
      Reference storageReference =
          FirebaseStorage.instance.ref().child('Transport_Details');

      // List all items in the 'vehicle_details' folder
      ListResult listResult = await storageReference.listAll();

      // Iterate through each item (vehicle detail file) in the folder
      for (Reference item in listResult.items) {
        // Get download URL for the item (vehicle detail file)
        String downloadURL = await item.getDownloadURL();

        // Extract vehicle details from the file name
        String fileName = item.name;
        List<String> parts = fileName.split('.');
        if (parts[0] == widget.provider_id) {
          String name = parts[1];
          String seats = parts[2];
          Map<String, dynamic> vehicleData = {
            'Vehicle Name': name,
            'Seats': seats,
            'url': downloadURL,
          };
          vehicleDetails.add(vehicleData);
          return vehicleDetails;
        }
        // Create a map of vehicle details

        // Add vehicle details to the list
      }
    } catch (e) {
      print('Error fetching vehicle details: $e');
      // return [];
    }
    return vehicleDetails;
  }

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

  Future<List<Vehicle>> getData() async {
    try {
      final CollectionReference transportOwner =
          FirebaseFirestore.instance.collection("Service Providers");
      final QuerySnapshot ownerDocs = await transportOwner
          .where("Phone Number", isEqualTo: widget.provider_id)
          .get();
      final DocumentSnapshot current = ownerDocs.docs.first;
      setState(() {
        name = current['Owner Name'];
      });
      final CollectionReference vehiclesRef =
          transportOwner.doc(current.id).collection("Vehicles");
      final CollectionReference accRef =
          transportOwner.doc(current.id).collection("Accepted Requests");
      final CollectionReference reqRef =
          transportOwner.doc(current.id).collection("Booking Requests");
      QuerySnapshot vehicles = await vehiclesRef.get();
      QuerySnapshot accReq = await accRef.get();
      QuerySnapshot requests = await reqRef.get();
      vehicleList = [];
      for (var room in vehicles.docs) {
        Vehicle newRoom = Vehicle(
            vehicleName: room['Vehicle Name'],
            chargesPerDay: room['Charges Per Day'],
            seatCapacity: room['Seat Capacity'],
            photoURL: "");
        vehicleList.add(newRoom);
      }
      bookingRequests = [];
      for (var request in requests.docs) {
        BookingRequests newRequest = BookingRequests(
          vehicleName: request['Vehicle Name'],
          pickpLocation: request['Pickup Location'],
          customerContact: request['Customer Contact'],
          pickupDate: request['Pickup Date'],
        );
        bookingRequests.add(newRequest);
      }
      acceptedRequests = [];
      for (var request in accReq.docs) {
        BookingRequests newRequest = BookingRequests(
          vehicleName: request['Vehicle Name'],
          pickpLocation: request['Pickup Location'],
          customerContact: request['Customer Contact'],
          pickupDate: request['Pickup Date'],
        );
        acceptedRequests.add(newRequest);
      }
    } catch (e) {
      error_dialogue_box(context, e.toString());
    }
    return vehicleList;
  }

  Future<String> uploadImage() async {
    String url = "";
    try {
      final ImagePicker _imgPicker = ImagePicker();
      XFile? _file = await _imgPicker.pickImage(source: ImageSource.gallery);
      if (_file != null) {
        Uint8List img = await _file.readAsBytes();

        url = await uploadPic(_file);
      } else {
        print("File is null");
      }
    } catch (e) {
      print(e.toString());
    }
    return url;
  }

  Future<String> uploadPic(XFile image) async {
    String downloadurl = "";
    try {
      Uint8List fileBytes = await image.readAsBytes();
      Reference ref = FirebaseStorage.instance
          .ref("Transport_Details")
          .child("${fileBytes[0]}");
      TaskSnapshot task = await ref.putData(fileBytes);
      downloadurl = await task.ref.getDownloadURL();

      CollectionReference myCollection =
          FirebaseFirestore.instance.collection('tourists');
      QuerySnapshot docs =
          await myCollection.where("name", isEqualTo: name).get();
      DocumentReference docRef = myCollection.doc(docs.docs.first.id);
      await docRef.update({"Profile URL": downloadurl});
      success_dialogue_box(context, "Profile Photo Updated Successfully!!");
    } catch (e) {
      error_dialogue_box(context, e.toString());
    }
    return downloadurl;
  }

  void addVehicle() async {
    TextEditingController vehicleName = TextEditingController();
    TextEditingController chargesPerDay = TextEditingController();
    TextEditingController seatCapacity = TextEditingController();
    String photoURL = "";
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Room Details"),
            backgroundColor: dialogueBoxBackground(),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  style: buttonStyle(),
                  onPressed: () async {
                    photoURL = await uploadImage();
                  },
                  child: const Text("Select Vehicle Photo",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: vehicleName,
                  decoration: const InputDecoration(
                    labelText: 'Enter Vehicle Name',
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
                  controller: seatCapacity,
                  decoration: const InputDecoration(
                    labelText: 'Enter Seat capacity of the vehicle',
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
                  controller: chargesPerDay,
                  decoration: const InputDecoration(
                    labelText: 'Enter Charges per Day',
                    labelStyle: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  if (vehicleName.text.isEmpty ||
                      chargesPerDay.text.isEmpty ||
                      seatCapacity.text.isEmpty ||
                      photoURL.isEmpty) {
                    error_dialogue_box(
                        context, "Please fill out all the fields");
                  } else {
                    Vehicle newVehicle = Vehicle(
                        vehicleName: vehicleName.text.trim(),
                        seatCapacity: seatCapacity.text.trim(),
                        chargesPerDay: chargesPerDay.text.trim(),
                        photoURL: photoURL);
                    setState(() {
                      vehicleList.add(newVehicle);
                    });
                    final CollectionReference collRef = FirebaseFirestore
                        .instance
                        .collection("Service Providers");
                    final QuerySnapshot vehicleDocs = await collRef
                        .where("Phone Number", isEqualTo: widget.provider_id)
                        .get();
                    String docId = vehicleDocs.docs.first.id;
                    await collRef.doc(docId).collection("Vehicles").add({
                      'Vehicle Name': newVehicle.vehicleName,
                      'Charges Per Day': newVehicle.chargesPerDay,
                      'Seat Capacity': newVehicle.seatCapacity,
                      "Photo URL": newVehicle.photoURL
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome ${name}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {},
          ),
        ],
      ),
      body: FutureBuilder<List<Vehicle>>(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
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
                    Tab(text: 'My Vehicles'),
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
                          Text(
                            "Vehicles Information:",
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
                                DataColumn(label: Text('Vehicle Name')),
                                DataColumn(label: Text('Charges Per Day')),
                                DataColumn(label: Text('Seat Capacity')),
                              ],
                              rows: vehicleList.map((vehicle) {
                                return DataRow(cells: [
                                  DataCell(TextField(
                                      controller: TextEditingController(
                                          text: vehicle.vehicleName))),
                                  DataCell(TextField(
                                      controller: TextEditingController(
                                          text: vehicle.chargesPerDay))),
                                  DataCell(TextField(
                                      controller: TextEditingController(
                                          text: vehicle.seatCapacity))),
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
                                  onPressed: addVehicle,
                                  child: const Text('Add Vehicle',
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
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        'Vehicle Name: ${bookingRequests[index].vehicleName}"]}'),
                                    Text(
                                        'Pickup Location: ${bookingRequests[index].pickpLocation}'),
                                    Text(
                                        'Pickup Date: ${bookingRequests[index].pickupDate}'),
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
                                              bookingRequests.remove(
                                                  bookingRequests[index]);
                                            });
                                          },
                                          child: const Text('Accept'),
                                        ),
                                        const SizedBox(width: 10),
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              bookingRequests.remove(
                                                  bookingRequests[index]);
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
                                        'Vehicle Name: ${acceptedRequests[index].vehicleName}"]}'),
                                    Text(
                                        'Pickup Location: ${acceptedRequests[index].pickpLocation}'),
                                    Text(
                                        'Pickup Date: ${acceptedRequests[index].pickupDate}'),
                                    Text(
                                        'Customer Contact: ${acceptedRequests[index].customerContact}'),
                                    const SizedBox(height: 10),
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
    );
  }

  Widget _buildVehicleCard(String name, String seats, String imageUrl) {
    return Container(
      height: 120,
      width: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        width: 300,
        height: 200,
      ),
    );
    // SizedBox(height: 8),
    // Row(
    //   children: [
    //     Text('Name: $name'),
    //     SizedBox(
    //       width: 5,
    //     ),
    //     Text('Seats: $seats'),
    //   ],
    // )
  }
}
