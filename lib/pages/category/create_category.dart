import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../services/categories_services.dart';

class CreateCategory extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _createCategoryState();

}

class _createCategoryState extends State<CreateCategory>{
  TextEditingController _categoryTitle = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text('Create New Category'),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              width: 200,
              child: TextField(
                controller: _categoryTitle,
                decoration: const InputDecoration(
                  hintText: ('Titulo da Categoria'),
                  label: Text('Categoria')
                ),
                style: const TextStyle(
                  fontSize: 20,
                ),
              )
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: (){
                  if(_categoryTitle.text.isEmpty){
                    /*
                    * Validações
                    * */
                  } else {
                    setState(() {
                      createCategory(_categoryTitle.text);
                      Navigator.pop(context);
                    });
                  }
                },
                child: Text('Salvar'))
          ],
        ),
      ),
    );
  }
}