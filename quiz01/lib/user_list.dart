import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:quiz01/user.dart';
import 'package:http/http.dart' as http;
import 'package:quiz01/user_profile.dart';

class UsersList extends StatefulWidget {
  const UsersList({super.key});

  @override
  State<UsersList> createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  Future<List<Users>> getUsuarios() async {
    String sUrl = "https://api.npoint.io/5cb393746e518d1d8880";
    try {
      List<Users> userList = [];
      final oResponse = await http.get(Uri.parse(sUrl),
          headers: {'Content-Type': 'application/json; charset=UTF-8'});
      dynamic oJsonData = jsonDecode(utf8.decode(oResponse.bodyBytes));
      print(oJsonData);
      for (final usuario in oJsonData["elementos"]) {
        userList.add(Users(
          nombreCompleto: usuario["nombreCompleto"] ?? 'N/A',
          profesion: usuario["profesion"] ?? '',
          universidad: usuario["estudios"][0]["universidad"] ?? '',
          urlImagen: usuario["urlImagen"] ?? '',
          edad: usuario["edad"]?.toString() ?? '',
          bachillerato: usuario["estudios"][0]["bachillerato"] ?? '',
        ));
      }
      return userList;
    } catch (e) {
      print("$e");
      rethrow;
    }
  }

  Widget userRow(Users user, BuildContext context) {
    return Container(
      height: 145,
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Row(
        children: [
          Image.network(
            user.urlImagen,
            height: 150,
            width: 150,
          ),
          const SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user.nombreCompleto),
              Text(user.profesion),
              Text(user.universidad),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserProfile(user: user),
                    ),
                  );
                },
                child: const Text("Ver perfil",
                    style: TextStyle(color: Color.fromARGB(255, 206, 39, 39))),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<Widget> userList(BuildContext context) async {
    try {
      final wUsers = await getUsuarios();
      ListView list = ListView.builder(
        padding: const EdgeInsets.all(18),
        itemCount: wUsers.length,
        itemBuilder: (BuildContext context, int index) {
          return userRow(wUsers[index], context);
        },
      );
      return list;
    } catch (e) {
      return const Text("No se encontraron datos");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Lista de Usuarios quiz 01 😞"),
        ),
        body: FutureBuilder<Widget>(
          future: userList(context),
          builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
            if (snapshot.hasData) {
              return snapshot.data ?? Container();
            }
            if (snapshot.hasError) {
              return Center(child: Text("${snapshot.error}"));
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
