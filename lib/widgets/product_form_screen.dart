import 'package:flutter/material.dart';

class FormScreen extends StatefulWidget {
  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _priceFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Formulário Produto')),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
            child: ListView(children: [
          TextFormField(
            decoration: InputDecoration(labelText: 'Título'),
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(_priceFocusNode);
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Preço'),
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            focusNode: _priceFocusNode,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Título'),
            textInputAction: TextInputAction.next,
          ),
        ])),
      ),
    );
  }
}
