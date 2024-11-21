import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/exceptions/auth_exception.dart';
import 'package:shop/models/auth.dart';

enum AuthMode { Signup, Login }

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> with SingleTickerProviderStateMixin {
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  bool _isLoading = false;
  AuthMode _authMode = AuthMode.Login;

  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  AnimationController? _controller;
  Animation<double>? _opacityAnimation;
  Animation<Offset>? _slideAnimation;

  bool _isLogin() => _authMode == AuthMode.Login;
  // bool _isSignup() => _authMode == AuthMode.Signup;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _opacityAnimation = Tween(
      begin: 0.0, 
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller!,
      curve: Curves.linear,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1.0), 
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _controller!,
      curve: Curves.linear,
    ));
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

  void _switchAuthMode() {
    setState(() {
      if (_isLogin()) {
        _authMode = AuthMode.Signup;
        _controller?.forward();
      } else {
        _authMode = AuthMode.Login;
        _controller?.reverse();
      }
    });
  }

  void _showErrorDialog(String msg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ocorreu um erro!'),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    final isValid = _formkey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }
    setState(() => _isLoading = true);

    _formkey.currentState?.save();
    Auth auth = Provider.of(context, listen: false);

    try {
      if (_isLogin()) {
        await auth.login(_authData['email']!, _authData['password']!);
      } else {
        await auth.signup(_authData['email']!, _authData['password']!);
      }
    } on AuthException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      _showErrorDialog('Ocorreu um erro inesperado!');
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
     return 
      Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: 
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeIn,
            padding: const EdgeInsets.all(16),
            height: _isLogin() ? 310 : 400,
            width: deviceSize.width * 0.75,
            child: 
              Form(
                key: _formkey,
                child: 
                  Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'E-mail'),
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (email) {_authData['email'] = email ?? '';},
                        validator: (emailValue) { 
                          final email = emailValue ?? '';
                          if (email.trim().isEmpty || !email.contains('@')) return 'Informe um e-mail valido';
                          return null; 
                          },
                        ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Senha'),
                        keyboardType: TextInputType.emailAddress,
                        obscureText: true,
                        controller: passwordController,
                        onSaved: (password) {_authData['password'] = password ?? '';},
                        validator: (passwordValue) { 
                          final password = passwordValue ?? '';
                          if (password.isEmpty || password.length < 5) return 'Informe uma senha valida';
                          return null;
                          },
                        ),
                      AnimatedContainer(
                        constraints: BoxConstraints(minHeight: _isLogin() ? 0 : 60, maxHeight: _isLogin() ? 0 : 120),
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.easeIn,
                        child: 
                          FadeTransition(
                            opacity: _opacityAnimation!,
                            child:
                              SlideTransition(
                                position: _slideAnimation!,
                                child: 
                                  TextFormField(
                                    decoration: const InputDecoration(
                                    labelText: 'Confirmação de senha'),
                                    keyboardType: TextInputType.emailAddress,
                                    obscureText: true,
                                    validator: _isLogin() ? null : (passwordValue) {
                                      final password = passwordValue ?? '';
                                      if (password.isEmpty || password != passwordController.text) return 'Senhas informadas não conferem!';
                                      return null;
                                      },
                                    ),
                                ),
                            ),
                        ),
                      const SizedBox(height: 20),
                    if (_isLoading) 
                      const CircularProgressIndicator() 
                    else 
                      ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                        backgroundColor: Theme.of(context).primaryColor),
                        child: 
                          Text(_authMode == AuthMode.Login ? 'ENTRAR' : 'REGISTRAR', style: const TextStyle(color: Colors.white))),
                      const Spacer(),
                      TextButton(
                        onPressed: _switchAuthMode, 
                        child: 
                          Text(_isLogin() ? 'DESEJA REGISTRAR?' : 'JÁ POSSUI CONTA?'),
                        )
                      ],
                    ),
                ),
            ),
        );
    }
  }

    