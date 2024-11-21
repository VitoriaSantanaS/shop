import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop/models/order.dart';

class OrderWidget extends StatefulWidget {
  final Order order;
  const OrderWidget({
    required this.order,
    super.key,
  });

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final itemsHeight = (widget.order.products.length * 24.0) + 10;

    return 
      AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        height: _expanded ? itemsHeight + 90 : 90,
        child: 
          Card(
            child: 
              Column(
                children: [
                  ListTile(
                    title: Text('R\$ ${widget.order.total.toStringAsFixed(2)}'),
                    subtitle: Text(DateFormat('dd/MM/yyyy hh:mm').format(widget.order.date)),
                    trailing: 
                      IconButton(
                        onPressed: () => setState(() => _expanded = !_expanded),
                        icon: const Icon(Icons.expand_more),
                       ),
                     ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                    height: _expanded ? itemsHeight : 0,
                    child: 
                      ListView(
                        children: widget.order.products.map(
                        (product) {
                           return 
                             Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                 Text(product.name, style: const TextStyle(fontSize: 15)),
                                 Text(
                                   'x${product.quantity} R\$ ${product.price}',
                                   style: const TextStyle(fontSize: 15, color: Colors.grey),
                                   ),
                                 ],
                               );
                           }).toList(),
                       ),
                   ) 
                ],
              ),
            ),
        );
      }
    }
