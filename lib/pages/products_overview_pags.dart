import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/app_drawer.dart';
import 'package:shop/components/badgee.dart';
import 'package:shop/components/product_grid.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/models/product_list.dart';
import 'package:shop/utils/app_routes.dart';

enum FilterOptions {
  favorites,
  all,
}

class ProductsOverviewPags extends StatefulWidget {
  const ProductsOverviewPags({super.key});

  @override
  State<ProductsOverviewPags> createState() => _ProductsOverviewPagsState();
}

class _ProductsOverviewPagsState extends State<ProductsOverviewPags> {
  bool _showFavoriteOnly = false;
  bool _isLoading = true;

 @override
  void initState() {
    super.initState();
    Provider.of<ProductList>(context, listen: false).loadProducts().then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minha Loja'),
        actions: [
          PopupMenuButton(
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: FilterOptions.favorites,
                child: Text('Somente Favoritos'),
              ),
              const PopupMenuItem(
                value: FilterOptions.all,
                child: Text('Todos'),
              )
            ],
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.favorites) {
                  _showFavoriteOnly = true;
                } else {
                  _showFavoriteOnly = false;
                }
              });
            },
          ),
          Consumer<Cart>(
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.CART);
              },
              icon: const Icon(Icons.shopping_cart),
            ),
            builder: (context, cart, child) =>
                Badgee(value: cart.itemsCount.toString(), child: child!),
          )
        ],
        centerTitle: true,
      ),
      body: _isLoading ? const Center(child: CircularProgressIndicator()) 
      : ProductGrid(showFavoriteOnly: _showFavoriteOnly),
      drawer: const AppDrawer(),
    );
  }
}

//outra opcao
//  Badgee(
//               value: '${Provider.of<Cart>(context).itemsCount}',
//               child: IconButton(
//                   onPressed: () {}, icon: const Icon(Icons.shopping_cart)))
//         ],
