import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/authController.dart';
import '../controllers/cartController.dart';
import '../controllers/productController.dart';
import '../controllers/userController.dart';
import 'CartPage.dart';
import 'ProductDetails.dart';
import 'SideBar/Sidebar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final userController _userController = Get.put(userController());
  final AuthController _authController = Get.put(AuthController());
  final ProductController _productController = Get.put(ProductController());
  final CartController _cartController = Get.put(CartController());
bool isLoaded = false;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      await _productController.getAllProducts();
      await _userController.getUser(_authController.id.toString());
      setState(() {
        isLoaded = true;
      });
    } catch (e) {
      print('Error loading user data: $e');
      setState(() {
        isLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double maxHeight = MediaQuery.of(context).size.height;
    double maxWidth = MediaQuery.of(context).size.width;
    return !isLoaded
        ? Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: _loadUserData,
          child: Scaffold(
              drawer: SideBar(),
              backgroundColor: Colors.white,
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Get.to(
                              SideBar(),
                              transition: Transition.leftToRight,
                              duration: Duration(milliseconds: 600),
                            );
                          },
                          icon: Icon(
                            Icons.menu,
                            color: Color.fromARGB(255, 45, 98, 39),
                            size: 30,
                          ),
                        ),
                        Spacer(),
                        IconButton(
                          onPressed: () {
                            _cartController
                                .getUserCart(_authController.id.toString());
                            Get.to(
                              CartPage(),
                              transition: Transition.leftToRight,
                              duration: Duration(milliseconds: 600),
                            );
                          },
                          icon: Icon(
                            Icons.shopping_cart_outlined,
                            color: Color.fromARGB(255, 45, 98, 39),
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                    _productController.products.length == 0
                        ? Center(
                            child: Text(
                              'There are no products.',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                          )
                        : GridView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.7,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: _productController.products.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                        Get.to(
                          ProductDetails(),
                          arguments: [
                          _productController.products[index],
                          ],
                          transition: Transition.leftToRight,
                          duration: Duration(milliseconds: 600),
                        );
                      },
                              
                                child: Expanded(
                                  child: Container(
                                    padding: EdgeInsets.only(left: 5, right: 5, top: 20 ),
                                    width: MediaQuery.of(context).size.width * 0.5,
                                                    height: 214,
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 120,
                                          width: MediaQuery.of(context).size.width * 0.5,
                                                    
                                                    decoration: ShapeDecoration(
                                                        image: DecorationImage(
                                                            image: NetworkImage(  _productController.products[index].photoProduitPrincipale ?? '',),
                                                            fit: BoxFit.cover,
                                                        ),
                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                                                    ),
                                                ),
                                                          Container(
                                                       width: MediaQuery.of(context).size.width * 0.5,
                                                      height: 70,
                                                        decoration: ShapeDecoration(
                                                            color: Color(0xff96C291),
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.only(
                                                                    bottomLeft: Radius.circular(5),
                                                                    bottomRight: Radius.circular(5),
                                                                ),
                                                            ),
                                                        ),
                                                         child: Container(
                                                          padding: EdgeInsets.only(top: 10, left: 5, right: 5 ),
                                                           child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                            Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                SizedBox(
                                                                 
                                                                  child: Text(
                                                                        _productController.products[index].nomProduit ?? '',
                                                                      
                                                                      style: TextStyle(
                                                                          color: Colors.black,
                                                                          fontSize: 14,
                                                                          fontFamily: 'Metropolis',
                                                                          fontWeight: FontWeight.w600,
                                                                      ),
                                                                  ),
                                                                  
                                                                ),
                                                                
                                                                
                                                                Text(
                                                                 '${_productController.products[index].prixProduitAfter ?? ''} DT',
                                                                style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontSize: 12,
                                                                    fontFamily: 'Inter',
                                                                    fontWeight: FontWeight.w400,
                                                                ),
                                                            ) ,
                                                             Text(
                                                                 '${_productController.products[index].prixProduitBefore ?? ''} ',
                                                                style: TextStyle(
                                                                    decoration: TextDecoration.lineThrough,
                                                                    color: Colors.red,
                                                                    fontSize: 12,
                                                                    fontFamily: 'Inter',
                                                                    fontWeight: FontWeight.w400,
                                                                ),
                                                            ) ,
                                                                                                     
                                                                                                     
                                                              ],
                                                            ), 
                                                            
                                                            Container(
                                                                
                                                              width: 24,
                                                              height: 24,
                                                              decoration: ShapeDecoration(
                                                                  color: Colors.white,
                                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                                                              ),
                                                             child:  Align(
                                                             alignment: AlignmentDirectional.center,
                                                              child: Image.asset("lib/images/arrow.png", color: Colors.black,))
                                                           )
                                                           ]),
                                                         ),
                                                    ),
                                              
                                                 
                                      ],
                                    
                                    ),
                                  ),
                                )
                              
                                
                                
                                
                  
                          
                          
                            );
                            
                          },
                        )
                  ],
                ),
              ),
            ),
        );
  }
}
