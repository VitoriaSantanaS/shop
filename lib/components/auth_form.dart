import 'package:flutter/material.dart';

enum AuthMode { Signup, Login }

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  bool _isLoading = false;
  AuthMode _authMode = AuthMode.Login;

  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  bool _isLogin() => _authMode == AuthMode.Login;
  bool _isSignup() => _authMode == AuthMode.Signup;

  void _switchAuthMode() {
    setState(() {
      if (_isLogin()) {
        _authMode = AuthMode.Signup;
      } else {
        _authMode = AuthMode.Login;
      }
    });
  }


  void _submit() {
     
     final isValid = _formkey.currentState?.validate() ?? false;
     
      if (!isValid) {
        return;
      }
    setState (() =>_isLoading = true);
    
    _formkey.currentState?.save();

    if (_isLogin()) {
      // Logar
    } else {
      // Cadastrar
    }

    setState (() =>_isLoading = false);
    
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          padding: const EdgeInsets.all(16),
          height: _isLogin() ? 310 : 370,
          width: deviceSize.width * 0.75,
          child: Form(
              key: _formkey,
              child: Column(children: [
                TextFormField(
                    decoration: const InputDecoration(labelText: 'E-mail'),
                    keyboardType: TextInputType.emailAddress,
                    onSaved: (email) {
                      _authData['email'] = email ?? '';
                    },
                    validator: (emailValue) {
                      final email = emailValue ?? '';
                      if (email.trim().isEmpty || !email.contains('@')) {
                        return 'Informe um e-mail valido';
                      }
                      return null;
                    }),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Senha'),
                  keyboardType: TextInputType.emailAddress,
                  obscureText: true,
                  controller: passwordController,
                  onSaved: (password) {
                    _authData['password'] = password ?? '';
                  },
                  validator: (passwordValue) {
                    final password = passwordValue ?? '';
                    if (password.isEmpty || password.length < 5) {
                      return 'Informe uma senha valida';
                    }
                    return null;
                  },
                ),
                if (_isSignup())
                  TextFormField(
                      decoration: const InputDecoration(
                          labelText: 'Confirmação de senha'),
                      keyboardType: TextInputType.emailAddress,
                      obscureText: true,
                      validator: _isLogin()
                          ? null
                          : (passwordValue) {
                              final password = passwordValue ?? '';
                              if (password.isEmpty ||
                                  password != passwordController.text) {
                                return 'Senhas informadas não conferem!';
                              }
                              return null;
                            }),
                const SizedBox(height: 20),
                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 8),
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      child: Text(
                        _authMode == AuthMode.Login ? 'ENTRAR' : 'REGISTRAR',
                        style: const TextStyle(color: Colors.white),
                      )),
                const Spacer(),
                TextButton(
                    onPressed: _switchAuthMode,
                    child: Text(
                        _isLogin() ? 'DESEJA REGISTRAR?' : 'JÁ POSSUI CONTA?'))
              ])),
        ));
  }
}
