import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/locais.dart';


class Telalistalocais extends StatefulWidget {
  const Telalistalocais({super.key});

  @override
  State<Telalistalocais> createState() => _TelalistalocaisState();
}

class _TelalistalocaisState extends State<Telalistalocais> {
  bool isloading = false;
  ScrollController posicaocontroller = ScrollController();
  int pagina= 1;
  List<Local> todosLocais = [];
  int paginamaior = 9999999;

  Future<List<Local>> pageData(int page) async {
    debugPrint("estou chamando $page");
    if (!isloading){
      isloading = true;
      final response = await http.Client()
        .get(Uri.parse("https://rickandmortyapi.com/api/location?page=$page"));

    if (response.statusCode == 200) {
      var dados = json.decode(response.body);
      List dados_result = dados['results'] as List; 
      // debugPrint(dados_result.toString());
      dados_result.forEach(
        (local) {
          // debugPrint("Dados: $Local");
          Local l = Local(
              id: local['id'],
              name: local['name'],
              type: local['type'],
              dimension: local["dimension"],
              residents: [],
              url: local['url'],);

          todosLocais.add(l);

        },
      );
      pagina ++;
      isloading = false;
    } else {
      debugPrint("Deu erro na conexão.");  
      return [];
    }
  
    }
    return todosLocais;
  }

@override
  Widget build(BuildContext context) {
    posicaocontroller.addListener(() {
      if(posicaocontroller.position.pixels >= posicaocontroller.position.maxScrollExtent * 0.7 && pagina < paginamaior+1){
    
        setState(() {
          pageData(pagina);
        });
      }
    },);
    

    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de Locais"),
      ),
      body: FutureBuilder(
          future: pageData(pagina),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Text("Não há dados para exibir");
            } else {
              List<Local> listaLocais =
                  snapshot.data as List<Local>;
              return ListView.builder(
                  controller: posicaocontroller,
                  itemCount: listaLocais.length,
                  itemBuilder: (context, index) {
                     return Card(
                       child: ListTile ( 
                          title: Center(child: Text(listaLocais[index].name)),
                          subtitle: Center(child: Text(listaLocais[index].type)),
                        ),);
                     }
                     );
                     }
                     }
                     )
                     );
                     }
                     }
