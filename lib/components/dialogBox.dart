import 'package:flutter/material.dart';

import 'Colors.dart';

Future<dynamic> error_dialogue_box(BuildContext context, String message) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: dialogueBoxBackground(),
          title: const Text('Error', style: TextStyle(color: Colors.white)),
          content: Text(message, style: TextStyle(color: button2())),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK',
                    style: TextStyle(color: Colors.yellowAccent)))
          ],
        );
      });
}

Future<dynamic> success_dialogue_box(BuildContext context, String message) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: dialogueBoxBackground(),
          title: const Text('Success', style: TextStyle(color: Colors.white)),
          content: Text(message, style: TextStyle(color: button2())),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK', style: TextStyle(color: Colors.white)))
          ],
        );
      });
}

// String formatDate(String inputDateStr) {
//   DateTime inputDate = DateTime.parse(inputDateStr);

//   // Define the output date format
//   DateFormat outputFormat =
//       DateFormat("d'${_getDaySuffix(inputDate.day)}' MMMM, y");

//   // Format the date using the defined format
//   return outputFormat.format(inputDate);
// }

// String _getDaySuffix(int day) {
//   if (day >= 11 && day <= 13) {
//     return 'th';
//   }
//   switch (day % 10) {
//     case 1:
//       return 'st';
//     case 2:
//       return 'nd';
//     case 3:
//       return 'rd';
//     default:
//       return 'th';
//   }
// }

// Future<dynamic> booking_dialogue_box(BuildContext context, String title) {
//   String date = "";
//   TextEditingController customerContact = TextEditingController();
//   TextEditingController requiredRooms = TextEditingController();
//   return showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text(title),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Row(
//                 children: [
//                   ElevatedButton(
//                       style: buttonStyle(),
//                       onPressed: () async {
//                         DateTime? datePicker = await showDatePicker(
//                             context: context,
//                             firstDate: DateTime.now(),
//                             lastDate: DateTime(2025),
//                             initialDate: DateTime.now());

//                         date = formatDate(datePicker.toString());
//                       },
//                       child: const Text(
//                         "Select Date",
//                         style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold),
//                       )),
//                 ],
//               ),
//               const SizedBox(height: 10),
//               TextField(
//                 keyboardType: TextInputType.number,
//                 controller: requiredRooms,
//                 decoration: const InputDecoration(
//                   labelText: 'Enter Number',
//                   hintText: 'Numbers only',
//                 ),
//               ),
//               const SizedBox(height: 10),
//               TextField(
//                 keyboardType: TextInputType.number,
//                 controller: customerContact,
//                 maxLength: 11,
//                 decoration: const InputDecoration(
//                   labelText: 'Enter Number (Max Length: 11)',
//                   hintText: 'Numbers only',
//                 ),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 if (date == '' ||
//                     customerContact.text.isEmpty ||
//                     requiredRooms.text.isEmpty) {
//                   dialogue_box(context, "Please fill out all the fields");
//                 } else {
//                   Navigator.of(context).pop();
//                 }
//               },
//               child: const Text('Confirm Booking'),
//             ),
//           ],
//         );
//       });
// }
