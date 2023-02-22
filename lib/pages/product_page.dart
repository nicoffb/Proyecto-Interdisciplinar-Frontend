import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_authentication/blocs/productList/product_bloc.dart';
import 'package:flutter_bloc_authentication/pages/product_list.dart';

//import 'package:http/http.dart' as http;

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: BlocProvider(
        create: (_) =>
            ProductBloc(/*httpClient: http.Client()*/)..add(ProductFetched()),
        child: ProductsList(),
      ),
    );
  }
}
