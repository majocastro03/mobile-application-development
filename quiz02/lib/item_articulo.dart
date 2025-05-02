import 'package:flutter/material.dart';
import 'ficha_articulo.dart';
import 'item.dart';
import 'package:get/get.dart';

class ItemArticuloWidget extends StatelessWidget {
  final Item item;

  const ItemArticuloWidget({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => FichaArticulo(item: item));
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 80,
              child: item.urlimagen.isNotEmpty
                  ? Image.network(
                      item.urlimagen,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.blue[100],
                          child: const Icon(
                            Icons.shopping_cart,
                            size: 40,
                            color: Colors.blue,
                          ),
                        );
                      },
                    )
                  : Container(
                      color: Colors.blue[100],
                      child: const Icon(
                        Icons.shopping_cart,
                        size: 40,
                        color: Colors.blue,
                      ),
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.articulo,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        item.descuento > 0
                            ? "\$${_precioConDescuento().toString()}"
                            : "\$${item.precio.toString()}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (item.descuento > 0)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green[100],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            "${item.descuento}% OFF",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.green[800],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _valoracion(item.valoracion),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _precioConDescuento() {
    return (item.precio * (1 - item.descuento / 100)).toInt();
  }

  Widget _valoracion(int valoracionEntera) {
    // Convertir la valoración entera a decimal dividiendo entre 10
    double valoracionDecimal = valoracionEntera / 10;

    // Redondear hacia arriba si el decimal es >= 0.6, hacia abajo si es < 0.6
    int valoracionRedondeada =
        (valoracionDecimal - valoracionDecimal.floor() >= 0.6)
            ? valoracionDecimal.ceil()
            : valoracionDecimal.floor();

    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < valoracionRedondeada ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 20,
        );
      }),
    );
  }
}
