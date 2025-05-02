class Item {
  int precio;
  String articulo;
  int descuento;
  String urlimagen;
  int valoracion;
  String descripcion;
  int calificaciones;

  Item(
      {required this.precio,
      required this.articulo,
      required this.descuento,
      required this.urlimagen,
      required this.valoracion,
      required this.descripcion,
      required this.calificaciones});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      precio: int.tryParse(json['precio'].toString()) ?? 0,
      articulo: json['articulo'] ?? "",
      descuento: int.tryParse(json['descuento'].toString()) ?? 0,
      urlimagen: json['urlimagen'] ?? "",
      valoracion: int.tryParse(json['valoracion'].toString()) ?? 0,
      descripcion: json['descripcion'] ?? "",
      calificaciones: int.tryParse(json['calificaciones'].toString()) ?? 0,
    );
  }
}
