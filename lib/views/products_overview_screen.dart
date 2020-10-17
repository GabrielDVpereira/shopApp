import 'package:flutter/material.dart';
import 'package:shop/widgets/productGrid.dart';

class ProductsOverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minha Loja'),
      ),
      body: ProductGrid(),
    );
  }
}
