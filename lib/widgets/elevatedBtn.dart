import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ElevatedButtonCustom extends StatefulWidget {
  const ElevatedButtonCustom({super.key, required this.function});
 final Function function;

  @override
  State<ElevatedButtonCustom> createState() => _ElevatedButtonCustomState();
}

class _ElevatedButtonCustomState extends State<ElevatedButtonCustom> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child:  ElevatedButton(
        onPressed: (){
          widget.function();
        },
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: Colors.purple,
        ),
        child: Center(
          child: const Text(
            "Login",
            style: TextStyle(fontSize: 20,color: Colors.white),
          ),
        ),
      ),
    );
  }
}
