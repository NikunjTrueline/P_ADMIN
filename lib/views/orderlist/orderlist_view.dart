import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../firebase/firebase_service.dart';
import '../../model/order.dart';
// Update this with the path to your Order model

class OrderListView extends StatefulWidget {
  @override
  _OrderListViewState createState() => _OrderListViewState();
}

class _OrderListViewState extends State<OrderListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Order List',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent.shade100,
      ),
      backgroundColor: Colors.grey.shade100,
      body: StreamBuilder<List<Order>>(
        stream: FirebaseService().orderStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error loading orders'));
          }

          List<Order> orders = snapshot.data ?? [];

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              Order order = orders[index];
              return Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
                child: Card(
                  color: Colors.blue.shade50,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(10),
                    title: Text(
                      'Order ID: ${order.orderId}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                        'User ID : ${order.userId}\nPayment ID : ${order.paymentId}\nTotal Price : ${order.totalPrice}\nStatus: ${order.status}\nShpping Address : ${order.shippingAddress!.address}, ${order.shippingAddress!.addressLine1}, ${order.shippingAddress!.addressLine2}, ${order.shippingAddress!.city}, ${order.shippingAddress!.pincode}, ${order.shippingAddress!.state}\nOrder Date : ${formatMilliseconds(order.orderDate!)}'),
                    onTap: () => showUpdateStatusDialog(context, order),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String formatMilliseconds(int milliseconds) {
    // Convert the milliseconds to a DateTime object
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(milliseconds);

    // Create a DateFormat object with the desired format
    DateFormat formatter = DateFormat('dd-MM-yyyy HH:mm:ss');

    // Format the DateTime object to a string
    return formatter.format(dateTime);
  }

  void showUpdateStatusDialog(BuildContext context, Order order) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Update Order Status"),
          content: const Text("Do you want to mark this order as delivered?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text("Done"),
              onPressed: () {
                FirebaseService()
                    .updateOrderStatus(order.orderId!, "delivered")
                    .then((_) {
                  Navigator.of(context).pop();
                  // The StreamBuilder will automatically update the UI
                }).catchError((error) {
                  print(error); // Handle the error properly
                });
              },
            ),
          ],
        );
      },
    );
  }
}
