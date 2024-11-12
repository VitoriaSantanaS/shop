import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop/components/auth_form.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(  
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(215, 117, 255, 0.5),
                  Color.fromRGBO(255, 188, 117, 0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    height: 70, 
                    width: 280,
                    //cascade operator
                    transform: Matrix4.rotationZ(-10 * pi / 180)..translate(-10.0),
                    decoration: BoxDecoration(
                      color: Colors.deepOrange.shade900,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 8,
                          color: Colors.black26,
                          offset: Offset(0, 2))]),
                    alignment: Alignment.center,
                    child: const Text(
                      'Minha loja', 
                      style: TextStyle(
                        fontSize: 45,
                        fontFamily: 'Anton',
                        color: Colors.white,
                      )
                    ),
                  ),
                  const AuthForm(),
                ],
              ),
             ),
            ),
          )
        ],
      )
    );
  }
}