import 'dart:convert';

import 'package:apiflutter/model/episodios.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Telalistaepisodios extends StatefulWidget {
  const Telalistaepisodios({super.key});

  @override
  State<Telalistaepisodios> createState() => _TelalistaepisodiosState();
}

class _TelalistaepisodiosState extends State<Telalistaepisodios> {
bool isloading = false;
  ScrollController posicaocontroller = ScrollController();
  int pagina= 1;
  List<Episodio> todosEpisodios = [];
  int paginamaior = 9999999;

  Future<List<Episodio>> pageData(int page) async {
    debugPrint("estou chamando $page");
    if (!isloading){
      isloading = true;
      final response = await http.Client()
        .get(Uri.parse("https://rickandmortyapi.com/api/episode?page=$page"));

    if (response.statusCode == 200) {
      var dados = json.decode(response.body);
      List dados_result = dados['results'] as List; 
      // debugPrint(dados_result.toString());
      dados_result.forEach(
        (episodio) {
          // debugPrint("Dados: $Episodio");
          Episodio e = Episodio(
              id: episodio['id'],
              name: episodio['name'],
              air_date: episodio['air_date'],
              characters: [],
              episode: episodio['episode'],
              url: episodio['url'],);

          todosEpisodios.add(e);

        },
      );
      pagina ++;
      isloading = false;
    } else {
      debugPrint("Deu erro na conexão.");  
      return [];
    }
  
    }
    return todosEpisodios;
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
        title: const Text("Lista de Episodios"),
      ),
      body: FutureBuilder(
          future: pageData(pagina),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Text("Não há dados para exibir");
            } else {
              List<Episodio> listaEpisodios =
                  snapshot.data as List<Episodio>;
              return ListView.builder(
                  controller: posicaocontroller,
                  itemCount: listaEpisodios.length,
                  itemBuilder: (context, index) {
                     return Card(
                       child: ListTile ( 
                          title: Text(listaEpisodios[index].name),
                          leading: Text(listaEpisodios[index].episode),
                        ),);
                     }
                     );
                     }
                     }
                     )
                     );
                     }
                     }
