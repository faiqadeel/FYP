// import 'package:flutter/material.dart';

// class scrollableGridExample extends StatefulWidget {
//   @override
//   _scrollableGridExampleState createState() => _scrollableGridExampleState();
// }

// class _scrollableGridExampleState extends State<scrollableGridExample> {
//   // List of controllers for the vertical scrolls
//   List<ScrollController> _verticalControllers = [];

//   // Horizontal scroll controller
//   ScrollController _horizontalController = ScrollController();

//   @override
//   void initState() {
//     super.initState();
//     // Initialize the vertical controllers
//     for (int i = 0; i < 10; i++) {
//       _verticalControllers.add(ScrollController());
//     }
//   }

//   @override
//   void dispose() {
//     // Dispose all controllers
//     _horizontalController.dispose();
//     for (var controller in _verticalControllers) {
//       controller.dispose();
//     }
//     super.dispose();
//   }

//   Widget _buildHorizontalRow(int index) {
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       controller: _horizontalController,
//       child: Row(
//         children:
//             List.generate(10, (columnIndex) => _buildCell(index, columnIndex)),
//       ),
//     );
//   }

//   Widget _buildCell(int rowIndex, int columnIndex) {
//     return Container(
//       alignment: Alignment.center,
//       width: 120,
//       height: 100,
//       color: Colors.blue[(columnIndex % 9 + 1) * 100],
//       child: Text('R$rowIndex C$columnIndex'),
//     );
//   }

//   // @override
//   // Widget build(BuildContext context) {
//   //   return Scaffold(
//   //       appBar: AppBar(
//   //         title: Text("2D Scrollable Grid"),
//   //       ),
//   //       body: TwoDimensionalScrollable(
//   //           horizontalDetails:
//   //               ScrollableDetails(direction: AxisDirection.right),
//   //           verticalDetails: ScrollableDetails(direction: AxisDirection.down),
//   //           viewportBuilder: viewportBuilder)
//         // SingleChildScrollView(
//         //   child: Column(
//         //     children: List.generate(10, (rowIndex) {
//         //       return SingleChildScrollView(
//         //         scrollDirection: Axis.vertical,
//         //         controller: _verticalControllers[rowIndex],
//         //         child: SizedBox(
//         //           height: 100,
//         //           child: _buildHorizontalRow(rowIndex),
//         //         ),
//         //       );
//         //     }),
//         //   ),
//         // ),
//         );
// }


// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:flutter/material.dart';

// // class Testing extends StatelessWidget {
// //   const Testing({super.key});

// //   void func() async {
// //     final CollectionReference touristsCollection =
// //         FirebaseFirestore.instance.collection('tourists');
// //     try {
// //       QuerySnapshot qsnapshot =
// //           await touristsCollection.where('name', isEqualTo: "shahriyar").get();
// //       QueryDocumentSnapshot document = qsnapshot.docs[0];
// //     } catch (e) {
// //       print("couldnot");
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //         backgroundColor: Color.fromRGBO(186, 24, 27, 1),
// //         body: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             ElevatedButton(onPressed: func, child: Text("None")),
// //             Text(
// //               '•',
// //               style: TextStyle(fontSize: 30), // Adjust the font size as needed
// //             ),
// //             Text(
// //               '•',
// //               style: TextStyle(fontSize: 30), // Adjust the font size as needed
// //             ),
// //             Text(
// //               '•',
// //               style: TextStyle(fontSize: 30), // Adjust the font size as needed
// //             ),
// //           ],
// //         ));
// //   }

// //   // Column(children: [
// //   //   Padding(
// //   //     padding: const EdgeInsets.only(right: 0, left: 0, top: 10, bottom: 0),
// //   //     child: Column(
// //   //       children: [
// //   // Padding(
// //   //   padding: const EdgeInsets.only(
// //   //       top: 10, left: 0, right: 10, bottom: 20),
// //   //   child: ElevatedButton(
// //   //     style: ElevatedButton.styleFrom(
// //   //         disabledBackgroundColor:
// //   //             const Color.fromRGBO(141, 8, 1, 1.0),
// //   //         shape: RoundedRectangleBorder(
// //   //           borderRadius: BorderRadius.circular(5.0),
// //   //         ),
// //   //         fixedSize: const Size(400, 80)),
// //   //     onPressed: null,
// //   //     child: Row(
// //   //       mainAxisAlignment: MainAxisAlignment.start,
// //   //       children: [
// //   //         const Text(
// //   //           "Hello",
// //   //           style: TextStyle(
// //   //             color: Color.fromRGBO(255, 166, 0, 1),
// //   //             fontWeight: FontWeight.bold,
// //   //             fontSize: 25,
// //   //           ),
// //   //         ),
// //   //         MaterialButton(
// //   //           onPressed: () async {},
// //   //           padding: const EdgeInsets.only(left: 70),
// //   //           child: const CircleAvatar(
// //   //             radius: 36,
// //   //             backgroundColor: Colors.white,
// //   //           ),
// //   //         )
// //   //       ],
// //   //     ),
// //   //   ),
// //   // ),
// //   // Padding(
// //   //   padding:
// //   //       const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
// //   //   child: TextFormField(
// //   //       decoration: const InputDecoration(
// //   //           prefixIcon: Icon(
// //   //             Icons.search,
// //   //             size: 25,
// //   //             color: Color.fromRGBO(0, 0, 0, 1),
// //   //           ),
// //   //           disabledBorder: OutlineInputBorder(
// //   //               borderSide: BorderSide.none,
// //   //               borderRadius:
// //   //                   BorderRadius.all(Radius.circular(10))),
// //   //           enabledBorder: OutlineInputBorder(
// //   //               borderSide: BorderSide.none,
// //   //               borderRadius:
// //   //                   BorderRadius.all(Radius.circular(10))),
// //   //           labelText: 'Search country,city or any place',
// //   //           labelStyle: TextStyle(
// //   //             color: Color.fromRGBO(0, 0, 0, 1),
// //   //             fontSize: 14,
// //   //             fontStyle: FontStyle.italic,
// //   //           ),
// //   //           border: OutlineInputBorder(),
// //   //           filled: true,
// //   //           fillColor: Color.fromRGBO(244, 213, 141, 1))),
// //   // )

// //   // Padding(
// //   //   padding: const EdgeInsets.only(top: 10, right: 20, left: 20),
// //   //   child: Column(
// //   //     mainAxisAlignment: MainAxisAlignment.start,
// //   //     crossAxisAlignment: CrossAxisAlignment.center,
// //   //     children: [
// //   //       Row(
// //   //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //   //         children: [
// //   //           Padding(
// //   //             padding: const EdgeInsets.only(left: 30, top: 10),
// //   //             child: ElevatedButton(
// //   //               onPressed: () {},
// //   //               style: ElevatedButton.styleFrom(
// //   //                 fixedSize: const Size(130, 120),
// //   //                 shape: RoundedRectangleBorder(
// //   //                   borderRadius: BorderRadius.circular(12.0),
// //   //                 ),
// //   //                 padding: const EdgeInsets.all(16.0),
// //   //                 backgroundColor: const Color.fromRGBO(229, 56, 59,
// //   //                     1), // Change the button color as needed
// //   //               ),
// //   //               child: const Column(
// //   //                 mainAxisAlignment: MainAxisAlignment.center,
// //   //                 children: [
// //   //                   Icon(
// //   //                     Icons
// //   //                         .home_outlined, // Replace this with the desired icon
// //   //                     size: 50.0,
// //   //                     color:
// //   //                         Colors.white, // Change the icon color as needed
// //   //                   ),
// //   //                   SizedBox(height: 8.0),
// //   //                   Text(
// //   //                     'Hotels',
// //   //                     style: TextStyle(
// //   //                       fontSize: 24.0,
// //   //                       color: Colors
// //   //                           .white, // Change the text color as needed
// //   //                     ),
// //   //                   ),
// //   //                 ],
// //   //               ),
// //   //             ),
// //   //           ),
// //   //           Padding(
// //   //             padding: const EdgeInsets.only(top: 10, right: 10),
// //   //             child: ElevatedButton(
// //   //               onPressed: () {},
// //   //               style: ElevatedButton.styleFrom(
// //   //                 fixedSize: const Size(130, 120),
// //   //                 shape: RoundedRectangleBorder(
// //   //                   borderRadius: BorderRadius.circular(12.0),
// //   //                 ),
// //   //                 padding: const EdgeInsets.all(16.0),
// //   //                 backgroundColor: const Color.fromRGBO(229, 56, 59,
// //   //                     1), // Change the button color as needed
// //   //               ),
// //   //               child: const Column(
// //   //                 mainAxisAlignment: MainAxisAlignment.center,
// //   //                 children: [
// //   //                   Icon(
// //   //                     Icons.car_rental_outlined,
// //   //                     size: 50.0,
// //   //                     color:
// //   //                         Colors.white, // Change the icon color as needed
// //   //                   ),
// //   //                   SizedBox(height: 8.0),
// //   //                   Text(
// //   //                     'Transport',
// //   //                     style: TextStyle(
// //   //                       fontSize: 19.0,
// //   //                       color: Colors
// //   //                           .white, // Change the text color as needed
// //   //                     ),
// //   //                   ),
// //   //                 ],
// //   //               ),
// //   //             ),
// //   //           ),
// //   //         ],
// //   //       ),
// //   //       const SizedBox(width: 100, height: 30),
// //   //       ElevatedButton(
// //   //         onPressed: () {},
// //   //         style: ElevatedButton.styleFrom(
// //   //           fixedSize: const Size(180, 100),
// //   //           shape: RoundedRectangleBorder(
// //   //             borderRadius: BorderRadius.circular(12.0),
// //   //           ),
// //   //           padding: const EdgeInsets.all(16.0),
// //   //           backgroundColor: const Color.fromRGBO(
// //   //               229, 56, 59, 1), // Change the button color as needed
// //   //         ),
// //   //         child: const Column(
// //   //           mainAxisAlignment: MainAxisAlignment.center,
// //   //           crossAxisAlignment: CrossAxisAlignment.center,
// //   //           children: [
// //   //             Icon(
// //   //               Icons.tour_outlined,
// //   //               size: 50.0,
// //   //               color: Colors.white, // Change the icon color as needed
// //   //             ),
// //   //             SizedBox(height: 2.0),
// //   //             Text(
// //   //               'Local Guides',
// //   //               style: TextStyle(
// //   //                 fontSize: 22.0,
// //   //                 color: Colors.white, // Change the text color as needed
// //   //               ),
// //   //             ),
// //   //           ],
// //   //         ),
// //   //       ),
// //   //     ],
// //   //   ),
// //   // ),
// //   // const Padding(
// //   //   padding: EdgeInsets.only(left: 10, right: 10, top: 10),
// //   //   child: Column(
// //   //     children: [
// //   //       Text("Popular Places",
// //   //           style: TextStyle(color: Colors.black, fontSize: 20)),
// //   //       SizedBox(
// //   //         width: 250,
// //   //         height: 150,
// //   //       ),
// //   //     ],
// //   //   ),
// //   // ),
// //   // const SizedBox(height: 460, width: 100),
// //   // Container(
// //   //   padding: const EdgeInsets.only(top: 100, bottom: 1),
// //   //   color: const Color.fromRGBO(2, 43, 58, 1),
// //   //   height: 80,
// //   //   child: Row(
// //   //     crossAxisAlignment: CrossAxisAlignment.center,
// //   //     mainAxisAlignment: MainAxisAlignment.center,
// //   //     children: [
// //   //       ElevatedButton(
// //   //           onPressed: () {},
// //   //           child: Text(
// //   //             "Home",
// //   //           ))
// //   //     ],
// //   //   ),
// //   // )

// // // body: Column(
// // //   crossAxisAlignment: CrossAxisAlignment.center,
// // //   children: [
// // //     const SizedBox(width: 400, height: 30),
// // //     const CircleAvatar(
// // //       radius: 46,
// // //       backgroundColor: Colors.grey,
// // //     ),
// // //     const SizedBox(width: 400, height: 10),
// // //     Padding(
// // //       padding: const EdgeInsets.all(8.0),
// // //       child: Row(
// // //         mainAxisAlignment: MainAxisAlignment.center,
// // //         children: [
// // //           const Text(
// // //             "FAIQ",
// // //             style: TextStyle(
// // //                 fontSize: 24, color: Color.fromRGBO(48, 55, 72, 1.0)),
// // //           ),
// // //           IconButton(
// // //               onPressed: () {},
// // //               icon: const Icon(
// // //                 Icons.edit,
// // //                 color: Colors.black,
// // //               ))
// // //         ],
// // //       ),
// // //     ),
// // //     const SizedBox(width: 400, height: 15),
// // //     TextButton.icon(
// // //         style: ButtonStyle(
// // //           alignment: Alignment.centerLeft,
// // //           fixedSize:
// // //               MaterialStateProperty.all<Size>(const Size(300, 50.0)),
// // //           backgroundColor:
// // //               MaterialStateProperty.all<Color>(Colors.transparent),
// // //           shape: MaterialStateProperty.all<OutlinedBorder>(
// // //             RoundedRectangleBorder(
// // //               borderRadius: BorderRadius.circular(
// // //                   10.0), // Adjust the radius as needed
// // //               side: const BorderSide(
// // //                   color: Color.fromRGBO(
// // //                       48, 55, 72, 1.00)), // Set the border color
// // //             ),
// // //           ),
// // //         ),
// // //         onPressed: () {},
// // //         icon: const Icon(
// // //           Icons.email,
// // //           color: Colors.black,
// // //           size: 33,
// // //         ),
// // //         label: const Text("Email",
// // //             style: TextStyle(
// // //                 color: Color.fromRGBO(48, 55, 72, 1.0),
// // //                 fontSize: 20,
// // //                 overflow: TextOverflow.clip))),
// // //     const SizedBox(width: 400, height: 15),
// // //     TextButton.icon(
// // //         style: ButtonStyle(
// // //           alignment: Alignment.centerLeft,
// // //           fixedSize:
// // //               MaterialStateProperty.all<Size>(const Size(300, 50.0)),
// // //           backgroundColor:
// // //               MaterialStateProperty.all<Color>(Colors.transparent),
// // //           shape: MaterialStateProperty.all<OutlinedBorder>(
// // //             RoundedRectangleBorder(
// // //               borderRadius: BorderRadius.circular(
// // //                   10.0), // Adjust the radius as needed
// // //               side: const BorderSide(
// // //                   color: Color.fromRGBO(
// // //                       48, 55, 72, 1.00)), // Set the border color
// // //             ),
// // //           ),
// // //         ),
// // //         onPressed: () {},
// // //         icon: const Icon(
// // //           Icons.phone,
// // //           color: Colors.black,
// // //           size: 33,
// // //         ),
// // //         label: const Text("Phone",
// // //             style: TextStyle(
// // //                 color: Color.fromRGBO(48, 55, 72, 1.0),
// // //                 fontSize: 20,
// // //                 overflow: TextOverflow.clip))),
// // //     const SizedBox(width: 400, height: 15),
// // //     TextButton.icon(
// // //         style: ButtonStyle(
// // //           alignment: Alignment.centerLeft,
// // //           fixedSize:
// // //               MaterialStateProperty.all<Size>(const Size(300, 50.0)),
// // //           backgroundColor:
// // //               MaterialStateProperty.all<Color>(Colors.transparent),
// // //           shape: MaterialStateProperty.all<OutlinedBorder>(
// // //             RoundedRectangleBorder(
// // //               borderRadius: BorderRadius.circular(
// // //                   10.0), // Adjust the radius as needed
// // //               side: const BorderSide(
// // //                   color: Color.fromRGBO(
// // //                       48, 55, 72, 1.00)), // Set the border color
// // //             ),
// // //           ),
// // //         ),
// // //         onPressed: () {},
// // //         icon: const Icon(
// // //           Icons.pending_actions_outlined,
// // //           color: Colors.black,
// // //           size: 33,
// // //         ),
// // //         label: const Text("My Trips",
// // //             style: TextStyle(
// // //                 color: Color.fromRGBO(48, 55, 72, 1.0),
// // //                 fontSize: 20,
// // //                 overflow: TextOverflow.clip))),
// // //     const SizedBox(width: 400, height: 15),
// // //     TextButton.icon(
// // //         style: ButtonStyle(
// // //           alignment: Alignment.centerLeft,
// // //           fixedSize:
// // //               MaterialStateProperty.all<Size>(const Size(300, 50.0)),
// // //           backgroundColor:
// // //               MaterialStateProperty.all<Color>(Colors.transparent),
// // //           shape: MaterialStateProperty.all<OutlinedBorder>(
// // //             RoundedRectangleBorder(
// // //               borderRadius: BorderRadius.circular(
// // //                   10.0), // Adjust the radius as needed
// // //               side: const BorderSide(
// // //                   color: Color.fromRGBO(
// // //                       48, 55, 72, 1.00)), // Set the border color
// // //             ),
// // //           ),
// // //         ),
// // //         onPressed: () {},
// // //         icon: const Icon(
// // //           Icons.payment_rounded,
// // //           color: Colors.black,
// // //           size: 33,
// // //         ),
// // //         label: const Text("Payments",
// // //             style: TextStyle(
// // //                 color: Color.fromRGBO(48, 55, 72, 1.0),
// // //                 fontSize: 20,
// // //                 overflow: TextOverflow.clip))),
// // //     const SizedBox(width: 400, height: 15),
// // //     TextButton.icon(
// // //         style: ButtonStyle(
// // //           alignment: Alignment.centerLeft,
// // //           fixedSize:
// // //               MaterialStateProperty.all<Size>(const Size(300, 50.0)),
// // //           backgroundColor:
// // //               MaterialStateProperty.all<Color>(Colors.transparent),
// // //           shape: MaterialStateProperty.all<OutlinedBorder>(
// // //             RoundedRectangleBorder(
// // //               borderRadius: BorderRadius.circular(
// // //                   10.0), // Adjust the radius as needed
// // //               side: const BorderSide(
// // //                   color: Color.fromRGBO(
// // //                       48, 55, 72, 1.00)), // Set the border color
// // //             ),
// // //           ),
// // //         ),
// // //         onPressed: () {},
// // //         icon: const Icon(
// // //           Icons.book_online_outlined,
// // //           color: Colors.black,
// // //           size: 33,
// // //         ),
// // //         label: const Text("My Bookings",
// // //             style: TextStyle(
// // //                 color: Color.fromRGBO(48, 55, 72, 1.0),
// // //                 fontSize: 20,
// // //                 overflow: TextOverflow.clip))),
// // //     const SizedBox(width: 400, height: 15),
// // //     TextButton.icon(
// // //         style: ButtonStyle(
// // //           alignment: Alignment.centerLeft,
// // //           fixedSize:
// // //               MaterialStateProperty.all<Size>(const Size(300, 50.0)),
// // //           backgroundColor:
// // //               MaterialStateProperty.all<Color>(Colors.transparent),
// // //           shape: MaterialStateProperty.all<OutlinedBorder>(
// // //             RoundedRectangleBorder(
// // //               borderRadius: BorderRadius.circular(
// // //                   10.0), // Adjust the radius as needed
// // //               side: const BorderSide(
// // //                   color: Color.fromRGBO(
// // //                       48, 55, 72, 1.00)), // Set the border color
// // //             ),
// // //           ),
// // //         ),
// // //         onPressed: () {},
// // //         icon: const Icon(
// // //           Icons.monochrome_photos_outlined,
// // //           color: Colors.black,
// // //           size: 33,
// // //         ),
// // //         label: const Text("Posts",
// // //             style: TextStyle(
// // //                 color: Color.fromRGBO(48, 55, 72, 1.0),
// // //                 fontSize: 20,
// // //                 overflow: TextOverflow.clip))),
// // //     const SizedBox(width: 400, height: 15),
// // //     TextButton.icon(
// // //         style: ButtonStyle(
// // //           alignment: Alignment.centerLeft,
// // //           fixedSize:
// // //               MaterialStateProperty.all<Size>(const Size(300, 50.0)),
// // //           backgroundColor:
// // //               MaterialStateProperty.all<Color>(Colors.transparent),
// // //           shape: MaterialStateProperty.all<OutlinedBorder>(
// // //             RoundedRectangleBorder(
// // //               borderRadius: BorderRadius.circular(
// // //                   10.0), // Adjust the radius as needed
// // //               side: const BorderSide(
// // //                   color: Color.fromRGBO(
// // //                       48, 55, 72, 1.00)), // Set the border color
// // //             ),
// // //           ),
// // //         ),
// // //         onPressed: () {
// // //           Navigator.popUntil(context, (route) => route.isFirst);
// // //           Navigator.pushReplacement(context,
// // //               MaterialPageRoute(builder: (context) => const LoginPage()));
// // //         },
// // //         icon: const Icon(
// // //           Icons.logout,
// // //           color: Colors.black,
// // //           size: 33,
// // //         ),
// // //         label: const Text("Logout",
// // //             style: TextStyle(
// // //                 color: Color.fromRGBO(48, 55, 72, 1.0),
// // //                 fontSize: 20,
// // //                 overflow: TextOverflow.clip))),
// // //   ],
// // // ),

// // //  Tripss
// // // backgroundColor: Color.fromARGB(255, 235, 239, 250),
// // // appBar: AppBar(
// // //   backgroundColor: const Color.fromARGB(255, 235, 239, 250),
// // //   centerTitle: true,
// // //   title: const Text(
// // //     "Create New Trip",
// // //     style: TextStyle(
// // //         color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
// // //   ),
// // // )
// // }
