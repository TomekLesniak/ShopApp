import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart' show Cart;
import '../widgets/cart_item.dart';
import '../providers/orders.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cart-screen';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var _processingOrder = false;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                          color: Theme.of(context)
                              .primaryTextTheme
                              .headline6
                              .color),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  _processingOrder
                      ? Container(
                          child: Padding(
                          padding: const EdgeInsets.only(left: 25, right: 10),
                          child: CircularProgressIndicator(),
                        ))
                      : FlatButton(
                          child: Text('ORDER NOW'),
                          onPressed: () async {
                            setState(() {
                              _processingOrder = true;
                            });
                            try {
                              await Provider.of<Orders>(context, listen: false)
                                  .addOrder(cart.items.values.toList(),
                                      cart.totalAmount);
                              cart.clearCart();
                            } catch (err) {
                              Scaffold.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Failed to send order'),
                                ),
                              );
                            } finally {
                              setState(() {
                                _processingOrder = false;
                              });
                            }
                          },
                          textColor: Theme.of(context).primaryColor,
                        ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
              child: ListView.builder(
            itemBuilder: (ctx, index) {
              return CartItem(
                  cart.items.values.toList()[index].id,
                  cart.items.values.toList()[index].price,
                  cart.items.values.toList()[index].quantity,
                  cart.items.values.toList()[index].title,
                  cart.items.keys.toList()[index]);
            },
            itemCount: cart.itemsCount,
          ))
        ],
      ),
    );
  }
}
