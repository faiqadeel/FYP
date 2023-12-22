import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Social extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Feed'),
      ),
      body: GalleryList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your logic for handling the add button press
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class GalleryList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('images').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
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

        final List<DocumentSnapshot> documents = snapshot.data!.docs;

        return ListView.builder(
          itemCount: documents.length,
          itemBuilder: (context, index) {
            return GalleryItem(
              imageUrl: documents[index]['imageUrl'],
              documentId: documents[index].id,
              uploadedBy: documents[index]["Uploaded By"],
            );
          },
        );
      },
    );
  }
}

class GalleryItem extends StatelessWidget {
  final String imageUrl;
  final String documentId;
  final String uploadedBy;

  GalleryItem(
      {required this.imageUrl,
      required this.documentId,
      required this.uploadedBy});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(
                vertical: 8.0), // Add vertical margin
            child: Text(
              uploadedBy, // Add your title text here
              style:
                  const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 8.0), // Add bottom margin
            child: Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: imageUrl,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                Positioned(
                  bottom: 8.0,
                  right: 8.0,
                  child: LikeButton(documentId: documentId),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LikeButton extends StatefulWidget {
  final String documentId;

  LikeButton({required this.documentId});

  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isLiked ? Icons.favorite : Icons.favorite_border,
        color: isLiked ? Colors.red : Colors.grey,
      ),
      onPressed: () {
        // Add your logic for handling the like button press and updating Firebase
        setState(() {
          isLiked = !isLiked;
        });
      },
    );
  }
}
