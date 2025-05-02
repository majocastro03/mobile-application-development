import 'package:flutter/material.dart';

class ItemUsuario extends StatelessWidget {
  final String sImagen;
  final String sNombres;
  final String sCarrera;
  final String fPromedio;

  const ItemUsuario({
    required this.sImagen,
    required this.sNombres,
    required this.sCarrera,
    required this.fPromedio,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          sImagen,
          width: 250,
          height: 150,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(sNombres),
            Text(sCarrera),
            Text(fPromedio),
          ],
        ),
      ],
    );
  }
}
