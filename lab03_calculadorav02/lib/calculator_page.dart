import 'package:flutter/material.dart';
import 'calculator_display.dart';
import 'calculator_buttons.dart';

class CalculatorPage extends StatefulWidget {
  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final TextEditingController _controller = TextEditingController(text: '0');
  String operacion = '';
  double primerNumero = 0;
  bool hayResultado = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 175, 182, 165),
      body: SafeArea(
        child: Center(
          child: Container(
            width: 320,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 218, 226, 205),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CalculatorDisplay(controller: _controller),
                SizedBox(height: 10),
                CalculatorButtons(onButtonPressed: cuandoPresionoBoton),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void cuandoPresionoBoton(String boton) {
    setState(() {
      // Si presiono AC, limpio todo
      if (boton == 'AC') {
        _controller.text = '0';
        operacion = '';
        primerNumero = 0;
        hayResultado = false;
      }

      // Si presiono CE, borro el último número
      else if (boton == 'CE') {
        if (_controller.text.length > 1) {
          _controller.text =
              _controller.text.substring(0, _controller.text.length - 1);
        } else {
          _controller.text = '0';
        }
      }

      // Si presiono un operador
      else if (boton == '+' || boton == '-' || boton == '×' || boton == '÷') {
        if (hayResultado) {
          hayResultado = false;
        }
        primerNumero = double.parse(_controller.text);
        operacion = boton;
        _controller.text = '${_controller.text} $boton ';
      }

      // Si presiono igual
      else if (boton == '=') {
        if (operacion.isNotEmpty) {
          try {
            var numeros = _controller.text.split(' ');
            var num1 = double.parse(numeros[0]);
            var num2 = double.parse(numeros[2]);
            var resultado = 0.0;

            if (operacion == '+') {
              resultado = num1 + num2;
            } else if (operacion == '-') {
              resultado = num1 - num2;
            } else if (operacion == '×') {
              resultado = num1 * num2;
            } else if (operacion == '÷') {
              if (num2 == 0) {
                _controller.text = 'ERROR';
                return;
              }
              resultado = num1 / num2;
            }

            if (resultado.isInfinite) {
              _controller.text = 'ERROR';
            } else {
              _controller.text = resultado.toString();
            }
            hayResultado = true;
          } catch (e) {
            _controller.text = 'ERROR';
          }
        }
      }

      // Si presiono porcentaje
      else if (boton == '%') {
        try {
          var numero = double.parse(_controller.text);
          _controller.text = (numero / 100).toString();
        } catch (e) {
          _controller.text = 'ERROR';
        }
      }

      // Si presiono un número
      else {
        if (hayResultado) {
          _controller.text = '0';
          operacion = '';
          primerNumero = 0;
          hayResultado = false;
        }

        if (_controller.text == '0' || _controller.text == 'ERROR') {
          _controller.text = boton;
        } else {
          _controller.text = _controller.text + boton;
        }
      }
    });
  }
}
