import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_app/components/Colors.dart';
import 'package:my_app/components/dialogBox.dart';

class Requests extends StatefulWidget {
  final String email;
  const Requests({super.key, required this.email});

  @override
  State<Requests> createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {
  bool isPressed = false;
  List<dynamic> friendRequests = [];

  void acceptRequest(String name) async {
    final CollectionReference touristsCollection =
        FirebaseFirestore.instance.collection('tourists');
    try {
      QuerySnapshot friendDoc =
          await touristsCollection.where("name", isEqualTo: name).get();
      QuerySnapshot myDoc = await touristsCollection
          .where("email", isEqualTo: widget.email)
          .get();
      DocumentReference friendDocRef =
          touristsCollection.doc(friendDoc.docs[0].id);
      DocumentReference myDocRef = touristsCollection.doc(myDoc.docs[0].id);
      DocumentSnapshot myDocument = myDoc.docs.first;
      String myName = (myDocument.data() as Map<String, dynamic>)['name'];
      await friendDocRef.update({
        'friends': FieldValue.arrayUnion([myName])
      });
      await myDocRef.update({
        'friends': FieldValue.arrayUnion([name])
      });
      await myDocRef.update({
        'FriendRequests': FieldValue.arrayRemove([name])
      });
      print(myName);
      print(name);
    } catch (e) {
      dialogue_box(context, e.toString());
    }
  }

  void cancelRequest(String name) async {
    try {
      QuerySnapshot myDoc = await FirebaseFirestore.instance
          .collection("tourists")
          .where("email", isEqualTo: widget.email)
          .get();

      DocumentReference myDocRef = myDoc.docs.first.reference;
      await myDocRef.update({
        "FriendRequests": FieldValue.arrayRemove([name])
      });
      friendRequests.remove(name);
    } catch (e) {
      dialogue_box(context, "Error removing the request");
    }
  }

  Future<List<dynamic>> fetchFriendRequests() async {
    try {
      final CollectionReference touristsCollection =
          FirebaseFirestore.instance.collection('tourists');
      QuerySnapshot myDocRef = await touristsCollection
          .where("email", isEqualTo: widget.email)
          .get();
      DocumentSnapshot myDocument = myDocRef.docs.first;
      friendRequests =
          (myDocument.data() as Map<String, dynamic>)['FriendRequests'];
      return friendRequests;
    } catch (e) {
      dialogue_box(context, e.toString());
    }
    return friendRequests;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppBarBackground(),
        centerTitle: true,
        title: const Text('Friend Requests'),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('tourists')
              .where("email", isEqualTo: widget.email)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }
            final myDocs = snapshot.data?.docs ?? [];
            if (myDocs.isEmpty) {
              return Text('No data found.');
            }
            final myDocument = myDocs.first;
            friendRequests =
                (myDocument.data() as Map<String, dynamic>)['FriendRequests'];

            return ListView.builder(
              itemCount: friendRequests.length,
              itemBuilder: (context, index) {
                String request = friendRequests[index];
                return Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(top: 30),
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: button1(), // Adjust the color as needed
                  ),
                  child: ListTile(
                      titleAlignment: ListTileTitleAlignment.center,
                      titleTextStyle: const TextStyle(fontSize: 20),
                      leading: const CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage(
                            'assets/images/avatar.png'), // Add your friend's image
                      ),
                      title: Text(
                        request,
                        style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: () {
                                acceptRequest(request);
                              },
                              icon: const Icon(
                                color: Colors.white,
                                Icons.check_circle,
                                size: 35,
                              )),
                          IconButton(
                              onPressed: () {
                                cancelRequest(request);
                              },
                              icon: const Icon(
                                color: Colors.white,
                                Icons.close_outlined,
                                size: 35,
                              )),
                        ],
                      )),
                );
              },
            );
          }),
    );
  }
}
