import 'package:flutter/material.dart';
import 'item.dart';

class FichaArticulo extends StatelessWidget {
  final Item item;

  const FichaArticulo({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalles del Artículo"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 150,
                height: 150,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: item.urlimagen.isNotEmpty
                      ? Image.network(
                          item.urlimagen,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.blue[100],
                              child: const Icon(
                                Icons.shopping_cart,
                                size: 80,
                                color: Colors.blue,
                              ),
                            );
                          },
                        )
                      : Container(
                          color: Colors.blue[100],
                          child: const Icon(
                            Icons.shopping_cart,
                            size: 80,
                            color: Colors.blue,
                          ),
                        ),
                ),
              ),
            ),
            Text(
              item.articulo,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                Text(
                  item.descuento > 0
                      ? "\$${_precioConDescuento().toString()}"
                      : "\$${item.precio.toString()}",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                if (item.descuento > 0) ...[
                  const SizedBox(width: 8),
                  Text(
                    "\$${item.precio}",
                    style: const TextStyle(
                      fontSize: 16,
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      "${item.descuento}% OFF",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _valoracion(
                    item.valoracion), // Valoración con número y estrellas
                const SizedBox(width: 8),
                Text(
                  "(${item.calificaciones} calificaciones)",
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  int _precioConDescuento() {
    return (item.precio * (1 - item.descuento / 100)).toInt();
  }

  Widget _valoracion(int valoracionEntera) {
    double valoracionDecimal = valoracionEntera / 10;
    int valoracionRedondeada =
        (valoracionDecimal - valoracionDecimal.floor() >= 0.6)
            ? valoracionDecimal.ceil()
            : valoracionDecimal.floor();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          valoracionDecimal.toStringAsFixed(1),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(width: 8),
        ...List.generate(5, (index) {
          return Icon(
            index < valoracionRedondeada ? Icons.star : Icons.star_border,
            color: Colors.amber,
            size: 20,
          );
        }),
      ],
    );
  }
}
