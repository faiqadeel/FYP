import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_app/components/dialogBox.dart';
import 'package:my_app/components/textFieldComponent.dart';

import '../components/Colors.dart';
import 'CreatePostScreen.dart';
import 'Profile.dart';

class Social extends StatefulWidget {
  final String name;
  const Social({super.key, required this.name});
  @override
  _SocialState createState() => _SocialState();
}

class _SocialState extends State<Social> {
  String ProfileUrl = '';
  Future<List<Post>> fetchPosts() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('Posts').get();
    return snapshot.docs.map((doc) => Post.fromFirestore(doc)).toList();
  }

  void fetchProfileURL(String name) async {
    try {
      QuerySnapshot Doc = await FirebaseFirestore.instance
          .collection("tourists")
          .where("name", isEqualTo: name)
          .get();
      DocumentSnapshot myDoc = Doc.docs.first;
      setState(() {
        ProfileUrl = myDoc['Profile URL'];
      });
    } catch (e) {
      error_dialogue_box(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activity Feed', style: AppBarTextStyle()),
        centerTitle: true,
        backgroundColor: AppBarBackground(),
      ),
      body: FutureBuilder<List<Post>>(
        future: fetchPosts(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Post post = snapshot.data![index];
              fetchProfileURL(post.postedBy);
              print("IMAGE URL IS" + post.mediaUrl!.toString());
              return Card(
                margin: EdgeInsets.all(8),
                child: Column(
                  children: [
                    ListTile(
                      leading: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Profile(
                                        friendName: post.postedBy,
                                        name: widget.name,
                                      )));
                        },
                        child: CircleAvatar(
                            backgroundImage: NetworkImage(ProfileUrl == ""
                                ? "https://cdn-icons-png.flaticon.com/512/3135/3135715.png"
                                : ProfileUrl)),
                      ), // Assuming the first URL is the user's profile picture
                      title: Text(post.postedBy),
                      subtitle: Text('${post.Description}'),
                    ),
                    Image(image: NetworkImage(post.mediaUrl)), // Post media
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: Icon(Icons.favorite_border),
                          onPressed: () async {
                            try {
                              CollectionReference colRef = FirebaseFirestore
                                  .instance
                                  .collection("Posts");
                              QuerySnapshot postRef = await FirebaseFirestore
                                  .instance
                                  .collection("Posts")
                                  .where("Media UrL", isEqualTo: post.mediaUrl)
                                  .get();
                              DocumentSnapshot postDoc = postRef.docs.first;

                              double likes = postDoc["likes"];
                              await colRef
                                  .doc(postDoc.id)
                                  .update({"likes": likes + 1});
                            } catch (e) {
                              error_dialogue_box(context, e.toString());
                            }
                          },
                        ),
                        Text(post.likes.toString()),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CreatePost(name: widget.name)));
          // Implement adding new post functionality
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class Post {
  final String mediaUrl; // Could be a photo or video URL
  final String postedBy;
  final int likes;
  final String Description;

  Post({
    required this.mediaUrl,
    required this.postedBy,
    required this.likes,
    required this.Description,
  });

  factory Post.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Post(
      mediaUrl: data['Media Url'] ?? '',
      postedBy: data['Posted By'] ?? '',
      likes: int.parse(data['likes'].toString()) ?? 0,
      Description: data["Description"] ?? "",
    );
  }
}
