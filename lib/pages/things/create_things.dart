import 'package:crud_things/services/categories_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/things_services.dart';

class CreateThing extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _CreateThing();
}

class _CreateThing extends State<CreateThing>{
  final TextEditingController _nameThing = TextEditingController();
  final TextEditingController _valueThing = TextEditingController();
  final TextEditingController _categoryId = TextEditingController();
  var _selectedValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text('Create a new Thing'),
      ),
      body: Center(
        child: SizedBox(
          width: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
                'Cadastre uma Thing'
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                autofocus: true,
                decoration: const InputDecoration(
                  label: Text('Thing'),
                  hintText: 'Digite sua thing',
                  border: OutlineInputBorder()
                ),
                controller: _nameThing
              ),
              const SizedBox(height: 10),
              TextField(
                keyboardType: TextInputType.number, // -> define o tipo de declado que vai abrir
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly // -> bloqueia para não aceitar letras
                ],
                decoration: const InputDecoration(
                  label: Text('Valor'),
                  hintText: 'Digite o valor',
                  border: OutlineInputBorder()
                ),
                controller: _valueThing,
              ),
              const SizedBox(height: 10),

              FutureBuilder(
                future: getAllCategories(),
                builder: (context, snapshot){
                  if(snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
                    return DropdownButton(
                      hint: Text('Categorias'),
                      value: _selectedValue,
                      items: snapshot.data!.map((e){
                        return DropdownMenuItem(
                          value: e.id.toString(),
                          child: Text(e.title.toString()),
                        );
                      }).toList(),
                      onChanged: (value){
                        _selectedValue = value;
                        setState(() {

                        });
                      },
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                }
              ),

              const SizedBox(height: 10,),
              ElevatedButton(
                  onPressed: (){
                    if(_nameThing.text.isEmpty || _valueThing.text.isEmpty){
                      /*
                      * Adicionar validações
                      * */
                      print('Adicionar validações');
                    } else {
                      setState(() async {
                        //Faltou esse await aqui, então ele até atualizava a tela antes
                        //Mas por não esperar criar uma thing nova não tinha nenhum registro novo
                        await createThing(_nameThing.text, _valueThing.text, int.parse(_selectedValue));
                        _nameThing.clear();
                        _valueThing.clear();
                        Navigator.pop(context, true);
                      });
                    }
                  },
                  child: Text('Cadastrar')
              ),
            ],
          ),
        ),
      ),
    );
  }

}