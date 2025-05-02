import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'item.dart';
import 'item_articulo.dart';

class ListaArticulos extends StatefulWidget {
  const ListaArticulos({super.key});

  @override
  _ListaArticulosState createState() => _ListaArticulosState();
}

class _ListaArticulosState extends State<ListaArticulos> {
  final String apiUrl = "https://api.npoint.io/d65ed1dd37db6020f714";

  Future<List<Widget>> consultarArticulos() async {
    try {
      final respuesta = await http.get(Uri.parse(apiUrl));
      if (respuesta.statusCode == 200) {
        dynamic jsonDatos = jsonDecode(respuesta.body);
        List articulos = jsonDatos['articulos'] ?? [];
        List<Widget> articulosWidgets = [];

        for (var articulo in articulos) {
          final item = Item(
            precio: int.tryParse(articulo["precio"].toString()) ?? 0,
            articulo: articulo["articulo"] ?? "",
            descuento: int.tryParse(articulo["descuento"].toString()) ?? 0,
            urlimagen: articulo["urlimagen"] ?? "",
            valoracion: int.tryParse(articulo["valoracion"].toString()) ?? 0,
            descripcion: articulo["descripcion"] ?? "",
            calificaciones:
                int.tryParse(articulo["calificaciones"].toString()) ?? 0,
          );

          articulosWidgets.add(
            ItemArticuloWidget(item: item),
          );
        }
        return articulosWidgets;
      }
    } catch (e) {
      debugPrint("ERROR AL ENVIAR/RECIBIR SOLICITUD:");
      debugPrint(e.toString());
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          Text(
            'Lista Articulos',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ]),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: FutureBuilder<List<Widget>>(
              future: consultarArticulos(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text("No hay artículos disponibles"));
                } else {
                  return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: snapshot.data!.length,
                    separatorBuilder: (context, index) => const Divider(
                      color: Colors.grey,
                      height: 20,
                    ),
                    itemBuilder: (context, index) {
                      return snapshot.data![index];
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
