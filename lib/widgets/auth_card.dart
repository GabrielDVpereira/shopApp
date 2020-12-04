import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/exceptions/auth_exception.dart';
import 'package:shop/providers/auth.dart';

enum AuthMode { SignUp, Login }

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  Map<String, String> _authData = {"email": "", 'password': ""};
  AuthMode _authMode = AuthMode.Login;

  AnimationController _controller;
  Animation<double> _opacityAnimation;
  Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 200,
      ),
    );

    _opacityAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, -1.5),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _opacityAnimation.addListener(() {
      setState(() {});
    });
  }

  GlobalKey<FormState> _form = GlobalKey();
  bool _isLoading = false;
  final _passwordController = TextEditingController();

  void _showErrorDialog(String errorMsg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          "Ocorreu um erro!",
        ),
        content: Text(errorMsg),
        actions: [
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Fechar"),
          )
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_form.currentState.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    _form.currentState.save();

    Auth auth = Provider.of(context, listen: false);
    try {
      if (_authMode == AuthMode.Login) {
        await auth.signIn(_authData['email'], _authData['password']);
      } else {
        await auth.signUp(_authData['email'], _authData['password']);
      }
    } on AuthException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      _showErrorDialog("Erro inesperado.");
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.SignUp;
        _controller.forward();
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
        _controller.reverse();
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
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
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
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeIn,
                constraints: BoxConstraints(
                    minHeight: _authMode == AuthMode.SignUp ? 60 : 0,
                    maxHeight: _authMode == AuthMode.SignUp ? 120 : 0),
                child: SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: TextFormField(
                      decoration: InputDecoration(labelText: "Confirmar Senha"),
                      keyboardType: TextInputType.emailAddress,
                      obscureText: true,
                      validator: (value) {
                        if (value != _passwordController.text) {
                          return "Senhas são diferentes";
                        }
                        return null;
                      },
                    ),
                  ),
                ),
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
