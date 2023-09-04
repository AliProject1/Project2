import 'package:bioshop/views/UpdateProduct.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/authController.dart';
import '../controllers/orderController.dart';
import '../controllers/productController.dart';
import '../controllers/userController.dart';


import '../models/Product.dart';
import 'UserOrders.dart';
import 'sellProduct.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final userController _userController = Get.put(userController());
  final OrderController _orderController = Get.put(OrderController());
   final AuthController _authController = Get.put(AuthController());
   final ProductController _productController = Get.put(ProductController());
  List<String> Products =[];
   late SharedPreferences prefs;


  @override
  void initState() {
    super.initState();
    _orderController.fetchUserOrders();
    _userController.getUser(_authController.id.toString()).then((value) => setState(() {
      Products = _userController.userData!.myProducts;
    }));
  
  }

  @override
  Widget build(BuildContext context) {
    double maxHeight = MediaQuery.of(context).size.height;
    double maxWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xffCAEDFF),
                          Colors.white,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    width: double.infinity,
                    height: maxHeight * 0.3,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20, left: 20),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Color(0xff96C291),
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 145),
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: Container(
                                    width: maxWidth * 0.8,
                                    height: maxHeight * 0.45,
                                    child: _userController.userData?.photo != null || _userController.userData?.photo != ''
                                        ? Image.network(
                                            _userController.userData!.photo.toString(),
                                            fit: BoxFit.cover,
                                          )
                                        : Icon(
                                            Icons.person,
                                            size: 80,
                                            color: Colors.black,
                                          ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child:  _userController.userData?.photo == null || _userController.userData?.photo == '' ?
                         ClipOval(
                            child: Container(

                                    width: 120,
                                    height: 120,
                                    color: Colors.white,
                           child: Icon(
                                    
                            
                                     Icons.person,
                                      size: 80,
                                     color: Colors.black,
                                   ),)
                         ) 
                                 :
                        CircleAvatar(
                           radius: 60,
                          backgroundColor: Colors.black,
                          child:  ClipOval(
                                  child: AspectRatio(
                                    aspectRatio: 1,
                                    child: Image.network(
                                      _userController.userData!.photo.toString(),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                   
                                ) ) 
                                
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                _userController.userData?.username.toString() ?? '',
                style: GoogleFonts.abhayaLibre(
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 16),

             Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(width: 20,),
                          Text(
                            "My Products",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Spacer(),
                         
                          IconButton(onPressed: (){
                            Get.to(SellProduct());
                          }, icon: Icon( Icons.add,color: Colors.black,size: 30,),),
                           SizedBox(width: 20,),
                        ],
                      ),
              SizedBox(height: 16),
          Padding(
  padding: const EdgeInsets.only(left: 20, right: 20),
  child: SingleChildScrollView(
    scrollDirection: Axis.vertical, // Scroll vertically
    child: Column(
      children: List.generate(
        Products.length,
        (index) => FutureBuilder(
          future: _productController.getProductById(Products[index]),
          builder: (BuildContext context, AsyncSnapshot<Product> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // Display a loading indicator while fetching data
            }

            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (!snapshot.hasData) {
              return Container(); // Return an empty container if no data is available
            }

            final product = snapshot.data;

            return Card(
              elevation: 10,
              
              shape: RoundedRectangleBorder(
                
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0), // Keep the top-left border radius
                  bottomLeft: Radius.circular(15.0), // Keep the bottom-left border radius
                ),
              ),
              child: Container(
                color: Color(0xffCAEDFF),
                child: ListTile(
                        
                  contentPadding: EdgeInsets.zero,
                  onTap: () {
                    // Handle the tap event
                  },
                  leading:  ClipOval(
                  child: Material(
                    color: Colors.white,
                    child: InkWell(
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child:
                             Image.network(
                                product!.photoProduitPrincipale.toString(),
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
                ),
                  title: Text(
                    product.nomProduit ?? '',
                    style: GoogleFonts.aboreto(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff15202B),
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          Get.to(UpdateProduct(),arguments: [product]);
                        },
                        icon: Icon(Icons.edit,color: const Color.fromARGB(255, 29, 91, 142),),
                      ),
                      IconButton(
                        onPressed: () {
                          _productController.deleteProductById(product.sId.toString());
                        },
                        icon: Icon(Icons.delete,color: const Color.fromARGB(255, 184, 46, 36),),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ),
  ),
),


  Row(
                        
                        children: [
                          SizedBox(width: 20,),
                          Text(
                            "History",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Spacer(),
                          TextButton(
                            onPressed: () {
                               Get.to(UserOrders());
                            },
                            child: Text(
                              "See All",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ),
                           SizedBox(width: 20,),
                        ],
                      ),
              Obx(() {
                if (_orderController.isdatalod.value) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (_orderController.order != null) {
                  return ListView.builder(
  shrinkWrap: true,
  physics: NeverScrollableScrollPhysics(),
  itemCount: _orderController.order!.data!.length > 5 ? 5 : _orderController.order!.data!.length,
  itemBuilder: (context, index) {
    final order = _orderController.order!.data![index];
    final created = DateTime.parse(order.createdAt.toString());
 
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Card(
        elevation: 10,
        child: Container(
          color: Color(0xff96C291),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        child: SizedBox(
                          width: maxWidth * 0.8,
                          height:maxWidth * 0.8,
                          child: order.pphote == null
                              ? Icon(Icons.image)
                              : Image.network(
                                  order.pphote!,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      );
                    },
                  );
                },
                child: ClipOval(
                  child: Material(
                    color: Colors.white,
                    child: InkWell(
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: order.pphote == null
                            ? Icon(Icons.image)
                            : Image.network(
                                order.pphote!,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Column(
                children: [
                  Text(
                    order.namep!,
                    style: GoogleFonts.acme(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "\$ ${order.pricep!}",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
              Spacer(),
              Text(
                "${created.day}/${created.month}/${created.year}",
                style: GoogleFonts.acme(
                  fontSize: 14,
                  fontWeight: FontWeight.w200,
                ),
              ),
              
            ],
          ),
        ),
      ),
    );
  },
);

                } else {
                  return Center(
                    child: Text("No orders available."),
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
