import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorPickerPage extends StatefulWidget {
  @override
  _ColorPickerPageState createState() => _ColorPickerPageState();
}

class _ColorPickerPageState extends State<ColorPickerPage> {
  Color _selectedColor = Colors.red;

  // Función para enviar el color seleccionado al LED
  void enviarColorLed(Color color) {
      if (characteristic == null) {
      print('Característica no encontrada');
      return;
    }
    String colorString = '${color.red},${color.green},${color.blue}';
    List<int> bytes = colorString.codeUnits;
    characteristic!.write(bytes);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selector de Color'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ColorPicker(
              pickerColor: _selectedColor,
              onColorChanged: (color) {
                setState(() {
                  _selectedColor = color;
                });
              },
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
            SizedBox(height: 20),
            Text(
              'Color Seleccionado:',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Container(
              width: 50,
              height: 50,
              color: _selectedColor,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                enviarColorLed(_selectedColor); // Llama a la función para enviar el color al LED
              },
              child: Text('Enviar al LED'),
            ),
          ],
        ),
      ),
    );
  }
}
