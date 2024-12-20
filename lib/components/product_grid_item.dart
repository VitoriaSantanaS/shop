import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/auth.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/models/product.dart';
import 'package:shop/utils/app_routes.dart';

class ProductGridItem extends StatelessWidget {
  const ProductGridItem({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final double screenWidth = mediaQuery.size.width;
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);

    return 
      ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: 
          GridTile(
            footer: 
              GridTileBar(
                backgroundColor: const Color.fromARGB(179, 0, 0, 0),
                title: Text(product.name, textAlign: TextAlign.center, style: TextStyle(fontSize: screenWidth * 0.04)),
                leading: Consumer<Product>(builder: (ctx, product, _) {
                  return 
                    IconButton(
                      color: Theme.of(context).colorScheme.secondary,
                      onPressed: () {product.toggleFavorite(auth.token ?? '', auth.userId ?? '');},
                      icon: Icon(product.isFavorite ? Icons.favorite : Icons.favorite_border, size: screenWidth * 0.06),
                      );
                   }, 
                 ),
                trailing: 
                  IconButton(
                    color: Theme.of(context).colorScheme.secondary,
                    icon: Icon(Icons.shopping_cart, size: screenWidth * 0.06),
                    onPressed: () {
                      cart.addItem(product);
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Produto adicionado com sucesso!'),
                          duration: const Duration(seconds: 2),
                          action: 
                            SnackBarAction( 
                              label: 'DESFAZER',
                              onPressed: () => cart.removeSingleItem(product.id),
                              ),
                          ),
                        );
                      },
                    ),
                ),
            child: 
              GestureDetector(
                onTap: () {Navigator.of(context).pushNamed(AppRoutes.PRODUCT_DETAIL, arguments: product);},
                child: 
                  Hero(
                    tag: product.id,
                    child: FadeInImage(
                      placeholder: const AssetImage('assets/images/product-placeholder.png'),
                      image: NetworkImage(product.imageUrl),
                      fit: BoxFit.cover
                      ),
                  ),
                ),
            ),
        );
    }
  }
