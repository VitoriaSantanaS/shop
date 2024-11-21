import 'package:flutter/material.dart';
import 'package:shop/models/product.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key,});
  @override
  Widget build(BuildContext context) {
    final Product product = ModalRoute.of(context)!.settings.arguments as Product;
    
    return 
      Scaffold(
        body: 
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 400,
                pinned: true,
                flexibleSpace: 
                  FlexibleSpaceBar(
                    centerTitle: true,
                    background: 
                      Stack(
                        fit: StackFit.expand,
                        children: [
                           Hero(tag: product.id, child: Image.network(product.imageUrl, fit: BoxFit.cover)),
                           const DecoratedBox(
                             decoration: 
                               BoxDecoration(
                                gradient: 
                                  LinearGradient(
                                    begin: Alignment(0, 0.8),
                                    end: Alignment(0, 0),
                                    colors: [
                                     Color.fromRGBO(0, 0, 0, 0.6),
                                     Color.fromRGBO(0, 0, 0, 0),
                                  ],
                                )
                              ),
                            ),
                          ],
                        ),
                    title: Text(product.name, style: const TextStyle(color: Colors.white, fontSize: 15)),
                  ),
                ),
              SliverList(
                delegate: 
                  SliverChildListDelegate([
                    const SizedBox(height: 10),
                    Text(
                      'R\$ ${product.price}',
                      textAlign: TextAlign.center,
                      style: const TextStyle( color: Colors.grey, fontSize: 20),
                     ),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text( product.description, textAlign: TextAlign.center),
                    ),
                  ],
                ),
              ),
            ],
          ),
      );
    }
  }
