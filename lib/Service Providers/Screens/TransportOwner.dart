// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app/components/dialogBox.dart';

class TransportOwner extends StatefulWidget {
  final String provider_id;
  const TransportOwner({super.key, required this.provider_id});

  @override
  State<TransportOwner> createState() => _TransportOwnerState();
}

class _TransportOwnerState extends State<TransportOwner> {
  List<Map<String, dynamic>> vehicleDetails = [];
// Function to pick an image from the gallery and add vehicle details
  Future<void> _pickImage(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      // Show alert dialog to enter vehicle details
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
                    Navigator.of(context).pop(); // Close the dialog
                    await _uploadImage(name, seats, File(pickedImage.path));
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

  // @override
  // void initState() {
  //   super.initState();
  //   // fetchVehicleDetails();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Welcome'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {},
            ),
          ],
        ),
        body: FutureBuilder<List<Map<String, dynamic>>>(
            future: fetchVehicleDetails(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // While waiting for data, show a loading indicator
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                // If an error occurred while fetching data, show an error message
                return Center(child: Text('Error fetching data'));
              } else {
                return ListView(
                  padding: const EdgeInsets.all(8.0),
                  children: [
                    Container(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: vehicleDetails.length,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Image.network(
                              vehicleDetails[index]['url'],
                              fit: BoxFit.cover,
                              width: 300,
                              height: 200,
                            ),
                          );
                          // _buildVehicleCard(
                          //     vehicleDetails[index]["Vehicle Name"],
                          //     vehicleDetails[index]["Seats"],
                          //     vehicleDetails[index]["url"]);
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        fetchVehicleDetails();
                      },
                      child: const Text('Add Vehicles'),
                    ),
                  ],
                );
              }
            }));
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
