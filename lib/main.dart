import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_api_imagenes/models/User.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<List<User>> _listadoUser;
  Future<List<User>> _getUsers() async {
    final response = await http.get("https://randomuser.me/api/?results=20");
    List<User> gifs = [];
    if (response.statusCode == 200) {
      //print(response.body); mostrar la informacion recibida por la api
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      //print(jsonData["data"]); navegar por el json
      for (var item in jsonData["results"]) {
        gifs.add(User(item["name"]["first"], item["name"]["last"],
            item["email"], item["phone"], item["picture"]["large"]));
      }
      return gifs;
    } else {
      throw Exception("Fallo la conexion");
    }
  }

  @override
  void initState() {
    super.initState();
    _listadoUser = _getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Api-Personas Jose Enrique Blas Esteban'),
        ),
        body: FutureBuilder(
          future: _listadoUser,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: _listUsers(snapshot.data),
              );
            } else if (snapshot.hasError) {
              print(snapshot.error);
              return Text("Erro");
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _listUsers(List<User> data) {
    List<Widget> users = [];
    for (var user in data) {
      users.add(
        Card(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(99.0),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(user.url),
                    fit: BoxFit.cover,
                  ),
                ),
                width: 150,
                height: 150,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Text(
                      "Nombre",
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      user.name + " " + user.lastName,
                      style: TextStyle(
                          fontSize: 15, color: Colors.deepOrangeAccent),
                    ),
                    Text(
                      "Email",
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      user.email,
                      style: TextStyle(fontSize: 15, color: Colors.blue),
                    ),
                    Text(
                      "Telefono",
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      user.phone,
                      style: TextStyle(fontSize: 15, color: Colors.green),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    }
    return users;
  }
}
