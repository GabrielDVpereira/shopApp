import 'package:flutter/material.dart';

enum AuthMode { SignUp, Login }

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  Map<String, String> _authData = {"email": "", 'password': ""};
  AuthMode _authMode = AuthMode.Login;

  GlobalKey<FormState> _form = GlobalKey();
  bool _isLoading = false;
  final _passwordController = TextEditingController();

  void _submit() {
    if (!_form.currentState.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    _form.currentState.save();

    if (_authMode == AuthMode.Login) {
      //chamar login
    } else {
      // chamar signup
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.SignUp;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: EdgeInsets.all(16),
        height: _authMode == AuthMode.Login ? 290 : 371,
        width: deviceSize.width * 0.75,
        child: Form(
          key: _form,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: "E-mail"),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value.isEmpty || !value.contains('@')) {
                    return "Email inválido";
                  }
                  return null;
                },
                onSaved: (value) => _authData['email'] = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Senha"),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value.isEmpty || value.length < 4) {
                    return "Senha inválida";
                  }
                  return null;
                },
                onSaved: (value) => _authData['password'] = value,
                controller: _passwordController,
                obscureText: true,
              ),
              if (_authMode == AuthMode.SignUp)
                TextFormField(
                  decoration: InputDecoration(labelText: "Confirmar Senha"),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return "Senhas são diferentes";
                    }
                    return null;
                  },
                ),
              Spacer(),
              if (_isLoading)
                CircularProgressIndicator()
              else
                RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  color: Theme.of(context).primaryColor,
                  textColor: Theme.of(context).primaryTextTheme.button.color,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                  onPressed: _submit,
                  child: Text(
                    _authMode == AuthMode.Login ? 'Login' : 'Cadastrar',
                  ),
                ),
              FlatButton(
                onPressed: _switchAuthMode,
                child:
                    Text(_authMode == AuthMode.Login ? 'Cadastrar' : 'Login'),
              )
            ],
          ),
        ),
      ),
    );
  }
}