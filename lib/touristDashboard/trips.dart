import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  List<String> popPlaces = [];
  List<String> placeURLs = [];
  Future<List<String>> getWebsiteData() async {
    print("inside");

    final response = await http.get(Uri.parse(
        "https://www.thebrokebackpacker.com/beautiful-places-in-pakistan/"));
    if (response.statusCode == 200) {
      dom.Document html = parser.parse(response.body);

      final places = html
          .querySelectorAll(
              'h2.wp-block-heading.has-text-align-center') // Corrected
          .map((element) =>
              element.text.trim()) // Use text for just the text content
          .toList();

      final imageURLs = html
          .querySelectorAll(
              "#content > article > div > div > div.col-12.order-2.offset-md-1.col-md-10.offset-lg-0.col-lg-8.order-lg-1 > div > article > div:nth-child(48) > figure > img") // Corrected
          .map((e) =>
              e.attributes['src'] ??
              "") // Check for null and provide a default value
          .toList();

      // Assuming this is a Flutter Stateful Widget method
      setState(() {
        this.popPlaces = places;
        this.placeURLs = imageURLs;
      });
      print(imageURLs);
      print(popPlaces);
      return imageURLs;
    } else {
      print('failed');
      throw Exception('Failed to load website data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
        future: getWebsiteData(),
        builder: (context, snapshot) {
          return SizedBox(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: popPlaces.length,
              itemBuilder: (BuildContext context, int index) {
                final names = popPlaces[index];
                final url = placeURLs[index];
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    // image: DecorationImage(
                    //   image: NetworkImage(url),
                    //   fit: BoxFit.cover,
                    // ),
                  ),
                  child: Center(child: Text(names)),
                  width: 250.0, // Adjust the width as needed
                  margin: const EdgeInsets.all(8.0),
                );
              },
            ),
          );
        });
  }
}
