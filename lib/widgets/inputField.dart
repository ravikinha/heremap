import 'package:flutter/material.dart';

class inputField extends StatelessWidget {
  const inputField({super.key, required this.hintText, required this.prefixIcon, required this.controller});
  final String hintText;
  final Icon prefixIcon;
  final TextEditingController controller;


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: controller,
          decoration: InputDecoration(
              hintText: "$hintText",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none
              ),
              fillColor: Colors.purple.withOpacity(0.1),
              filled: true,
              prefixIcon: prefixIcon),
        ),
        // const SizedBox(height: 10),
        // TextField(
        //   decoration: InputDecoration(
        //     hintText: "Password",
        //     border: OutlineInputBorder(
        //         borderRadius: BorderRadius.circular(18),
        //         borderSide: BorderSide.none),
        //     fillColor: Colors.purple.withOpacity(0.1),
        //     filled: true,
        //     prefixIcon: const Icon(Icons.password),
        //   ),
        //   obscureText: true,
        // ),

      ],
    );
  }
}
