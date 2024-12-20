import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/app_drawer.dart';
import 'package:shop/components/order.dart';
import 'package:shop/models/order_list.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});
  @override
  Widget build(BuildContext context) {
    return 
      Scaffold(
        appBar: AppBar( title: const Text('Meus pedidos')),
        drawer: const AppDrawer(),
        body: 
          FutureBuilder(
            future: Provider.of<OrderList>(context, listen: false).loadOrders(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              else if (snapshot.error != null){ return const Center(child: Text('Ocorreu um erro!'));} 
              else {
              return Consumer<OrderList>(
                builder: (context, orders, child) { 
                  return 
                    orders.items.isEmpty ? const Center(child: Text('Você ainda não tem nenhum pedido!')) 
                    : ListView.builder(
                        itemCount: orders.itemsCount,
                        itemBuilder: (ctx, i) => OrderWidget(order: orders.items[i]),
                      );
                    }
                  );
                }
              },
            ),
        );
    }
  }
