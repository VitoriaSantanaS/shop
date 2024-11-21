import 'package:flutter/material.dart';

class Badgee extends StatelessWidget {
  final Widget child;
  final String value;
  final Color? color;

  const Badgee({
    required this.child,
    required this.value,
    this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return 
      Stack(
        alignment: Alignment.center,
        children: [
        child,
          Positioned(
            right: 8,
            top: 6,
            child: 
              Container(
                padding: const EdgeInsets.all(2),
                constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                decoration: 
                  BoxDecoration(
                    borderRadius: BorderRadius.circular(20), 
                    color: color ?? Theme.of(context).colorScheme.secondary
                    ),
                child: 
                  Text(
                    value,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 10, color: Color.fromARGB(255, 255, 255, 255)),
                    ),
                ),
            )
          ],
        );
    }
  }
