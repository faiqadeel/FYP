import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_app/components/Colors.dart';
import 'package:my_app/components/dialogBox.dart';
import 'package:my_app/touristDashboard/Requests.dart';

import '../components/textFieldComponent.dart';
import 'Profile.dart';

class Friends extends StatefulWidget {
  final String name;
  final String email;
  const Friends({super.key, required this.name, required this.email});

  @override
  State<Friends> createState() => _Friends();
}

class _Friends extends State<Friends> {
  List<dynamic>? friends = [];
  List<dynamic>? notFriends = [];
  List<dynamic>? friendRequests = [];
  List<dynamic>? sentRequests = [];
  bool onRequests = false;
  bool _isVisible = false;
  bool isPressed = false;
  bool noFriends = false;
  bool isProcessing = true;
  void sendRequest(String friendname) async {
    final CollectionReference touristsCollection =
        FirebaseFirestore.instance.collection('tourists');
    try {
      QuerySnapshot frSnapshot =
          await touristsCollection.where("name", isEqualTo: friendname).get();
      QuerySnapshot mySnapshot = await touristsCollection
          .where("email", isEqualTo: widget.email)
          .get();
      DocumentReference frDocRef =
          touristsCollection.doc(frSnapshot.docs[0].id);
      DocumentReference myDocRef =
          touristsCollection.doc(mySnapshot.docs[0].id);
      await frDocRef.update({
        'FriendRequests': FieldValue.arrayUnion([widget.name])
      });
      await myDocRef.update({
        'SentRequests': FieldValue.arrayUnion([friendname])
      });
      showText();
    } catch (e) {
      print("error");
      dialogue_box(context, e.toString());
    }
  }

  void showText() {
    setState(() {
      _isVisible = true;
    });

    Timer(const Duration(seconds: 2), () {
      setState(() {
        _isVisible = false;
      });
    });
  }

  // void fetchData() async {
  //   try {
  //     CollectionReference touristCollection =
  //         FirebaseFirestore.instance.collection('tourists');
  //     QuerySnapshot addFriendDocs = await touristCollection
  //         .where("name", isNotEqualTo: widget.name)
  //         .get();
  //     QuerySnapshot myDocs =
  //         await touristCollection.where("email", isEqualTo: widget.email).get();
  //     if (addFriendDocs.docs.isNotEmpty) {
  //       for (DocumentSnapshot<Object?> doc in addFriendDocs.docs) {
  //         notFriends!.add(doc['name']);
  //       }
  //     }
  //     // if (myDocs.docs.isNotEmpty) {
  //     //   DocumentSnapshot myDoc =
  //     //       await touristCollection.doc(myDocs.docs.first.id).get();
  //     //   setState(() {
  //     //     for (var friend in myDoc['friends']) {
  //     //       friends!.add(friend);
  //     //     }
  //     //     for (var friend in myDoc['FriendRequests']) {
  //     //       friendRequests!.add(friend);
  //     //     }
  //     //     for (var friend in myDoc['SentRequests']) {
  //     //       sentRequests!.add(friend);
  //     //     }
  //     //   });
  //     // }
  //     friends!.toSet().toList();
  //     friendRequests!.toSet().toList();
  //     notFriends!.toSet().toList();
  //     setState(() {
  //       isProcessing = false;
  //     });
  //   } catch (e) {}
  // }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: AppBarBackground(),
          centerTitle: true,
          title: Text(
            "My Friends",
            style: AppBarTextStyle(),
          ),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Requests(email: widget.email)));
                });
              },
              icon: const Icon(Icons.person_add),
              iconSize: 35,
            ),
          ],
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
                return const Center(child: Text('No data found.'));
              }
              final myDoc = myDocs.first;
              friends = myDoc['friends'];
              friendRequests = myDoc['FriendRequests'];
              sentRequests = myDoc['SentRequests'];

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        itemCount: friends == null ? 1 : friends?.length,
                        itemBuilder: (context, index) {
                          return friends == null
                              // ignore: unnecessary_brace_in_string_interps
                              ? const Center(
                                  child: Text("No Friends to show here!!"))
                              : FractionallySizedBox(
                                  widthFactor: 1.0,
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 70,
                                    margin: const EdgeInsets.all(8.0),
                                    padding: const EdgeInsets.all(16.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color:
                                          button1(), // Adjust the color as needed
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          friends![index],
                                          style: const TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                        IconButton(
                                            color: Colors.white,
                                            iconSize: 30,
                                            onPressed: () {
                                              Profile(
                                                friendName: friends![index],
                                                name: widget.name,
                                              );
                                            },
                                            icon: const Icon(Icons.account_box))
                                      ],
                                    ),
                                  ),
                                );
                        }),
                  ),
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("tourists")
                          .where("email", isNotEqualTo: widget.email)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                          return const Center(child: Text('No data found.'));
                        }
                        myDocs.forEach((element) {
                          if (friends!.contains(element['name']) ||
                              friendRequests!.contains(element['name']) ||
                              sentRequests!.contains(element['name']) &&
                                  notFriends!.contains(element['name'])) {
                            notFriends!.remove(element['name']);
                          } else {
                            notFriends!.add(element['name']);
                          }
                        });
                        return notFriends!.isEmpty
                            ? const Center(
                                child: Text("No Profiles!!"),
                              )
                            : Flexible(
                                flex: 2,
                                child: Expanded(
                                  child: ListView.builder(
                                    itemCount: notFriends!.length,
                                    itemBuilder: (context, index) {
                                      String name = notFriends![index];
                                      return FractionallySizedBox(
                                        widthFactor: 1.0,
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: 70,
                                          margin: const EdgeInsets.all(8.0),
                                          padding: const EdgeInsets.all(16.0),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            color:
                                                button1(), // Adjust the color as needed
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                name,
                                                style: const TextStyle(
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                              IconButton(
                                                  color: Colors.white,
                                                  iconSize: 30,
                                                  onPressed: !isPressed
                                                      ? () {
                                                          sendRequest(name);
                                                          setState(() {
                                                            isPressed = true;
                                                          });
                                                        }
                                                      : null,
                                                  icon: !isPressed
                                                      ? const Icon(Icons.add)
                                                      : const Icon(Icons
                                                          .check_circle_sharp))
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                      }),
                  AnimatedOpacity(
                    duration: const Duration(seconds: 1),
                    opacity: _isVisible ? 1.0 : 0.0,
                    child: Container(
                      padding: const EdgeInsets.all(
                          8.0), // Add padding for better appearance
                      decoration: BoxDecoration(
                        color: Colors.blue, // Set the background color
                        borderRadius: BorderRadius.circular(
                            8.0), // Optional: Add border radius for rounded corners
                      ),
                      child: const Text(
                        'Friend request sent successfully',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors
                                .white), // Set text color to contrast with background
                      ),
                    ),
                  ),
                ],
              );
            }));
  }
}
