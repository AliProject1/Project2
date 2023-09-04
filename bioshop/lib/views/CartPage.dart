import 'package:bioshop/views/BuyNow.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/authController.dart';
import '../controllers/cartController.dart';

import '../controllers/productController.dart';
import '../models/Product.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartController _cartController = Get.put(CartController());
  AuthController _authController = Get.put(AuthController());
  bool _isLoading = true;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  late SharedPreferences prefs;

  ProductController _productController = Get.put(ProductController());
  RxList<Product> userProducts = <Product>[].obs;


  @override
  void initState() {
    super.initState();
    _cartController.getUserCart(_authController.id.toString());
    fetchUserProducts();
  }

  Future<void> fetchUserProducts() async {
    try {
      if (_cartController.cart1 != null &&
          _cartController.cart1!.productIds != null) {
        List<Product> fetchedProducts = [];
        for (String productId in _cartController.cart1!.productIds!) {
          Product product =
              await _productController.getProductById(productId);
          fetchedProducts.add(product);
        }
        userProducts.assignAll(fetchedProducts);
      }
    } catch (e) {
      print('Error fetching products: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  Future<void> _showDeleteConfirmationDialog(Product product) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'Delete Product',
          style: TextStyle(
            color: Colors.black
          ),
        ),
        content: Text(
          'Are you sure you want to delete this product from your cart?',
          style: TextStyle(
            color: Colors.black
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.black
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              _cartController.deleteProductFromCart(
                _authController.id.toString(),
                product.sId.toString(),
              );
              Navigator.of(context).pop();
            },
            child: Text(
              'Delete',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
        ],
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(
          'Cart',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
         foregroundColor: Color(0xff96C291),
        backgroundColor:  Colors.white,
      ),
      backgroundColor:  Colors.white,
          
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : userProducts.isEmpty
              ? Center(
                  child: Text(
                    'Your cart is empty.',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: userProducts.length,
                  itemBuilder: (context, index) {
                    Product product = userProducts[index];
                    return Card(
                      elevation: 10,
                      color:   Color(0xff96C291),
                      child: ListTile(
                        leading: GestureDetector(
                          onTap: () {
                             Get.to(
                              BuyNow(),arguments: [product],transition: Transition.rightToLeft,duration: Duration(milliseconds: 600)
                             );
                          },
                          child: Image.network(
                            product.photoProduitPrincipale!,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: GestureDetector(
                          onTap: () {
                             Get.to(
                              BuyNow(),arguments: [product],transition: Transition.rightToLeft,duration: Duration(milliseconds: 600)
                             );
                            
                          },
                          child: Text(
                            product.nomProduit!,
                            style: TextStyle(
                              color:  Colors.white
                                 
                            ),
                          ),
                        ),
                        subtitle: GestureDetector(
                          onTap: () {
                             Get.to(
                              BuyNow(),arguments: [product],transition: Transition.rightToLeft,duration: Duration(milliseconds: 600)
                             );
                          },
                          child: Text(
                            'Price: ${product.prixProduitAfter!} DT',
                            style: TextStyle(
                              color:  Colors.white
                                 
                            ),
                          ),
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            _showDeleteConfirmationDialog(product);
                          },
                          icon: Icon(
                            Icons.delete,
                            color:Colors.red,
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
