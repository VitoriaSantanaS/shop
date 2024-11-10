import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/cart_item_widget.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/models/order_list.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Cart cart = Provider.of<Cart>(context);
    final items = cart.items.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrinho'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Chip(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    label: Text(
                      'R\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const Spacer(),
                  CartButton(cart: cart)
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (ctx, i) => CartItemWidget(cartItem: items[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class CartButton extends StatefulWidget {
  const CartButton({
    super.key,
    required this.cart,
  });

  final Cart cart;

  @override
  State<CartButton> createState() => _CartButtonState();
}

class _CartButtonState extends State<CartButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return _isLoading ? const CircularProgressIndicator() : TextButton(
      onPressed: widget.cart.itemsCount == 0 ? null : () async {
        setState(() => _isLoading = true);
       
        await Provider.of<OrderList>(
          context,
          listen: false,
        ).addOrder(widget.cart);
       
        widget.cart.clear();
        setState(() => _isLoading = false);
      },
      child: Text(
        'COMPRAR',
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 15,
        ),
      ),
    );
  }
}
