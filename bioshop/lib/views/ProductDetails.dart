

import 'package:bioshop/views/BuyNow.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/authController.dart';
import '../controllers/cartController.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({super.key});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
   late SharedPreferences prefs;

  CartController _cartController = Get.put(CartController());
  AuthController  _authController = Get.put(AuthController());
 
  var data =Get.arguments;
  

  @override
  Widget build(BuildContext context) {
      var maxHeight =MediaQuery.of(context).size.height;
  var maxWidth= MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
           backgroundColor:Colors.white,
           elevation: 0,
           scrolledUnderElevation: 0,
           foregroundColor: Color(0xff96C291),
      ),
      backgroundColor:Colors.white,
      body: 
         
          Padding(
            padding: EdgeInsets.only(top: 30),
            child: Stack(
             
              children: [
           Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: maxWidth,
              
              child: CarouselSlider(
                items: [
                  data[0].photoProduitPrincipale != null
            ? Container(
                width: maxWidth,
               
                child: Image.network(data[0].photoProduitPrincipale.toString(), height: maxHeight),
              )
            : Container(),
                ],
                options: CarouselOptions(
                  height: maxHeight * 0.25,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 3),
                  autoPlayAnimationDuration: Duration(milliseconds: 900),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  pauseAutoPlayOnTouch: true,
                  aspectRatio: 5.0,
                  viewportFraction: 1,
                ),
              ),
            ),
          ),
               
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xff96C291),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    width: double.infinity,
                    height: maxHeight *0.44,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child:
                         
                          
                          Text(
                            data[0].nomProduit,
                            style: GoogleFonts.poppins(
                              fontSize: 38,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                       
                        Icon(Icons.add_business_outlined,size: 30,color: Colors.white,),
                      
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                  data[0].description,
                  maxLines: 2, 
                  overflow: TextOverflow.ellipsis, 
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                  ),
                )
                ,
                        ),
                        SizedBox(height: 20),
                       Row(
                        children: [
                         Spacer(),
                           Text(
                              'Prix : ',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            
                             Text(
                            '${data[0].prixProduitAfter.toString()} Dt',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            Spacer()
                        ],
                       ),
                       Spacer(),
                         GestureDetector(
                      onTap:(){
                        _cartController.addToCart(_authController.id.value, data[0].sId);
                      },
                       child: Container(
                       decoration: BoxDecoration(
                         borderRadius: BorderRadius.all(
                     Radius.circular(20),
                          

                         ),
                         gradient: LinearGradient(
                           colors: [ Color(0xffCAEDFF),
                               Color(0xffF4EEEE).withOpacity(0.7),],
                           end: Alignment.bottomLeft,
                           begin: Alignment.topRight,
                         ),
                       ),
                       width: maxWidth,
                       height: maxHeight * 0.08,
                       child: Center(
                         child: Text(
                           'Add to cart',
                           style: GoogleFonts.poppins(
                             fontSize: 18,
                             fontWeight: FontWeight.w500,
                             color: Colors.black,
                           ),
                         ),
                       ),
                     ),
                     ),
                     Spacer(),
                     GestureDetector(
                      onTap:(){
                        Get.to(BuyNow(),arguments: [data[0]],transition: Transition.rightToLeft,duration: Duration(milliseconds: 600));
                      },
                       child: Container(
                       decoration: BoxDecoration(
                         borderRadius: BorderRadius.only(
                           topLeft: Radius.circular(20),
                           topRight: Radius.circular(20),
                         ),
                         gradient: LinearGradient(
                           colors: [ Color(0xffCAEDFF),
                               Color(0xffF4EEEE).withOpacity(0.7),],
                           begin: Alignment.bottomLeft,
                           end: Alignment.topRight,
                         ),
                       ),
                       width: maxWidth,
                       height: maxHeight * 0.08,
                       child: Center(
                         child: Text(
                           'Buy now',
                           style: GoogleFonts.poppins(
                             fontSize: 18,
                             fontWeight: FontWeight.w500,
                             color: Colors.black,
                           ),
                         ),
                       ),
                     ),
                     ),
                
                
                   
                          
                      ],
                    ),
                    
                   
                  ),
                ),
                
              
              ],
            ),
          ),
          
     
      
     
    );
  }
}