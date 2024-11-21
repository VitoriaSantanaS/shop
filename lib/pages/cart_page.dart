import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/cart_button.dart';
import 'package:shop/components/cart_item_widget.dart';
import 'package:shop/models/cart.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Cart cart = Provider.of<Cart>(context);
    final items = cart.items.values.toList();

    return 
      Scaffold(
        appBar: AppBar(title: const Text('Carrinho')),
        body: 
          Column(
            children: [
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                child: 
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: 
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Text('Total', style: TextStyle(fontSize: 15)),
                          const SizedBox(width: 5),
                          Chip(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            label: 
                              Text(
                                'R\$${cart.totalAmount.toStringAsFixed(2)}',
                                 style: const TextStyle(color: Colors.white, fontSize: 15),
                              ),
                            ),
                          const Spacer(),
                          CartButton(cart: cart)
                          ],
                        ),
                    ),
                ),
              Expanded(
                child: 
                  ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (ctx, i) => CartItemWidget(cartItem: items[i]),
                    ),
                ),
             ],
           ),
        );
    }
  }

