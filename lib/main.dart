import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/models/order_list.dart';
import 'package:shop/models/product_list.dart';
import 'package:shop/pages/auth_page.dart';
import 'package:shop/pages/cart_page.dart';
import 'package:shop/pages/order_pages.dart';
import 'package:shop/pages/product_detail_page.dart';
import 'package:shop/pages/product_form_page.dart';
import 'package:shop/pages/pruducts_page.dart';
import 'package:shop/utils/app_routes.dart';
import '../pages/products_overview_pags.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color.fromARGB(255, 139, 68, 159);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProductList(),
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (_) => OrderList(),
        ),
      ],
      child: MaterialApp(
        title: 'Minha loja',
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            iconTheme: IconThemeData(color: Colors.white),
            actionsIconTheme: IconThemeData(color: Colors.white),
            color: primaryColor,
            titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
          ),
          colorScheme: ColorScheme.fromSeed(
            errorContainer: const Color.fromARGB(137, 212, 71, 71),
            seedColor: primaryColor,
            primary: primaryColor,
            secondary: const Color.fromARGB(255, 233, 205, 112),
          ),
          fontFamily: 'Lato',
        ),
        routes: {
          AppRoutes.AUTH: (ctx) => const AuthPage(),
          AppRoutes.HOME: (ctx) => const ProductsOverviewPags(),
          AppRoutes.PRODUCT_DETAIL: (ctx) => const ProductDetailPage(),
          AppRoutes.CART: (ctx) => const CartPage(),
          AppRoutes.ORDER: (ctx) => const OrderPage(),
          AppRoutes.PRODUCTS: (ctx) => const ProductsPage(),
          AppRoutes.PRODUCT_FORM: (ctx) => const ProductFormPage(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
