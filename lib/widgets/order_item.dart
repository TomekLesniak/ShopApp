import 'package:flutter/material.dart';
import 'dart:math';
import '../providers/orders.dart' as ord;
import 'package:intl/intl.dart';

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> with SingleTickerProviderStateMixin {
  var _expanded = false;

  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    // TODO: implement initState
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(children: [
        ListTile(
          title: Text('\$${widget.order.amount}'),
          subtitle:
              Text(DateFormat('dd/MM/yyyy').format(widget.order.dateTime)),
          trailing: IconButton(
            icon: AnimatedIcon(
              progress: _animationController,
              icon: AnimatedIcons.menu_arrow,
            ),
            onPressed: () {
              setState(() {
                _expanded = !_expanded;
                _expanded
                    ? _animationController.forward()
                    : _animationController.reverse();
              });
            },
          ),
        ),
        // if (_expanded)
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
          constraints: BoxConstraints(
              minHeight:
                  _expanded ? widget.order.products.length * 20 + 50.0 : 0,
              maxHeight: _expanded ? 200 : 0),
          padding: EdgeInsets.all(20),
          height: min((widget.order.products.length * 20 + 50.0), 200.0),
          child: ListView(
            children: widget.order.products
                .map((p) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          p.title,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${p.quantity}x \$${p.price}',
                          style: TextStyle(fontSize: 18),
                        )
                      ],
                    ))
                .toList(),
          ),
        ),
      ]),
    );
  }
}
