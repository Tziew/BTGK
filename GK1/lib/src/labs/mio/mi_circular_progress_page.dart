import 'dart:math';
// import 'dart:ui';

import 'package:flutter/material.dart';

class MiCircularProgressPage extends StatefulWidget {
  const MiCircularProgressPage({super.key});

  @override
  State<MiCircularProgressPage> createState() => _MiCircularProgressPageState();
}

class _MiCircularProgressPageState extends State<MiCircularProgressPage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  double porcentaje = 0.0;
  double nuevoPorcentaje = 0.0;
  late Animation<double> animacionPorcentaje;

  @override
  void initState() {
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));

    controller.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    animacionPorcentaje =
        Tween(begin: porcentaje, end: nuevoPorcentaje).animate(controller);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
        onPressed: () {
          porcentaje = nuevoPorcentaje;
          nuevoPorcentaje += 10;
          if (nuevoPorcentaje > 100) {
            nuevoPorcentaje = 0;
            porcentaje = 0;
          }
          controller.forward(from: 0.0);
          setState(() {});
        },
        child: const Icon(Icons.refresh),
      ),
      body: AnimatedBuilder(
        animation: controller,
        builder: (BuildContext context, Widget? child) {
          return Center(
            child: Container(
              padding: const EdgeInsets.all(5),
              width: 300,
              height: 300,
              child: CustomPaint(
                painter: _MiRadialProgress(animacionPorcentaje.value),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _MiRadialProgress extends CustomPainter {
  late double porcentaje;

  _MiRadialProgress(this.porcentaje);

  @override
  void paint(Canvas canvas, Size size) {
    //Circulo completado
    final paint = Paint()
      ..strokeWidth = 4
      ..color = Colors.grey
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width * 0.5, size.height / 2);
    final radio = min(size.width * 0.5, size.height * 0.5);

    canvas.drawCircle(center, radio, paint);

    // Arco
    final paintArco = Paint()
      ..strokeWidth = 10
      ..color = Colors.pink
      ..style = PaintingStyle.stroke;

    // Parte que se debera ir llenando
    double arcAngle = 2 * pi * (porcentaje / 100);
    canvas.drawArc(
        Rect.fromCircle(
            center: center, radius: radio), // donde quiero que se dibuje
        -pi / 2, // angulo donde empieza a llenarse
        // grados * -90, // se puede poner tambien con los grados ((pi / 180) * gradosquequiero ) si pones -90 grados queda arriba perfecto
        arcAngle, // angulo que se llena del color
        false,
        paintArco);
  }

  @override
  bool shouldRepaint(_MiRadialProgress oldDelegate) => true;
}
