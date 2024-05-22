import 'package:flutter/material.dart';
import 'package:app_flutter/pages/login_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Définition de la méthode registerUser
  Future<void> registerUser(String email, String password) async {
    final url = 'http://tnhtechnologies.cm/register.php';

    final response = await http.post(
      Uri.parse(url),
      body: {'email': email, 'password': password},
    );
    //print(response.body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data == 'Succes') {
        showDialog(context: context, builder: (context) => AlertDialog(
          title: const Text('Succes de l\'inscription'),
          content: const Text('Votre inscription a reussi'),
          actions: [
            TextButton(onPressed: (){
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
                child: const Text('OK'),
            )
          ],
        ),
        );

      } else {
        //print(data);
        // Erreur de connexion
       // return false;
      }
    }else{
      throw Exception("Failed to connect to server");
    }


  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inscription'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Mot de passe',
              ),
              obscureText: true,
            ),
            const SizedBox(
              height: 16.0,
            ),
            ElevatedButton(
                onPressed: () async {
                  final email = _emailController.text;
                  final password = _passwordController.text;
                  await registerUser(email, password);
                },
                child: const Text("Sinscrire"))
          ],
        ),
      ),
    );
  }
}
