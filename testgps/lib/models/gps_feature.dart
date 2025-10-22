import 'package:flutter/material.dart';

class GPSFeature {
  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;
  final String route;

  const GPSFeature({
    required this.title,
    required this.description,
    required this.icon,
    required this.iconColor,
    required this.route,
  });
}

class GPSFeatureData {
  static const List<GPSFeature> features = [
    GPSFeature(
      title: 'GPS Navigation',
      description: 'Your smart guide on every journey.',
      icon: Icons.navigation,
      iconColor: Colors.blue,
      route: '/navigation',
    ),
    GPSFeature(
      title: 'Satellite View',
      description: 'Explore the world from above.',
      icon: Icons.satellite,
      iconColor: Colors.green,
      route: '/satellite',
    ),
    GPSFeature(
      title: 'Route Finder',
      description: 'Find the best path to your destination.',
      icon: Icons.route,
      iconColor: Colors.orange,
      route: '/route',
    ),
    GPSFeature(
      title: 'Location Finder',
      description: 'Discover your current location.',
      icon: Icons.my_location,
      iconColor: Colors.red,
      route: '/location',
    ),
    GPSFeature(
      title: 'Nearby Places',
      description: 'Find interesting places around you.',
      icon: Icons.place,
      iconColor: Colors.purple,
      route: '/nearby',
    ),
    GPSFeature(
      title: 'Traffic Map',
      description: 'Stay ahead with real-time traffic updates.',
      icon: Icons.traffic,
      iconColor: Colors.amber,
      route: '/traffic',
    ),
  ];
}
