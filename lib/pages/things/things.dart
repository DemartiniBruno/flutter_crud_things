import 'package:flutter/material.dart';
import '../../models/things_model.dart';
import '../../services/things_services.dart';
import '../category/create_category.dart';
import 'create_things.dart';
import 'detail_thing.dart';

class Things extends StatefulWidget {
  const Things({super.key});

  @override
  State<StatefulWidget> createState() => _things();

}

class _things extends State<Things>{
  Future<List<Thing>>? _futureThings;

  @override
  void initState() {
    super.initState();
    _atualizalista();
  }

  void _atualizalista(){
    _futureThings = getAllThings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text('Things'),
        actions: [
          IconButton(
              onPressed: (){

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context)=>CreateCategory(),
                    )
                );
              },
              icon: Icon(Icons.add)
          )
        ],
      ),
      body: FutureBuilder<List<Thing>>(
        future: _futureThings,
        builder: (context, snapshot){
          if(snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return TextButton(
                    onPressed: ()async{
                      bool refresh = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context)=>DetailThing(thingId: snapshot.data![index].id)
                          )
                      );
                      if(refresh==true){
                        setState(() {
                          _futureThings = getAllThings();
                        });
                      }
                    },
                    child: Text(
                      style: const TextStyle(
                        fontSize: 22
                      ),
                      '${snapshot.data![index].name}'
                    )
                );
              }
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool refresh = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context)=>CreateThing()
            )
          );
          if(refresh==true){
            setState(() {
              _futureThings = getAllThings();
            });
          }
        },
        backgroundColor: Colors.amber,
        child: const Icon(Icons.add),
      ),
    );
  }
}