import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import '../model/UserModel.dart';
import '../widgets/elevatedBtn.dart';
import '../widgets/inputField.dart';
import 'HomePage.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          margin: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             Padding(
               padding: const EdgeInsets.symmetric(vertical: 8.0),
               child: Column(
                 children: [
                   Text(
                     "Welcome",
                     style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                   ),
                   Text("Enter your credential to login"),
                 ],
               ),
             ),
              Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
              ),

           Padding(
             padding: const EdgeInsets.symmetric(vertical: 8.0),
             child: Column(
               children: [
                 inputField( hintText: 'Email Address', prefixIcon: Icon(Icons.email), controller: _usernameController,),
                 const SizedBox(height: 10),
                 inputField( hintText: 'Password', prefixIcon: Icon(Icons.password), controller: _passwordController,),
                 const SizedBox(height: 10),

               ],
             ),
           ),

           ElevatedButtonCustom(function: (){
             _login(context);
           },),

            ],
          ),
        ),
      ),
    );
  }

  void _login(context) {
    String username = _usernameController.text;
    String password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      _showMessage('Please fill in all fields.');
      return;
    }

    if (password.length < 6) {
      _showMessage('Password must be at least 6 characters.');
      return;
    }

    if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$').hasMatch(username)) {
      _showMessage('Please enter a valid email address.');
      return;
    }

    _showMessage('');

    UserModel user = UserModel(username: username, password: password);
    String userJson = json.encode(user.toJson());

    _saveUserDataToFile(userJson, context);
  }



  void _saveUserDataToFile(String userJson,context)async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    File file = File('${appDocPath}/user_data${DateTime.now().microsecondsSinceEpoch}.json');
        file.writeAsStringSync(userJson);
    Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));

  }

  void _showMessage(String message) {
    setState(() {
      _errorMessage = message;
    });
  }
}