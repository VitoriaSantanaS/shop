import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/exceptions/http_exception.dart';
import 'package:shop/models/product.dart';
import 'package:shop/utils/constants.dart';

class ProductList with ChangeNotifier {
  final String _token;
  final String _userId;
  // ignore: prefer_final_fields
  List<Product> _items = [];

  ProductList([this._token = '',  this._userId = '', this._items = const []]);
  
  List<Product> get items => [..._items];
  List<Product> get favoriteItems => _items.where((product) => product.isFavorite).toList();

  int get itemsCount { return _items.length; }

  Future<void> addProduct(Product product) 
    async {
      final response = await http.post(
        Uri.parse('${Constants.PRODUCT_BASE_URL}.json?auth=$_token'),
        body: jsonEncode(
          {
           'name': product.name,
           'description': product.description,
           'price': product.price,
           'imageUrl': product.imageUrl,
          },
        ),
      );

    final id = jsonDecode(response.body)['name'];
    
    _items.add(
      Product(
        id: id,
        name: product.name,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      ),
    );
    notifyListeners();
  }

  Future<void> saveProduct(Map<String, Object> data) {
    bool hasId = data['id'] != null;

    final product = 
      Product(
        id: hasId ? data['id'] as String : Random().nextDouble().toString(),
        name: data['name'] as String,
        description: data['description'] as String,
        price: data['price'] as double,
        imageUrl: data['imageUrl'] as String,
      );

    if (hasId) { return updateProduct(product); } 
    else { return addProduct(product); }
  }

  Future<void> updateProduct(Product product) 
    async {
      final index = _items.indexWhere((existingProduct) => existingProduct.id == product.id);

      if (index >= 0) {
        await http.patch(
          Uri.parse('${Constants.PRODUCT_BASE_URL}${product.id}.json?auth=$_token'),
          body: jsonEncode(
            {
              'name': product.name,
              'description': product.description,
              'price': product.price,
              'imageUrl': product.imageUrl,
            },
          ),
        );
      _items[index] = product;
      notifyListeners();
    }

    return Future.value();
  }

  Future<void> removeProduct(Product product) 
    async {
      final index = _items.indexWhere((existingProduct) => existingProduct.id == product.id);

      if (index >= 0) {
        final product = _items[index];
      
        _items.remove(product);
        notifyListeners();

        final response = await http.delete(Uri.parse('${Constants.PRODUCT_BASE_URL}${product.id}.json?auth=$_token'));

        if (response.statusCode >= 400) {
        
          _items.insert(index, product);
          notifyListeners();

          throw 
            HttpExceptionApplication( 
              msg: 'Não foi possível excluir o produto.', 
              statusCode: response.statusCode
            );
          } 
        }
      }

  Future<void> loadProducts() 
    async {
      _items.clear();

       final response = await http.get(Uri.parse('${Constants.PRODUCT_BASE_URL}.json?auth=$_token'));

      if (response.body == 'null') return;

      final favoriteResponse = await http.get( Uri.parse('${Constants.USER_FAVORITES_URL}/$_userId.json?auth=$_token') );

      final Map<String, dynamic> favoriteData = favoriteResponse.body == 'null' ? {} : jsonDecode(favoriteResponse.body);
 
      final Map<String, dynamic> data = jsonDecode(response.body);

      data.forEach((productId, productData) {
        final isFavorite = favoriteData[productId]?['favorite'] ?? false;
        _items.add(
          Product(
          id: productId,
          name: productData['name'],
          description: productData['description'],
          price: productData['price'],
          imageUrl: productData['imageUrl'],
          isFavorite: isFavorite,
         ),
        );
       },
      );
      notifyListeners();
    }
  }

  // bool _showFavoriteOnly = false;

  // List<Product> get items {
  //   if (_showFavoriteOnly) {
  //     return [..._items.where((product) => product.isFavorite)];
  //   }
  //   return [..._items];
  // }

  // void showFavoriteOnly() {
  //   _showFavoriteOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoriteOnly = false;
  //   notifyListeners();
  // }