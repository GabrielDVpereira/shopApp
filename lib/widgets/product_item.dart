import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/product.dart';
import 'package:shop/providers/products.dart';
import 'package:shop/utils/appRoutes.dart';

class ProductItem extends StatelessWidget {
  final Product product;
  ProductItem(this.product);
  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    void confirmDelete() async {
      bool confirmDelete = await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Tem certeza?'),
          content: Text('Quer remover esse produto?'),
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.of(ctx).pop(false);
              },
              child: Text('Não'),
            ),
            FlatButton(
              onPressed: () {
                Navigator.of(ctx).pop(true);
              },
              child: Text('Sim'),
            ),
          ],
        ),
      );

      if (confirmDelete) {
        try {
          await Provider.of<Products>(context, listen: false)
              .deleteProduct(product.id);
        } catch (err) {
          print('aaaaaaaaaaaaaaaa');
          scaffold.showSnackBar(
            SnackBar(
              content: Text(err.toString()),
            ),
          );
        }
      }
    }

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      title: Text(product.title),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(AppRoutes.PRODUCT_FORM, arguments: product);
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              color: Theme.of(context).errorColor,
              onPressed: confirmDelete,
            ),
          ],
        ),
      ),
    );
  }
}
