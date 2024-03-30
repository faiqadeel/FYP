import 'package:flutter/material.dart';

class TourGuide extends StatefulWidget {
  final String provider_id;
  const TourGuide({super.key, required this.provider_id});

  @override
  State<TourGuide> createState() => _TourGuideState();
}

class _TourGuideState extends State<TourGuide> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Tour Guide's Screen")),
    );
  }
}
