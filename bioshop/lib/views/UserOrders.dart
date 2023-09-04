
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/orderController.dart';


class UserOrders extends StatefulWidget {
  const UserOrders({Key? key}) : super(key: key);

  @override
  State<UserOrders> createState() => _UserOrdersState();
}

class _UserOrdersState extends State<UserOrders> {
  final OrderController orderController = Get.put(OrderController());
    late SharedPreferences prefs;



  @override
  void initState() {
    super.initState();
    orderController.fetchUserOrders();
  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Obx(
        () {
          if (orderController.isdatalod.value) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (orderController.order != null) {
            return ListView.builder(
              itemCount: orderController.order!.data!.length,
              itemBuilder: (BuildContext context, int index) {
                final order = orderController.order!.data![index];
                
                Text statusText = order.status == 'pending'
                    ? Text('On the way', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500,))
                    : Text('Delivered', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500,));
              
                return Card(
                  elevation: 20,
                  child: Container(
                    color: Color(0xff96C291),
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        GestureDetector(
  onTap: () {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: SizedBox(
            width: 200,
            height: 200,
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
          width: 60,
          height: 60,
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
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                            "\$ ${order.pricep!}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                         Spacer(),
                    
                     
                        statusText,
                          SizedBox(width: 15),
                       
                        
                  
                      ],
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
        },
      ),
    );
  }
}
