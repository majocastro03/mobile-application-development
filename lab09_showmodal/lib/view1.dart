import 'package:flutter/material.dart';

class View1 extends StatefulWidget {
  const View1({super.key});

  @override
  State<View1> createState() => _View1State();
}

class _View1State extends State<View1> {
  String? selectedOption;

  _showOptionsModal(BuildContext context) {
    String? optionSel = selectedOption;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Text(
                    'Selecciona una opción',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ...['Amarillo', 'Azul', 'Rojo', 'Verde', 'Naranja']
                      .map((option) {
                    return RadioListTile<String>(
                      title: Text(option),
                      value: option,
                      groupValue: optionSel,
                      onChanged: (value) {
                        setModalState(() {
                          optionSel = value;
                        });
                      },
                    );
                  }).toList(),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (optionSel != null) {
                        setState(() {
                          selectedOption = optionSel;
                        });
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text(
                      'Aceptar',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vista 1')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _showOptionsModal(context),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text(
                'Mostrar opciones',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            if (selectedOption != null)
              Column(
                children: [
                  const Text(
                    'Opción seleccionada:',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    selectedOption!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              )
          ],
        ),
      ),
    );
  }
}
