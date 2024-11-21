import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/auth.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/models/order_list.dart';
import 'package:shop/models/product_list.dart';
import 'package:shop/pages/auth_or_home_page.dart';
import 'package:shop/pages/cart_page.dart';
import 'package:shop/pages/order_pages.dart';
import 'package:shop/pages/product_detail_page.dart';
import 'package:shop/pages/product_form_page.dart';
import 'package:shop/pages/pruducts_page.dart';
import 'package:shop/utils/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color.fromARGB(255, 139, 68, 159);

    return 
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => Auth()),
          ChangeNotifierProxyProvider<Auth, ProductList>(
            create: (_) => ProductList(),
            update: (ctx, auth, previous) {
              return ProductList(auth.token ?? '', auth.userId ?? '', previous?.items ?? []);
            },
          ),
        ChangeNotifierProxyProvider<Auth, OrderList>(
          create: (_) => OrderList(),
          update: (context, auth, previous) {
            return OrderList(auth.token ?? '', auth.userId ?? '', previous?.items ?? []);
            },
          ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
          ),
         ],
        child: 
          MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Minha loja',
            theme: 
              ThemeData(
                fontFamily: 'Lato',
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
            ),
            routes: 
             {
               AppRoutes.AUTH_OR_HOME: (ctx) => const AuthOrHomePage(),
               AppRoutes.PRODUCT_DETAIL: (ctx) => const ProductDetailPage(),
               AppRoutes.CART: (ctx) => const CartPage(),
               AppRoutes.ORDER: (ctx) => const OrderPage(),
               AppRoutes.PRODUCTS: (ctx) => const ProductsPage(),
               AppRoutes.PRODUCT_FORM: (ctx) => const ProductFormPage(),
             },
            ),
        );
    }  
  }
