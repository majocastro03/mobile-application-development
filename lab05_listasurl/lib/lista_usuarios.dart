import 'package:flutter/material.dart';
import 'package:lab05_listasurl/item_usuario.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListaUsuarios extends StatefulWidget {
  @override
  _ListaUsuariosState createState() => _ListaUsuariosState();
}

class _ListaUsuariosState extends State<ListaUsuarios> {
  final String sUrl = "https://api.npoint.io/bffbb3b6b3ad5e711dd2";

  Future<Widget> consultarUsuarios() async {
    try {
      final oRespuesta = await http.get(Uri.parse(sUrl));
      if (oRespuesta.statusCode == 200) {
        dynamic oJsonDatos = jsonDecode(oRespuesta.body);
        List aItems = oJsonDatos['items'] ?? [];
        List<Widget> awItems = [];

        for (var usuario in aItems) {
          awItems.add(
            ItemUsuario(
              sImagen: usuario["imagen"] ?? "",
              sNombres: usuario["nombre"] ?? "",
              sCarrera: usuario["carrera"] ?? "",
              fPromedio: usuario["promedio"]?.toString() ?? "",
            ),
          );
        }
        return ListView(children: awItems);
      }
    } catch (e) {
      print("ERROR AL ENVIAR/RECIBIR SOLICITUD:");
      print(e);
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Lista de Usuarios"),
        ),
        body: FutureBuilder<Widget>(
          future: consultarUsuarios(),
          builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
            if (snapshot.hasData) {
              return snapshot.data ?? Container();
            }
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
