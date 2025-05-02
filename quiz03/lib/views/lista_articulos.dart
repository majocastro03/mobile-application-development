import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/item.dart';
import '../widgets/item_articulo.dart';

class ListaArticulos extends StatefulWidget {
  final bool soloOfertas;
  final String titulo;
  final Color colorTitulo;

  const ListaArticulos({
    super.key,
    this.soloOfertas = false,
    this.titulo = 'Lista de Artículos',
    this.colorTitulo = Colors.blue,
  });

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
          // Utilizamos el factory Item.fromJson para crear el objeto Item
          final item = Item.fromJson(articulo);

          // Si soloOfertas es true, solo añadimos artículos con descuento > 0
          // Si soloOfertas es false, añadimos todos los artículos
          if (!widget.soloOfertas ||
              (widget.soloOfertas && item.descuento > 0)) {
            articulosWidgets.add(ItemArticuloWidget(item: item));
          }
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
        title: Text(
          widget.titulo,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: widget.colorTitulo,
          ),
        ),
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
                  return Center(
                    child: Text(widget.soloOfertas
                        ? "No hay ofertas disponibles"
                        : "No hay artículos disponibles"),
                  );
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
