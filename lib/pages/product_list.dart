import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_authentication/blocs/productList/product_bloc.dart';
import 'package:flutter_bloc_authentication/models/favorites.dart';
import 'package:flutter_bloc_authentication/widgets/bottom_loader.dart';
import 'package:flutter_bloc_authentication/widgets/product_list_item.dart';
import 'package:injectable/injectable.dart';

import '../models/page.dart';

class ProductList extends StatelessWidget {
  final Stream<List<dynamic>> stream;
  final bool isFavoriteList;

  const ProductList(
      {Key? key, required this.stream, required this.isFavoriteList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<dynamic>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final products = snapshot.data!;
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              if (isFavoriteList) {
                final product = products[index] as Favorites;
                return ListTile(
                  title: Text(product.title!),
                  subtitle: Text(product.platform!),
                );
              } else {
                final product = products[index] as Product;
                return ListTile(
                  title: Text(product.title!),
                  subtitle: Text('Price: ${product.price}'),
                  trailing: Text(product.platform!),
                  leading: Image.network(
                      "http://localhost:8080/product/download/${product.image}"),
                );
              }
            },
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
