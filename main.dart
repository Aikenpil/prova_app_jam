import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Auxilio fubas'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String _infoText = "Preencha o formulario";
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _mae_solteira = false;
  bool _escolarizados_vacinados = false;
  var _salario = TextEditingController();
  var _filhos = TextEditingController();

  void dispose() {
    // Clean up the controller when the widget is disposed.
    _salario.dispose();
    _filhos.dispose();
    super.dispose();
  }

  void updateUi(){
    setState(() {
      _salario.text = "";
      _filhos.text = "";
      _infoText = "Informe seus dados";
      _mae_solteira = false;
      _escolarizados_vacinados = false;
      _formKey = GlobalKey<FormState>();
    });
  }

  void Auxilio(){
    setState(() {

      const MINIMUM_SALARY = 1212.0;

      var _salary = double.parse(_salario.text);
      var _child = int.parse(_filhos.text);
      var auxilio = 0.0;

      /*Auxilio padrão para mães solteiras*/
      if(_mae_solteira) auxilio += 600.0;

      /*Estagio 1 do auxilio*/
      if(_salary < (MINIMUM_SALARY*2) && _child <= 2 && _escolarizados_vacinados == true){
        auxilio += MINIMUM_SALARY*1.5;
        _infoText = "Recebera um auxilio de ${auxilio}";
      }
      /*Estagio 2 do auxilio*/
      else if(_salary < MINIMUM_SALARY && _child <= 2 && _escolarizados_vacinados == true){
        auxilio += MINIMUM_SALARY*2.5;
        _infoText = "Recebera um auxilio de ${auxilio}";
      }
      /*Estagio 3 do auxilio*/
      else if(_salary < (MINIMUM_SALARY*2) && _child >= 3 && _escolarizados_vacinados == true){
        auxilio += MINIMUM_SALARY*3.0;
        _infoText = "Recebera um auxilio de ${auxilio}";
      }
      /*Estagio 4 do auxilio*/
      else if(_mae_solteira && _child >= 1){
        _infoText = "Recebera um auxilio de ${auxilio}";
      }
      /*Nao cumpre os requisitos*/
      else{
        _infoText = "Não recebera auxilio";
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(onPressed: updateUi, icon: Icon(Icons.refresh))
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                //Text("Salario"),
                TextFormField(
                  validator: (value){
                    if(value!.isEmpty) return "Insira seu salario";
                    if(num.tryParse(value.toString()) == null) return "Somente numero";
                    if(double.parse(value.toString()) < 0) return "Nao aceito menos que 0";
                  },
                  controller: _salario,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Salario", labelStyle: TextStyle(color: Colors.blue), helperText: "Insira o seu salario"),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.blue, fontSize: 25),
                ),
                //Text("Numero de filhos"),
                TextFormField(
                  validator: (value){
                    if(value!.isEmpty) return "Insira o numero de filhos";
                    if(num.tryParse(value.toString()) == null) return "Somente numero";
                    if(double.parse(value.toString()) < 0) return "Nao aceito menos que 0";
                  },
                  controller: _filhos,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Numero de Filhos", labelStyle: TextStyle(color: Colors.blue), helperText: "Filhos"),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.blue, fontSize: 25),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text("Todos os filhos na escola e vacinados", style: TextStyle(color: Colors.blue, fontSize: 20)),
                ),
                Switch(
                  value: _escolarizados_vacinados,
                  onChanged: (value){
                    setState(() {
                      _escolarizados_vacinados = value;
                    });
                  },
                ),
                Padding(padding: const EdgeInsets.fromLTRB(0,10,0,0),
                  child: Text("Mae Solteira", style: TextStyle(color: Colors.blue, fontSize: 20)),
                ),
                Switch(
                  value: _mae_solteira,
                  onChanged: (value){
                    setState(() {
                      _mae_solteira = value;
                    });
                  },
                ),
                ElevatedButton(
                    onPressed: (){
                      if(_formKey.currentState!.validate()) Auxilio();
                    },
                    child: Text("Calcular"),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.blue)
                    )
                ),
                Text(
                    '$_infoText',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 35,
                        color: Colors.blue
                    )
                ),
              ],
          ),
        ),
      )
    );
  }
}
