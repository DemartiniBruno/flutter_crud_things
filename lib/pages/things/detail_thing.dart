import 'package:crud_things/services/categories_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../models/things_model.dart';
import '../../models/categories_model.dart';
import '../../services/things_services.dart';

class DetailThing extends StatefulWidget{
  DetailThing({super.key, required this.thingId });

  final thingId;

  @override
  State<StatefulWidget> createState() => _detailThingState();
}

class _detailThingState extends State<DetailThing>{
  Future<Thing>? _futureThing;
  Future<List<Category>>? _futureCategories;
  TextEditingController _nome = TextEditingController();
  TextEditingController _valorAproximado = TextEditingController();

  var _selectedValue;
  var teste;

  @override
  void initState(){
    super.initState();
    _futureThing = getOneThing(widget.thingId);
    _futureCategories = getAllCategories();
    teste=true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text('DetailThing'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FutureBuilder (
            future: _futureThing,
            builder: (context, snapshot) {
              print(teste);
              if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.done) {
                _nome.text = '${snapshot.data!.name}';
                _valorAproximado.text = '${snapshot.data!.value}';

                /*
                * Validador para que não busque o id do banco toda vez que trocar a opção
                * */
                if(teste==true){
                  _selectedValue = snapshot.data!.categoryId.toString();
                  teste=false;
                }

                return SizedBox(
                  width: 200,
                  child: Column(
                    children: [
                      Text(
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                        ),
                          'Código: ${snapshot.data!.id}'
                      ),
                      TextField(
                        decoration: const InputDecoration(
                            label: Text('Thing'),
                            hintText: 'Digite qual a thing',
                            border: OutlineInputBorder()
                        ),
                        controller: _nome,
                      ),

                      const SizedBox(height: 10),

                      TextField(
                        decoration: const InputDecoration(
                            label: Text('Valor'),
                            hintText: 'Digite o valor',
                            border: OutlineInputBorder()
                        ),
                        controller: _valorAproximado,
                      ),

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
                                onChanged: (value)  async {
                                  _selectedValue = value;
                                  await updateThing(_nome.text, _valorAproximado.text, _selectedValue, widget.thingId);
                                  setState(() {

                                  });
                                },
                              );
                            } else {
                              return CircularProgressIndicator();
                            }
                          }
                      ),

                    ],
                  ),
                );
              } else {
                return CircularProgressIndicator();
              }
            }
          ),

          const SizedBox(height: 5),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: ()async{
                    if(_nome.text.isEmpty){
                    } else {
                      await deleteThing(widget.thingId);
                      setState(()  {
                        Navigator.pop(context, true);
                      });
                    }
                  },
                  /*child: Icon(Icons.delete)*/
                child: Text('Apagar'),
              ),
              const SizedBox(
                width: 10,
              ),
              ElevatedButton(
                  onPressed: ()async{
                    if(_nome.text.isEmpty){
                    } else {
                      await updateThing(_nome.text, _valorAproximado.text, _selectedValue, widget.thingId);
                      setState(()  {
                        /*await updateThing(_nome.text, widget.thingId);*/
                        Navigator.pop(context, true);
                      });
                    }
                  },
                  /*child: Icon(Icons.save)*/
                  child: Text('Salvar'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}