import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:my_paint/graphic_shapes/dibuja_punto.dart';
import 'package:my_paint/model/modelo_punto.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double x = 200;
  double y = 300;
  double radio = 10;
  Color colorDefault = Colors.blue;
  List<ModeloPunto> puntos = [];

  Future<void> paleta(BuildContext context) async {
    Color colorTmp = colorDefault;
    await showDialog(      context: context,
      builder: (BuildContext dialogContext){
          return AlertDialog(
            title:  Text('Selecciona un color'),
            content: ColorPicker(
            pickerColor:colorDefault,
            onColorChanged: (Color color){
              colorTmp = color;
            }
          ),
          actions:[
            TextButton(
              onPressed: (){
                setState(() {
                  colorDefault = colorTmp;
                  Navigator.of(dialogContext).pop();
                });
              }, 
              child: const Text('Aceptar')
            )
          ]
        );
      },
    );

    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Paint'),
      ),
      body: Stack(
        children: [
          CustomPaint(
            painter: DibujaPunto(puntos),
          ),
          GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                x = details.localPosition.dx;
                y = details.localPosition.dy;
                puntos.add(ModeloPunto(x, y, radio, colorDefault));
              });
            },
          ),
        ],
        
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            SizedBox(
              width: 100,
              child: Slider(
                value: radio,
                min: 1,
                max: 20,
                onChanged: (value) {
                  setState(() {
                    radio = value;
                  });
                },
              ),
              ),

              IconButton(
                onPressed: () {
                  setState(() {
                    // limpiar la lista de puntos
                    puntos.clear();
                  });
                }, 
                icon: const Icon(Icons.delete, color: Colors.red,)
              ),
              IconButton(
                onPressed: () {
                  paleta(context);
                }, 
                icon: const Icon(Icons.color_lens, color: Colors.blue,)
              ),
          ],
        )
      ),
    );
  }
}