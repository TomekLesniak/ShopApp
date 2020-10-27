import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';


class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Future _ordersFuture;

  Future _obtainOrdersFuture() {
    return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }

  @override
  void initState() {
    super.initState();
    _ordersFuture = _obtainOrdersFuture();
  }

  @override
  Widget build(BuildContext context) {
    // final orders = Provider.of<Orders>(context);
    return Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
          title: Text('Your Orders'),
        ),
        body: FutureBuilder(
            future:
                _ordersFuture,
            builder: (ctx, dataSnapshot) {
              if (dataSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (dataSnapshot.error != null) {
                return Center(
                  child: Text('error'),
                );
              } else {
                return Consumer<Orders>(
                  builder: (ctx, orders, child) => ListView.builder(
                      itemCount: orders.orders.length,
                      itemBuilder: (ctx, index) {
                        return OrderItem(orders.orders[index]);
                      }),
                );
              }
            }));
  }
}
