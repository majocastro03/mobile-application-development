import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lab06_rutas/vista_ruta1.dart';

class VistaLogin extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  VistaLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vista Login 1'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Ingrese datos',
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                String data = await _getData();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VistaRuta1(data: data),
                  ),
                );
              },
              child: Text('Ir a Vista 2 con push'),
            ),
            ElevatedButton(
              onPressed: () async {
                String data = await _getData();
                Navigator.pushNamed(context, '/vista2', arguments: data);
              },
              child: Text('Ir a Vista 2 con pushNamed'),
            ),
            ElevatedButton(
              onPressed: () async {
                String data = await _getData();
                Get.toNamed('/vista3', arguments: data);
              },
              child: Text('Ir a Vista 3 con Get.to'),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> _getData() async {
    await Future.delayed(Duration(seconds: 1));
    return _controller.text;
  }
}
