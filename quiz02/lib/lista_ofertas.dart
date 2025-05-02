import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'item.dart';
import 'item_articulo.dart';

class ListaOfertas extends StatefulWidget {
  const ListaOfertas({super.key});

  @override
  _ListaOfertasState createState() => _ListaOfertasState();
}

class _ListaOfertasState extends State<ListaOfertas> {
  final String apiUrl = "https://api.npoint.io/d65ed1dd37db6020f714";

  Future<List<Widget>> consultarOfertas() async {
    try {
      final respuesta = await http.get(Uri.parse(apiUrl));
      if (respuesta.statusCode == 200) {
        dynamic jsonDatos = jsonDecode(respuesta.body);
        List articulos = jsonDatos['articulos'] ?? [];
        List<Widget> ofertasWidgets = [];

        for (var articulo in articulos) {
          int precio = int.tryParse(articulo["precio"].toString()) ?? 0;
          int descuento = int.tryParse(articulo["descuento"].toString()) ?? 0;

          if (descuento > 0) {
            final item = Item(
              precio: precio,
              articulo: articulo["articulo"] ?? "",
              descuento: descuento,
              urlimagen: articulo["urlimagen"] ?? "",
              valoracion: int.tryParse(articulo["valoracion"].toString()) ?? 0,
              descripcion: articulo["descripcion"] ?? "",
              calificaciones:
                  int.tryParse(articulo["calificaciones"].toString()) ?? 0,
            );

            ofertasWidgets.add(ItemArticuloWidget(item: item));
          }
        }
        return ofertasWidgets;
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
        title: const Text(
          'Lista de Ofertas',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Widget>>(
              future: consultarOfertas(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: \${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text("No hay ofertas disponibles"));
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
