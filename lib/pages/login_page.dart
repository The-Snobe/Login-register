import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:app_flutter/pages/home_page.dart';
import 'package:app_flutter/pages/registration_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Définition de la méthode loginUser
  Future<String> loginUser(String email, String password) async {
    final url = 'http://tnhtechnologies.cm/login.php';

      final response = await http.post(
        Uri.parse(url),
        body: {'email': email, 'password': password},
      );
        print(response.body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data == 'Succes') {
          // Connexion réussie
          print(data);
          return 'Success';
        } else {
          print(data);
          // Erreur de connexion
          return 'Error';
        }
      }else{
        throw Exception(response.body);
      }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SCAC',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: Image.asset('assets/images/logo.png'),
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFFFFFFFF),
            Color.fromARGB(233, 237, 142, 142),
            const Color(0xFFFF9300),
          ],
          stops: [0.0, 0.40, 1.0],
        )),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [const Text('Connexion',
            style: TextStyle(fontSize: 24.0,fontWeight: FontWeight.bold,color: Colors.white ),),

            const SizedBox(height: 16.0),
            Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
              child: Padding(padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(controller: _emailController, decoration: const InputDecoration(labelText: 'E-mail'),),
                  const SizedBox(height: 16.0),
                  TextField(controller: _passwordController, decoration: const InputDecoration(labelText: 'Mot de passe', ),
                  obscureText: true,),
                  
                ],
              ),),
            ),
            ElevatedButton(onPressed: () async {
              final email = _emailController.text;
              final password = _passwordController.text;
              final result = await loginUser(email, password);
              if (result == 'Success') {
                showDialog(
                  context: context,
                  builder: (context) =>
                      AlertDialog(
                        title: const Text(' Connexion réussie'),
                        content: const Text('Votre connexion a réussi'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Close the dialog
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HomePage ()),
                              );
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                );
              } else {
                showDialog(context: context, builder: (context) =>
                    AlertDialog(title: const Text('Erreur'),
                      content: const Text('Votre connexon a réussi !'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        )
                      ],
                    ),
                );
              }
            },
              child: const Text('Se connecter'),
                //(){Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: ((context)=>HomePage())), (route) => false);}, child: const Text('se connecter'),
            ),

            const SizedBox(height: 16.0),

            TextButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const RegistrationPage(),));
            },child: const Text("S'inscrire"),)
            
            ],
          ),
        ),
      ),
    );

  }
}
