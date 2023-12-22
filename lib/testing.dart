import 'package:flutter/material.dart';
import 'package:my_app/components/textFieldComponent.dart';

class Testing extends StatelessWidget {
  const Testing({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 235, 239, 250),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 235, 239, 250),
        centerTitle: true,
        title: const Text(
          "Create New Trip",
          style: TextStyle(
              color: Colors.black, fontSize: 28, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Trip name",
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
            TextField(
              decoration: tripTextfielddecor("E.g Summer Trip"),
            ),
            const SizedBox(width: 100, height: 20),
            const Text(
              "Destination",
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
            TextField(
              decoration: tripTextfielddecor("E.g Islamabad, Lahore"),
            ),
            const SizedBox(width: 100, height: 20),
            const Text(
              "Add a Stop",
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
            TextField(
              decoration: tripTextfielddecor("E.g Lunch at abc.."),
            ),
            const SizedBox(width: 100, height: 20),
            const Text(
              "Select Departure Date",
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
            ElevatedButton(
                style: ButtonStyle(
                  fixedSize:
                      MaterialStateProperty.all<Size>(const Size(455, 50.0)),
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromRGBO(16, 136, 174, 1.0)),
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
                onPressed: () async {
                  DateTime? datePicker = await showDatePicker(
                      context: context,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2024),
                      initialDate: DateTime.now());
                  print(datePicker.toString());
                },
                child: const Text(
                  "Select Date",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                  ),
                )),
            const SizedBox(width: 100, height: 20),
            TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add,
                    color: Color.fromRGBO(16, 136, 174, 1.0)),
                label: const Text(
                  "Add Travel Partners",
                  style: TextStyle(
                      color: Color.fromRGBO(16, 136, 174, 1.0), fontSize: 20),
                )),
            const SizedBox(width: 100, height: 20),
            const Text(
              "You can edit locations,dates and travel partners in the trip plan later",
              style: TextStyle(
                color: Colors.black54,
                overflow: TextOverflow.visible,
                fontSize: 18,
              ),
            ),
            const SizedBox(width: 100, height: 5),
            ElevatedButton(
                style: ButtonStyle(
                  fixedSize:
                      MaterialStateProperty.all<Size>(const Size(455, 50.0)),
                  backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromRGBO(16, 136, 174, 1.0)),
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
                child: const Text(
                  "Create Trip",
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ))
          ],
        ),
      ),
    );
  }
}

      // body: Column(
      //   crossAxisAlignment: CrossAxisAlignment.center,
      //   children: [
      //     const SizedBox(width: 400, height: 30),
      //     const CircleAvatar(
      //       radius: 46,
      //       backgroundColor: Colors.grey,
      //     ),
      //     const SizedBox(width: 400, height: 10),
      //     Padding(
      //       padding: const EdgeInsets.all(8.0),
      //       child: Row(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         children: [
      //           const Text(
      //             "FAIQ",
      //             style: TextStyle(
      //                 fontSize: 24, color: Color.fromRGBO(48, 55, 72, 1.0)),
      //           ),
      //           IconButton(
      //               onPressed: () {},
      //               icon: const Icon(
      //                 Icons.edit,
      //                 color: Colors.black,
      //               ))
      //         ],
      //       ),
      //     ),
      //     const SizedBox(width: 400, height: 15),
      //     TextButton.icon(
      //         style: ButtonStyle(
      //           alignment: Alignment.centerLeft,
      //           fixedSize:
      //               MaterialStateProperty.all<Size>(const Size(300, 50.0)),
      //           backgroundColor:
      //               MaterialStateProperty.all<Color>(Colors.transparent),
      //           shape: MaterialStateProperty.all<OutlinedBorder>(
      //             RoundedRectangleBorder(
      //               borderRadius: BorderRadius.circular(
      //                   10.0), // Adjust the radius as needed
      //               side: const BorderSide(
      //                   color: Color.fromRGBO(
      //                       48, 55, 72, 1.00)), // Set the border color
      //             ),
      //           ),
      //         ),
      //         onPressed: () {},
      //         icon: const Icon(
      //           Icons.email,
      //           color: Colors.black,
      //           size: 33,
      //         ),
      //         label: const Text("Email",
      //             style: TextStyle(
      //                 color: Color.fromRGBO(48, 55, 72, 1.0),
      //                 fontSize: 20,
      //                 overflow: TextOverflow.clip))),
      //     const SizedBox(width: 400, height: 15),
      //     TextButton.icon(
      //         style: ButtonStyle(
      //           alignment: Alignment.centerLeft,
      //           fixedSize:
      //               MaterialStateProperty.all<Size>(const Size(300, 50.0)),
      //           backgroundColor:
      //               MaterialStateProperty.all<Color>(Colors.transparent),
      //           shape: MaterialStateProperty.all<OutlinedBorder>(
      //             RoundedRectangleBorder(
      //               borderRadius: BorderRadius.circular(
      //                   10.0), // Adjust the radius as needed
      //               side: const BorderSide(
      //                   color: Color.fromRGBO(
      //                       48, 55, 72, 1.00)), // Set the border color
      //             ),
      //           ),
      //         ),
      //         onPressed: () {},
      //         icon: const Icon(
      //           Icons.phone,
      //           color: Colors.black,
      //           size: 33,
      //         ),
      //         label: const Text("Phone",
      //             style: TextStyle(
      //                 color: Color.fromRGBO(48, 55, 72, 1.0),
      //                 fontSize: 20,
      //                 overflow: TextOverflow.clip))),
      //     const SizedBox(width: 400, height: 15),
      //     TextButton.icon(
      //         style: ButtonStyle(
      //           alignment: Alignment.centerLeft,
      //           fixedSize:
      //               MaterialStateProperty.all<Size>(const Size(300, 50.0)),
      //           backgroundColor:
      //               MaterialStateProperty.all<Color>(Colors.transparent),
      //           shape: MaterialStateProperty.all<OutlinedBorder>(
      //             RoundedRectangleBorder(
      //               borderRadius: BorderRadius.circular(
      //                   10.0), // Adjust the radius as needed
      //               side: const BorderSide(
      //                   color: Color.fromRGBO(
      //                       48, 55, 72, 1.00)), // Set the border color
      //             ),
      //           ),
      //         ),
      //         onPressed: () {},
      //         icon: const Icon(
      //           Icons.pending_actions_outlined,
      //           color: Colors.black,
      //           size: 33,
      //         ),
      //         label: const Text("My Trips",
      //             style: TextStyle(
      //                 color: Color.fromRGBO(48, 55, 72, 1.0),
      //                 fontSize: 20,
      //                 overflow: TextOverflow.clip))),
      //     const SizedBox(width: 400, height: 15),
      //     TextButton.icon(
      //         style: ButtonStyle(
      //           alignment: Alignment.centerLeft,
      //           fixedSize:
      //               MaterialStateProperty.all<Size>(const Size(300, 50.0)),
      //           backgroundColor:
      //               MaterialStateProperty.all<Color>(Colors.transparent),
      //           shape: MaterialStateProperty.all<OutlinedBorder>(
      //             RoundedRectangleBorder(
      //               borderRadius: BorderRadius.circular(
      //                   10.0), // Adjust the radius as needed
      //               side: const BorderSide(
      //                   color: Color.fromRGBO(
      //                       48, 55, 72, 1.00)), // Set the border color
      //             ),
      //           ),
      //         ),
      //         onPressed: () {},
      //         icon: const Icon(
      //           Icons.payment_rounded,
      //           color: Colors.black,
      //           size: 33,
      //         ),
      //         label: const Text("Payments",
      //             style: TextStyle(
      //                 color: Color.fromRGBO(48, 55, 72, 1.0),
      //                 fontSize: 20,
      //                 overflow: TextOverflow.clip))),
      //     const SizedBox(width: 400, height: 15),
      //     TextButton.icon(
      //         style: ButtonStyle(
      //           alignment: Alignment.centerLeft,
      //           fixedSize:
      //               MaterialStateProperty.all<Size>(const Size(300, 50.0)),
      //           backgroundColor:
      //               MaterialStateProperty.all<Color>(Colors.transparent),
      //           shape: MaterialStateProperty.all<OutlinedBorder>(
      //             RoundedRectangleBorder(
      //               borderRadius: BorderRadius.circular(
      //                   10.0), // Adjust the radius as needed
      //               side: const BorderSide(
      //                   color: Color.fromRGBO(
      //                       48, 55, 72, 1.00)), // Set the border color
      //             ),
      //           ),
      //         ),
      //         onPressed: () {},
      //         icon: const Icon(
      //           Icons.book_online_outlined,
      //           color: Colors.black,
      //           size: 33,
      //         ),
      //         label: const Text("My Bookings",
      //             style: TextStyle(
      //                 color: Color.fromRGBO(48, 55, 72, 1.0),
      //                 fontSize: 20,
      //                 overflow: TextOverflow.clip))),
      //     const SizedBox(width: 400, height: 15),
      //     TextButton.icon(
      //         style: ButtonStyle(
      //           alignment: Alignment.centerLeft,
      //           fixedSize:
      //               MaterialStateProperty.all<Size>(const Size(300, 50.0)),
      //           backgroundColor:
      //               MaterialStateProperty.all<Color>(Colors.transparent),
      //           shape: MaterialStateProperty.all<OutlinedBorder>(
      //             RoundedRectangleBorder(
      //               borderRadius: BorderRadius.circular(
      //                   10.0), // Adjust the radius as needed
      //               side: const BorderSide(
      //                   color: Color.fromRGBO(
      //                       48, 55, 72, 1.00)), // Set the border color
      //             ),
      //           ),
      //         ),
      //         onPressed: () {},
      //         icon: const Icon(
      //           Icons.monochrome_photos_outlined,
      //           color: Colors.black,
      //           size: 33,
      //         ),
      //         label: const Text("Posts",
      //             style: TextStyle(
      //                 color: Color.fromRGBO(48, 55, 72, 1.0),
      //                 fontSize: 20,
      //                 overflow: TextOverflow.clip))),
      //     const SizedBox(width: 400, height: 15),
      //     TextButton.icon(
      //         style: ButtonStyle(
      //           alignment: Alignment.centerLeft,
      //           fixedSize:
      //               MaterialStateProperty.all<Size>(const Size(300, 50.0)),
      //           backgroundColor:
      //               MaterialStateProperty.all<Color>(Colors.transparent),
      //           shape: MaterialStateProperty.all<OutlinedBorder>(
      //             RoundedRectangleBorder(
      //               borderRadius: BorderRadius.circular(
      //                   10.0), // Adjust the radius as needed
      //               side: const BorderSide(
      //                   color: Color.fromRGBO(
      //                       48, 55, 72, 1.00)), // Set the border color
      //             ),
      //           ),
      //         ),
      //         onPressed: () {
      //           Navigator.popUntil(context, (route) => route.isFirst);
      //           Navigator.pushReplacement(context,
      //               MaterialPageRoute(builder: (context) => const LoginPage()));
      //         },
      //         icon: const Icon(
      //           Icons.logout,
      //           color: Colors.black,
      //           size: 33,
      //         ),
      //         label: const Text("Logout",
      //             style: TextStyle(
      //                 color: Color.fromRGBO(48, 55, 72, 1.0),
      //                 fontSize: 20,
      //                 overflow: TextOverflow.clip))),
      //   ],
      // ),

//  Tripss
// backgroundColor: Color.fromARGB(255, 235, 239, 250),
// appBar: AppBar(
//   backgroundColor: const Color.fromARGB(255, 235, 239, 250),
//   centerTitle: true,
//   title: const Text(
//     "Create New Trip",
//     style: TextStyle(
//         color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
//   ),
// ),