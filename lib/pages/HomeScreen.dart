import 'dart:convert';

import 'package:dal/pages/historypage.dart';
import 'package:dal/pages/userprofilepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Place>> _placesFuture;

  @override
  void initState() {
    super.initState();
    _placesFuture = fetchPlaces();
  }

  Future<List<Place>> fetchPlaces() async {
    final apiKey = 'AIzaSyA7KUC5SrwoA9wqdOyhpkG0Kic5X96GjqM';
    final response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=40.7128,-74.0060&radius=1000&type=restaurant&key=$apiKey'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> places = data['results'];
      return places.map((place) {
        final List<String> photoReferences = [];
        if (place.containsKey('photos')) {
          final List<dynamic> photos = place['photos'];
          photoReferences.addAll(
              photos.map((photo) => photo['photo_reference'].toString()));
        }
        return Place(
          name: place['name'].toString(),
          photoReferences: photoReferences,
        );
      }).toList();
    } else {
      throw Exception('Failed to load places');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore Places'),
      ),
      body: FutureBuilder<List<Place>>(
        future: _placesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final List<Place> places = snapshot.data ?? [];
            return StaggeredGridView.countBuilder(
              crossAxisCount: 4,
              itemCount: places.length,
              itemBuilder: (BuildContext context, int index) {
                final place = places[index];
                final imageUrl = place.photoReferences.isNotEmpty
                    ? 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=${place.photoReferences[0]}&key=AIzaSyA7KUC5SrwoA9wqdOyhpkG0Kic5X96GjqM'
                    : 'assets/placeholder_image.jpg'; // You can replace 'assets/placeholder_image.jpg' with your default placeholder image.
                return CustomItem(
                  index,
                  imageUrl,
                  place.name,
                );
              },
              staggeredTileBuilder: (int index) =>
                  StaggeredTile.count(2, index.isEven ? 3 : 2),
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
            );
          }
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserProfilePage()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                // Navigate to favorites or perform desired action
              },
            ),
            IconButton(
              icon: Icon(Icons.bookmark),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HistoryPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CustomItem extends StatelessWidget {
  final int index;
  final String imageUrl;
  final String itemName;

  const CustomItem(this.index, this.imageUrl, this.itemName, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(itemName: itemName),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          image: DecorationImage(
            image: imageUrl.startsWith('http') ? NetworkImage(imageUrl) : AssetImage(imageUrl) as ImageProvider,
            fit: BoxFit.cover,
          ),
        ),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 102, 39, 39).withOpacity(0.7),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0),
              ),
            ),
            child: Text(
              itemName,
              style: const TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontSize: 16.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final String itemName;

  const DetailScreen({Key? key, required this.itemName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(itemName),
      ),
      body: Center(
        child: Text(
          'Details for $itemName',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}

class Place {
  final String name;
  final List<String> photoReferences;

  Place({required this.name, required this.photoReferences});
}