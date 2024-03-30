import 'package:flutter/material.dart';

class HotelOwner extends StatefulWidget {
  final String provider_id;
  const HotelOwner({super.key, required this.provider_id});

  @override
  State<HotelOwner> createState() => _HotelOwnerState();
}

class _HotelOwnerState extends State<HotelOwner> {
  List<String> Hotelphotos = [
    'https://img.freepik.com/premium-photo/minsk-belarus-august-2017-columns-guestroom-hall-reception-modern-luxury-hotel_97694-6572.jpg',
    'https://img.freepik.com/premium-photo/minsk-belarus-august-2017-columns-guestroom-hall-reception-modern-luxury-hotel_97694-6572.jpg'
  ]; // Initial photos
  List<String> Menuphotos = [
    'https://img.freepik.com/premium-photo/minsk-belarus-august-2017-columns-guestroom-hall-reception-modern-luxury-hotel_97694-6572.jpg',
    'https://img.freepik.com/premium-photo/minsk-belarus-august-2017-columns-guestroom-hall-reception-modern-luxury-hotel_97694-6572.jpg'
  ]; // Initial photos
  List<Room> rooms = [
    Room(roomNo: '101', type: 'Standard', price: '\$100')
  ]; // Initial rooms

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 10),
        children: [
          // Slider for hotel photos
          Container(
            padding: EdgeInsets.only(bottom: 20),
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: Hotelphotos.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Image.network(
                    Hotelphotos[index],
                    fit: BoxFit.cover,
                    width: 300,
                    height: 200,
                  ),
                );
              },
            ),
          ),
          // Button to add more photos
          ElevatedButton(
            onPressed: () {
              setState(() {
                Hotelphotos.add('new_photo.jpg'); // Add a new photo to the list
              });
            },
            child: Text('Add Photos'),
          ),
          // Slider for rooms information
          Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: rooms.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  margin: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  width: 300,
                  height: 200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Room No: ${rooms[index].roomNo}'),
                      Text('Type: ${rooms[index].type}'),
                      Text('Price: ${rooms[index].price}'),
                    ],
                  ),
                );
              },
            ),
          ),
          // Button to add more rooms
          ElevatedButton(
            onPressed: () {
              setState(() {
                rooms.add(Room(
                    roomNo: '102',
                    type: 'Deluxe',
                    price: '\$150')); // Add a new room to the list
              });
            },
            child: Text('Add Room'),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: Menuphotos.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Image.network(
                    Menuphotos[index],
                    fit: BoxFit.cover,
                    width: 300,
                    height: 200,
                  ),
                );
              },
            ),
          ),
          // Button to add more photos
          ElevatedButton(
            onPressed: () {
              setState(() {
                Menuphotos.add('new_photo.jpg'); // Add a new photo to the list
              });
            },
            child: Text('Add Photos'),
          ),
        ],
      ),
    );
  }
}

class Room {
  final String roomNo;
  final String type;
  final String price;

  Room({required this.roomNo, required this.type, required this.price});
}
