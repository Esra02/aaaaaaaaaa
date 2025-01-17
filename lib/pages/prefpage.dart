import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(PreferenceSelectionApp());
}

class PreferenceSelectionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Preference Selection',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PreferenceSelectionPage(),
    );
  }
}

class PreferenceSelectionPage extends StatefulWidget {
  @override
  _PreferenceSelectionPageState createState() => _PreferenceSelectionPageState();
}

class _PreferenceSelectionPageState extends State<PreferenceSelectionPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> preferences = [
    {'name': 'Travel', 'image': 'assets/travel.jpg'},
    {'name': 'Food', 'image': 'assets/food.jpg'},
    {'name': 'Fashion', 'image': 'assets/fashion.jpg'},
    {'name': 'Art', 'image': 'assets/art.jpg'},
    {'name': 'Technology', 'image': 'assets/technology.jpg'},
    {'name': 'Photography', 'image': 'assets/photography.jpg'},
    {'name': 'Fitness', 'image': 'assets/fitness.jpg'},
    {'name': 'DIY & Crafts', 'image': 'assets/diy.jpg'},
    {'name': 'Home Decor', 'image': 'assets/decor.jpg'},
    {'name': 'Beauty', 'image': 'assets/beauty.jpg'},
    {'name': 'Books', 'image': 'assets/books.jpg'},
    {'name': 'Gardening', 'image': 'assets/gardening.jpg'},
  ];

  List<String> selectedPreferences = [];

  void _togglePreference(String preference) {
    setState(() {
      if (selectedPreferences.contains(preference)) {
        selectedPreferences.remove(preference);
      } else {
        selectedPreferences.add(preference);
      }
    });
  }


  Future<void> _savePreferences() async {
    try {
      // Get the user's UID (replace with your actual user authentication implementation)
      String uid = 'eOABH2sYLTeFsgQYlnsvJlUtezx2'; // Replace with actual user UID
      // Reference to the user's preferences document
      DocumentReference userPrefsRef = _firestore.collection('user_preferences').doc(uid);

      // Save the selected preferences to Firestore
      await userPrefsRef.set({'preferences': selectedPreferences});
    } catch (error) {
      print('Error saving user preferences: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Preferences'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
          childAspectRatio: 0.8,
        ),
        itemCount: preferences.length,
        itemBuilder: (context, index) {
          final preference = preferences[index];
          return GestureDetector(
            onTap: () {
              _togglePreference(preference['name']);
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: selectedPreferences.contains(preference['name']) ? Colors.blue : Colors.transparent, width: 2.0),
                borderRadius: BorderRadius.circular(12.0), // Rounded corners
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.0), // Rounded corners
                    child: Image.asset(
                      preference['image'],
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 8.0,
                    left: 8.0,
                    right: 8.0,
                    child: Text(
                      preference['name'],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _savePreferences,
        child: Icon(Icons.check),
      ),
    );
  }
}