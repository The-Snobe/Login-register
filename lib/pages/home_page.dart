import 'package:flutter/material.dart';
import 'package:app_flutter/pages/add_data_page.dart';
import 'package:app_flutter/pages/edit_data_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, String>> _listdata = [];
  Future _getdata() async{
    final url = 'https://tnhtech1.com/conn.php';
    try {
      final response = await http.get(
          Uri.parse(url),
          headers: {"Acces-Control_Allow_Origin": "*"});
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _listdata = data;
        });
      }
    }catch (e) {
      print(e);
    }
  }

  Future _deletedata( String matricule) async{
    final url = 'https://tnhtech1.com/delete.php';
    try {
      final response = await http.get(
          Uri.parse(url),
          headers: {"Acces-Control_Allow_Origin": "*"});
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);
        return true;
      }
      return false;
    }catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Accueil"),
      ),
      body: ListView.builder(
        itemCount: _listdata.length,
        itemBuilder: (context, index) {
          return Card(
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: ((context) => EditDataPage(
                          ListData: {
                            "id": _listdata[index]["id"],
                            "matricule": _listdata[index]['matricule'],
                            "nom": _listdata[index]['nom'],
                            "adresse": _listdata[index]['adresse'],
                          },
                        )),
                  ),
                );
              },
              child: ListTile(
                title: Text(_listdata[index]['nom']??''),
                subtitle: Text(_listdata[index]['adresse']??''),
                trailing: IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: ((context) {
                          return AlertDialog(
                            content: Text(
                                "Etes vous sur de vouloir supprimer les donnees ${_listdata[index]['nom']}?"),
                            actions: [
                              ElevatedButton(
                                  onPressed: () {
                                    String matricule = _listdata[index]['matricule'] ?? '';
                                    _deletedata(matricule).then((value) {
                                      if (value) {
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Les donnees ont ete supprimees avec succes")));
                                        _getdata();
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Echec de la suppression des donnees")));
                                      }
                                    });
                                  },
                                  child: Text("Oui")),
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Non")),
                            ],
                          );
                        }));
                  },
                  icon: const Icon(Icons.delete),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context,
           MaterialPageRoute(builder: (context)=> const AddData()));
        },
        child: const Icon(Icons.add),),
    );
  }
}


