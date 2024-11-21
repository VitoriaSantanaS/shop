import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/auth.dart';
import 'package:shop/pages/auth_page.dart';
import 'package:shop/pages/products_overview_pags.dart';

class AuthOrHomePage extends StatefulWidget {
  const AuthOrHomePage({super.key});

  @override
  State<AuthOrHomePage> createState() => _AuthOrHomePageState();
}

class _AuthOrHomePageState extends State<AuthOrHomePage> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Auth auth = Provider.of<Auth>(context, listen: false);
    auth.tryAutoLogin().then((_) { setState(() => isLoading = false); });
  }

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of<Auth>(context);
    
    if (isLoading) return const Center(child: CircularProgressIndicator());
    
    return auth.isAuth ? const ProductsOverviewPags() : const AuthPage();
  }
}