import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/authController.dart';
import '../controllers/userController.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController username = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AuthController authController = Get.put(AuthController());
  ImagePicker _picker = ImagePicker();
  File? selectedImage;  
  final userController _userController = Get.put(userController());
 
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



     
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       foregroundColor: Color(0xff96C291),
        backgroundColor:   Colors.white ,
     
        centerTitle: true,
      ),
      backgroundColor:   Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 50),
             
              Text(
                "Edit Profile",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color:   Colors.black ,
                ),
              ),
              SizedBox(height: 50),
              
            
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.77,
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: TextFormField(
                        controller: username,
                        style: TextStyle(color: Colors.black), 
                        cursorColor:  Colors.white ,

                        decoration: InputDecoration(
                          fillColor:  Colors.black,
                          labelStyle: TextStyle(color: Color.fromARGB(255, 45, 98, 39)),
                          labelText: "Username",
                        ),
                        
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.77,
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: TextFormField(
                        onChanged: (value) {
                          setState(() {
                            emailError = null;
                          });
                        },
                        controller: email,
                         style: TextStyle(color: Colors.black ), 
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                              fillColor:  Colors.black,
                          labelStyle: TextStyle(color: Color.fromARGB(255, 45, 98, 39)),
                          labelText: "Email",
                        ),
                       
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.77,
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: TextFormField(
                        controller: password,
                        obscureText: true,
                         style: TextStyle(color: Colors.black ), 
                        decoration: InputDecoration(
                              fillColor:  Colors.black,
                          labelStyle: TextStyle(color: Color.fromARGB(255, 45, 98, 39)),
                          labelText: "Password",
                        ),
                       
                      ),
                    ),
                    SizedBox(height: 64),
                    GestureDetector(
                      onTap: (){
                        _userController.updateUser(email.text, password.text, username.text);
                      
                      },
                      child: Card(
                        elevation: 10,
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
                          child: Center(
                            child: Text("Save Changes",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                         
                        ),
                      ),
                    ),
                    
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
    }
