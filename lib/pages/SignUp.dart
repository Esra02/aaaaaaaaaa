import 'package:dal/pages/HomeScreen.dart';
import 'package:dal/pages/Signin.dart';
import 'package:dal/pages/prefpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _Signupstate createState() => _Signupstate();
}

// Define the state for the Signup page
class _Signupstate extends State<SignUp> {
  // Controllers for email and password text fields
  final _userNameTextController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmedpasswordController = TextEditingController();

  Future signup() async {
    if (passwordCondirmed()) {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    ).then((value) {
      Navigator.push(context,
         MaterialPageRoute(builder: (context) => PreferenceSelectionPage()));
    }).onError((error, stackTrace){
      print("Error ${error.toString()}");
    });
    }
  }

  bool passwordCondirmed(){
    if (_passwordController.text.trim() == 
    _confirmedpasswordController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmedpasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Create Your Account",
          style: TextStyle(
            fontSize: 20,
            fontFamily: "myfont",
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
      body: Stack(
        children: [
          // Background Rectangle
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.9,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 252, 206, 138),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(40),
                ),
              ),
            ),
          ),

          // Main Content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Name Container
              Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(10),
                ),
                width: 266,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  controller: _userNameTextController,
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.person,
                      color: Color.fromARGB(255, 252, 206, 138),
                    ),
                    hintText: "Name         ",
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(
                height: 23,
              ),


              // Email Container
              Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(10),
                ),
                width: 266,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.email,
                      color: Color.fromARGB(255, 252, 206, 138),
                    ),
                    hintText: "Email     ",
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(
                height: 23,
              ),

              // Password Container
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 253, 252, 253),
                  borderRadius: BorderRadius.circular(10),
                ),
                width: 266,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    suffix: Icon(
                      Icons.visibility,
                      color: Color.fromARGB(255, 252, 206, 138),
                    ),
                    icon: Icon(
                      Icons.lock,
                      color: Color.fromARGB(255, 252, 206, 138),
                      size: 19,
                    ),
                    hintText: "Password    ",
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(
                height: 23,
              ),

              // Confirm Password Container
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 253, 252, 253),
                  borderRadius: BorderRadius.circular(10),
                ),
                width: 266,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  controller: _confirmedpasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    suffix: Icon(
                      Icons.visibility,
                      color: Color.fromARGB(255, 252, 206, 138),
                    ),
                    icon: Icon(
                      Icons.lock,
                      color: Color.fromARGB(255, 252, 206, 138),
                      size: 19,
                    ),
                    hintText: "Confirm Password    ",
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),

              


              // Already have an account Text
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF742A64),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to the sign-in page
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Signin()),
                      );
                    },
                    child: Text(
                      "Sign in",
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromRGBO(228, 88, 101, 100),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: 20,
              ),

              // Submit Button
              Padding(
                padding: const EdgeInsets.symmetric(),
                child: GestureDetector(
                  onTap: signup, // Call signIn method when tapped
                  child: SingleChildScrollView(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF742A64), // Set background color
                        borderRadius:
                            BorderRadius.circular(27), // Set border radius
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 106, vertical: 10), // Set padding
                      child: const Text(
                        "Sign up",
                        style: TextStyle(
                          fontSize: 24,
                          color: Color.fromRGBO(255, 255, 255, 1),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}