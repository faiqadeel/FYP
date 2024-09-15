import 'package:flutter/material.dart';

class trips extends StatelessWidget {
  final String hotelName;
  final String location;
  final String chargesPerNight;
  final String backgroundImageUrl; // URL of the background image

  const trips({
    Key? key,
    required this.hotelName,
    required this.location,
    required this.chargesPerNight,
    required this.backgroundImageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4, // Adds a shadow effect
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 200, // Set the height of the background image
            decoration: BoxDecoration(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12.0)),
              image: DecorationImage(
                image: NetworkImage(backgroundImageUrl), // Load image from URL
                fit: BoxFit
                    .cover, // Adjusts the image to cover the entire container
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                    ),
                    children: [
                      const WidgetSpan(child: Text("   ")),
                      const TextSpan(
                        text: 'Hotel Name: Example Hotel\n',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const WidgetSpan(child: Text("   ")),
                      WidgetSpan(
                          child: Icon(
                        Icons.location_on,
                        size: 30,
                        color: Colors.red[900],
                      )),
                      const TextSpan(
                        text: 'Location: City, Country\n',
                      ),
                      const WidgetSpan(child: Text("   ")),
                      const TextSpan(
                        text: 'Charges Per Night: \$100',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
