import 'package:flutter/material.dart';
import 'package:quiz01/user.dart';

class UserProfile extends StatelessWidget {
  final Users user;
  const UserProfile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Información de ${user.nombreCompleto}"),
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(),
                child: Image.network(
                  user.urlImagen,
                  height: 200,
                  width: 200,
                ),
              ),
              Text(user.nombreCompleto),
              Text(user.profesion),
              Text(user.edad),
              Text(user.universidad),
              Text(user.bachillerato),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("< Regresar",
                    style: TextStyle(color: Color.fromARGB(255, 29, 73, 218))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
