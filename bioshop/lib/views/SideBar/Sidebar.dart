
import 'package:bioshop/views/EditProfile.dart';
import 'package:bioshop/views/UserOrders.dart';
import 'package:bioshop/views/signin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controllers/authController.dart';

import '../../controllers/productController.dart';
import '../../controllers/userController.dart';
import '../CartPage.dart';
import '../Home.dart';
import '../profile.dart';
import '../sellProduct.dart';
import 'infocard.dart';


class SideBar extends StatefulWidget {
  const SideBar({Key? key}) : super(key: key);

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
   final userController _userController = Get.put(userController());
  final AuthController _authController = Get.put(AuthController());
  final ProductController _productController = Get.put(ProductController());
  
 
  late SharedPreferences prefs;

 

  _logout() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('id');
  prefs.remove('token');
  Get.to(SignIn());
  }


   @override
  void initState() {
    super.initState();
  
  }

 
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      body: Stack(
        children: [ Container(
          
          decoration: BoxDecoration(
                                                       gradient: LinearGradient(
                                colors: [ Color(0xffADC4CE),
                                          Color(0xff96C291),
                                         ],
                               end: Alignment.bottomLeft,
                                begin: Alignment.topRight,
                                                       ),
                                                    
                                                     ),
          child: ListView(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.close,
                            color:  Colors.black,
                            size: 30,
                          ),
                          onPressed: () {
                            Get.to(HomePage()); },
                        ),
                       Spacer(),
                       
SizedBox(
  width: 24,
),
                        
                        
                      ],
                    ),
                    InfoCard(
                      color: Color.fromARGB(255, 45, 98, 39),
                      imageUrl: _userController.userData!.photo.toString(),
                      name: _userController.userData!.username.toString(),
                      bio: _userController.userData!.email.toString(),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 22, top: 15, right: 15),
                      child:  Divider(color:Colors.black, height: 10),
                    ),
                    
                      SizedBox(
                      height: 24,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 24,
                        ),
                        Icon(
                          Icons.person,
                          color: Colors.black,
                        ),
                        TextButton(
                          onPressed: () {
                          Get.to(ProfilePage());
                          },
                          style: TextButton.styleFrom(
                            primary: Color(0xFF33669A),
                          ),
                          child: Text(
                            'Profile',
                            style: TextStyle(
                              fontSize: 18,
                             color:  Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                      SizedBox(
                      height: 24,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 24,
                        ),
                        Icon(
                          Icons.edit,
                          color: Colors.black,
                        ),
                        TextButton(
                          onPressed: () {
                          Get.to(EditProfile());
                          },
                          style: TextButton.styleFrom(
                            primary: Color(0xFF33669A),
                          ),
                          child: Text(
                            'Edit Profile',
                            style: TextStyle(
                              fontSize: 18,
                             color:  Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                   
                   

                     SizedBox(
                      height: 24,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 24,
                        ),
                        Icon(
                          Icons.shopping_cart_outlined,
                          color: Colors.black,
                        ),
                        TextButton(
                          onPressed: () {
                          Get.to(CartPage());
                          },
                          style: TextButton.styleFrom(
                            primary: Color(0xFF33669A),
                          ),
                          child: Text(
                            'My cart',
                            style: TextStyle(
                              fontSize: 18,
                             color:  Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                   
          

          SizedBox(
                      height: 24,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 24,
                        ),
                        Icon(
                          Icons.list_alt,
                          color: Colors.black,
                        ),
                        TextButton(
                          onPressed: () {
                          Get.to(UserOrders());
                          },
                          style: TextButton.styleFrom(
                            primary: Color(0xFF33669A),
                          ),
                          child: Text(
                            'Your orders',
                            style: TextStyle(
                              fontSize: 18,
                             color:  Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),



                    
          SizedBox(
                      height: 24,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 24,
                        ),
                        Icon(
                          Icons.storefront,
                          color: Colors.black,
                        ),
                        TextButton(
                          onPressed: () {
                          Get.to(SellProduct());
                          },
                          style: TextButton.styleFrom(
                            primary: Color(0xFF33669A),
                          ),
                          child: Text(
                            'Add Product to sell',
                            style: TextStyle(
                              fontSize: 18,
                             color:  Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 24,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 24,
                        ),
                        Icon(
                          Icons.logout,
                          color: Colors.red,
                        ),
                        TextButton(
                          onPressed: () {
                          _logout();
                          },
                          style: TextButton.styleFrom(
                            primary: Color(0xFF33669A),
                          ),
                          child: Text(
                            'Logout',
                            style: TextStyle(
                              fontSize: 18,
                             color:  Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                   
                  
                   
                  
      
           


        
                
  ]),
        ),





      

       
        ],
      ),
    );    
  }
}





