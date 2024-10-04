import 'dart:convert';

import 'package:apiflutter/model/personagem.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Telalistapersonagens extends StatelessWidget {
  const Telalistapersonagens({super.key});

  Future<List<Personagem>> pageData() async{ 
    debugPrint("chamou");
    final response = await http.Client().get(Uri.parse("https://rickandmortyapi.com/api/character"));
    if (response.statusCode == 200){
      List<Personagem> todosPersonagens = [];
      var dados = json.decode(response.body);
      // debugPrint("Dados: $dados");
      var dados_result = dados["results"] as List;
      // debugPrint("Dados results $dados_result");
      // debugPrint(dados['results']);
      dados_result.forEach((personagem) {todosPersonagens.add(Personagem(id: personagem["id"], name: personagem["name"], status: personagem["status"], species: personagem["species"], type: personagem["type"], gender: personagem["gender"], image: personagem["image"], episode: [], url: personagem["url"], created: personagem["created"]));});
      debugPrint("dados $todosPersonagens");
      todosPersonagens.forEach((x) { debugPrint("Nome: ${x.name}");});
      return todosPersonagens;
    } else{
      debugPrint("erro na conexão");
      return[];
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(  
      appBar: AppBar(title: Text("lista de personagens"),),
      body: FutureBuilder(
        future: pageData(),
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return Text("Falta de dados");
          } else {
            List<Personagem> listaPersonagens = snapshot.data as List<Personagem>;
            return ListView.builder(
              itemCount: listaPersonagens.length,
              itemBuilder: (context, index) {
                return Text("Nome:  ${listaPersonagens[index].name.toString()}");
              },);
          }
           
        }),
    );
  }
}
