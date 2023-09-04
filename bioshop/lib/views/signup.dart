import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/authController.dart';


class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController username = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AuthController authController = Get.put(AuthController());
  ImagePicker _picker = ImagePicker();
  File? selectedImage;
 
  String? emailError;
  bool isLoading = false;

    late SharedPreferences prefs;
 


  Future<void> _importImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

  Future<void> _takeImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

  Future<void> _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
        emailError = ""; 
      });

      final registrationResponse = selectedImage != null
          ? await authController.registerUser(
              email.text,
              password.text,
              username.text,
              selectedImage!,
            )
          : await authController.registerUserwithouimage(
              email.text,
              password.text,
              username.text,
            );

      if (authController.registrationResponse == "This email already exists") {
        setState(() {
          emailError = "This email is already taken";
          isLoading = false; // Reset isLoading here to allow the user to retry
        });
      } else {
        // Registration success, navigate to another screen
        setState(() {
          emailError = ""; // Reset emailError for future sign-up attempts
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient:
        const  LinearGradient(
            colors: [
             Color(0xffADC4CE),
             Color(0xff96C291),
            ],
             begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
          )

        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 70),
              Text(
                "Create an Account",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF4EEEE),
                ),
              ),
              SizedBox(height: 50),
               Center(
                          child: InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Choose Image'),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          GestureDetector(
                                            child: Text('Gallery'),
                                            onTap: () {
                                              _importImage();
                                              Navigator.pop(context);
                                            },
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                          ),
                                          GestureDetector(
                                            child: Text('Camera'),
                                            onTap: () {
                                              _takeImage();
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child:Stack(
        children: [
         Container(
        width: MediaQuery.of(context).size.width * 0.3,
        height: MediaQuery.of(context).size.width * 0.3,
        decoration: BoxDecoration(
          boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3), // Shadow color
          spreadRadius: 2, // Spread radius of the shadow
          blurRadius: 5, // Blur radius of the shadow
          offset: Offset(0, 3), // Offset of the shadow
        ),
          ],
          shape: BoxShape.circle,
          color: Color(0xffF4EEEE).withOpacity(0.7),
          border: Border.all(
        width: 2,
        color: Color.fromARGB(255, 45, 98, 39)
          ),
          image: selectedImage != null
          ? DecorationImage(
              image: FileImage(selectedImage!),
              fit: BoxFit.cover,
            )
          : null,
        ),
      ),
      
          if (selectedImage == null) // Display the default icon when no image is selected
        Positioned.fill(
          child: Icon(
            Icons.person, // You can replace this with the desired default icon
            size: 40,
            color: Color.fromARGB(255, 45, 98, 39)
          ),
        ),
        ],
      ))),
              SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.77,
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: TextFormField(
                          style: TextStyle(color: Colors.black),
                          controller: username,
                          decoration: InputDecoration(
                             labelStyle: TextStyle(color: Color.fromARGB(255, 45, 98, 39)),
                            fillColor: Colors.black,
                            labelText: "Username",
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Username cannot be empty';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.77,
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: TextFormField(
                          style: TextStyle(color: Colors.black),
                          onChanged: (value) {
                            setState(() {
                              emailError = null;
                            });
                          },
                          controller: email,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                             labelStyle: TextStyle(color: Color.fromARGB(255, 45, 98, 39)),
                            fillColor: Colors.black,
                            labelText: "Email",
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Email cannot be empty';
                            }
                            if(emailError != null){
                              return emailError;
                            }
                            if (!RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+\.[a-z]+$").hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.77,
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: TextFormField(
                          controller: password,
                          style: TextStyle(color: Colors.black),
                          obscureText: true,
                          decoration: InputDecoration(
                             labelStyle: TextStyle(color: Color.fromARGB(255, 45, 98, 39)),
                            fillColor: Colors.black,
                            labelText: "Password",
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Password cannot be empty';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters long';
                            }
                            
                           
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 24),
                      Card(
                        elevation: 25,
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.07,
                          width: MediaQuery.of(context).size.width * 0.6,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xffCAEDFF),
                               Color(0xffF4EEEE).withOpacity(0.7),
                              ],
                              begin: Alignment.topLeft,
                               end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextButton(
                            onPressed:  isLoading ? null : _handleSignUp,
                            child: isLoading
                                ? CircularProgressIndicator(color: Color.fromARGB(255, 45, 98, 39))
                                :
                            Text(
                              "Sign Up",
                              style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 45, 98, 39)),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account? ",
                            style: TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(255, 55, 104, 49)
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Text(
                              'Sign In',
                              style: TextStyle(
                                fontWeight: FontWeight.w100,
                                fontSize: 16,
                                color: Color.fromARGB(255, 45, 98, 39)
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
