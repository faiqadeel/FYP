import 'package:flutter/material.dart';

import 'Colors.dart';

Future<dynamic> dialogue_box(BuildContext context, String message) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: button1(),
          title: const Text('Error',style:TextStyle(color:Colors.white)),
          content: Text(message,style:TextStyle(color:Colors.yellowAccent)),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK',style:TextStyle(color:Colors.yellowAccent)))
          ],
        );
      });
}
