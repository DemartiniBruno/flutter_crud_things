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

  @override
  void initState(){
    super.initState();
    _futureThing = getOneThing(widget.thingId);
    _futureCategories = getAllCategories();
    /*_futureCategories = getAllCategories();*/
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
              if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.done) {
                _nome.text = '${snapshot.data!.name}';
                _valorAproximado.text = '${snapshot.data!.value}';
                _selectedValue = snapshot.data!.categoryId.toString();

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
                      const SizedBox(
                        height: 10,
                      ),
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
                                  print('casio ${e.title}');
                                  return DropdownMenuItem(
                                    value: e.id.toString(),
                                    child: Text(e.title.toString()),
                                  );
                                }).toList(),
                                onChanged: (value)  async {

                                  setState(() async {
                                    _selectedValue = value;
                                    await updateThing(_nome.text, _valorAproximado.text, int.parse(_selectedValue), widget.thingId);
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


          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: (){
                    if(_nome.text.isEmpty){
                    } else {
                      setState(() async {
                        await deleteThing(widget.thingId);
                        Navigator.pop(context, true);
                      });
                    }
                  },
                  child: Icon(Icons.delete)
              ),
              const SizedBox(
                width: 10,
              ),
              ElevatedButton(
                  onPressed: (){
                    if(_nome.text.isEmpty){
                    } else {
                      setState(() async {
                        await updateThing(_nome.text, _valorAproximado.text, _selectedValue, widget.thingId);
                        /*await updateThing(_nome.text, widget.thingId);*/
                        Navigator.pop(context, true);
                      });
                    }
                  },
                  child: Icon(Icons.save)
              ),
            ],
          ),
        ],
      ),
    );
  }
}