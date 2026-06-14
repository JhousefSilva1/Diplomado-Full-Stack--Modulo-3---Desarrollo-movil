import 'package:estados/model/primo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController tecNumbero = TextEditingController();

  String resultado = '';
  double w = 0;
  double h = 0;
  bool falg = false;
  bool repetirAnimacion = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Numero primo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: tecNumbero,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: const InputDecoration(
                hintText: 'Ingrese un numero',
              ),
            ),

            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();

                    if (tecNumbero.text.isEmpty) {
                      return;
                    }

                    setState(() {
                      int n = int.parse(tecNumbero.text);
                      Primo objPrimo = Primo(n);

                      if (objPrimo.esPrimo()) {
                        resultado = '$n es un numero primo';
                      } else {
                        resultado = '$n no es un numero primo';
                      }

                      falg = false;

                      if (w == 250 && h == 250) {
                        w = 0;
                        h = 0;
                        repetirAnimacion = true;
                      } else {
                        w = 250;
                        h = 250;
                        repetirAnimacion = false;
                      }
                    });
                  },
                  child: const Text('Verificar Primo'),
                ),

                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      tecNumbero.clear();
                      resultado = '';
                      w = 0;
                      h = 0;
                      falg = false;
                      repetirAnimacion = false;
                    });
                  },
                  child: const Text('Limpiar'),
                ),
              ],
            ),

            const SizedBox(height: 50),

            AnimatedContainer(
              duration: const Duration(milliseconds: 1000),
              onEnd: () {
                setState(() {
                  if (repetirAnimacion == true) {
                    w = 250;
                    h = 250;
                    repetirAnimacion = false;
                  } else {
                    if (w > 0 && h > 0) {
                      falg = true;
                    } else {
                      falg = false;
                    }
                  }
                });
              },
              width: w,
              height: h,
              color: Colors.purple.shade200,
              alignment: Alignment.center,
              child: falg
                  ? Text(
                      resultado,
                      style: const TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    )
                  : SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.purple.shade400,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}