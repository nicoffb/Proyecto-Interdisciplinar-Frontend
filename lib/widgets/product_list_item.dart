import 'package:flutter/material.dart';
import 'package:flutter_bloc_authentication/models/page.dart';

class ProductListItem extends StatelessWidget {
  const ProductListItem({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Material(
      child: ListTile(
        leading: Text('${product}', style: textTheme.bodySmall),
        title: Text(product.title!),
        isThreeLine: true,
        subtitle: Text(product.description!),
        dense: true,
      ),
    );
  }
}
