import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _infoText = "Informe seus dados";

  void _resetFields(BuildContext context) {
    // _showDialog(context, "teste", "teste de mensagem de diálogo", okText: "OK");
    setState(() {
      _formKey.currentState.reset();

      weightController.text = "";
      heightController.text = "";

      _infoText = "Informe seus dados";
    });
  }

  void _calculate() {
    setState(() {
      double weight = double.parse(weightController.text);
      double height = double.parse(heightController.text) / 100;

      double imc = weight / (height * height);

      if (imc < 18.6) {
        _infoText = "[${imc.toStringAsFixed(1)}] Abaixo do peso";
      } else if (imc >= 18.6 && imc < 24.9) {
        _infoText = "[${imc.toStringAsFixed(1)}] Peso ideal";
      } else if (imc >= 24.9 && imc < 29.9) {
        _infoText = "[${imc.toStringAsFixed(1)}] Levemente acima do peso";
      } else if (imc >= 29.9 && imc < 34.9) {
        _infoText = "[${imc.toStringAsFixed(1)}] Obesidade Grau I";
      } else if (imc >= 34.9 && imc < 39.9) {
        _infoText = "[${imc.toStringAsFixed(1)}] Obesidade Grau II";
      } else {
        _infoText = "[${imc.toStringAsFixed(1)}] Obesidade Grau III";
      }
    });
  }

  void _showDialog(BuildContext context, String title, String message,
      {String okText}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                child: Text(okText ?? "Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text("Cancelar"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calculadora de IMC"),
        centerTitle: false,
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {_resetFields(context);},
          )
        ],
      ),
      backgroundColor: Color(0xffffffff),
      body: SingleChildScrollView(
          child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 0, top: 40, right: 0, bottom: 20),
              child: Icon(Icons.person_pin, size: 120, color: Colors.green),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, top: 0, right: 20, bottom: 20),
              child: TextFormField(
                keyboardType: TextInputType.number,
                style: TextStyle(
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.green, width: 1),
                  ),
                  contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  border: const OutlineInputBorder(),
                  labelText: "Peso (kg)",
                  labelStyle: TextStyle(
                    color: Colors.green,
                    fontSize: 16,
                  ),
                  prefixIcon: Icon(Icons.line_weight, color: Colors.green),
                ),
                textAlign: TextAlign.left,
                controller: weightController,
                validator: (value) {
                  if (value.isNotEmpty) {
                    try{
                      double w = double.parse(value);

                      if (w <= 0) {
                        return 'Por favor, informe um peso maior que 0.';
                      }

                      return null;
                    } on FormatException {
                      return 'Por favor, informe um peso válido.';
                    }
                  }
                  return 'Por favor, informe seu peso';
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, top: 0, right: 20, bottom: 20),
              child: TextFormField(
                keyboardType: TextInputType.numberWithOptions(
                    signed: false,
                    decimal: false
                ),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
                style: TextStyle(
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.green, width: 1),
                  ),
                  contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  border: const OutlineInputBorder(),
                  labelText: "Altura (cm)",
                  labelStyle: TextStyle(
                    color: Colors.green,
                    fontSize: 16,
                  ),
                  prefixIcon: const Icon(
                    Icons.height,
                    color: Colors.green,
                  ),
                ),
                textAlign: TextAlign.left,
                controller: heightController,
                validator: (value) {
                  if (value.isNotEmpty) {
                    try{
                      double h = double.parse(value);

                      if (h <= 0) {
                        return 'Por favor, informe uma altura maior que 0.';
                      }

                      return null;
                    } on FormatException {
                      return 'Por favor, informe uma altura válida.';
                    }
                  }
                  return 'Por favor, informe sua altura.';
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, top: 0, right: 20, bottom: 20),
              child: Container(
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      FocusScope.of(context).unfocus();
                      _calculate();
                    }
                  },
                  child: Text("Calcular"),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.green),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      fontSize: 20,
                    )),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, top: 0, right: 20, bottom: 20),
              child: Text(
                "$_infoText",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.green,
                  //fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
