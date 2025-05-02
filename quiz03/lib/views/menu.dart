import 'package:flutter/material.dart';

class MenuPrincipal extends StatelessWidget {
  const MenuPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 300,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                  color: Colors.black26,
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: Offset(0, 5))
            ],
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade300, width: 1),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Botón de regresar
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const Spacer(), // Para centrar el título debajo del botón
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                "Menú principal",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              // Artículos
              _opcionesMenu(
                onTap: () => _navegarAArticulos(context, false),
                iconWidget: Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.shopping_cart,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                label: "Artículos",
                textColor: Colors.blue,
              ),
              const SizedBox(height: 20),
              // Ofertas
              _opcionesMenu(
                onTap: () => _navegarAArticulos(context, true),
                iconWidget: Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.discount,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                label: "Ofertas",
                textColor: Colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navegarAArticulos(BuildContext context, bool soloOfertas) {
    Navigator.pushNamed(context, soloOfertas ? '/ofertas' : '/articulos');
  }

  Widget _opcionesMenu({
    required VoidCallback onTap,
    required Widget iconWidget,
    required String label,
    required Color textColor,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(40),
          child: iconWidget,
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ],
    );
  }
}
