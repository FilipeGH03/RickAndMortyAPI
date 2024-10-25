import 'dart:convert';
// ignore: unused_import
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/personagem.dart';
import 'teladetalhepersonagem.dart';

class Telalistapersonagens extends StatefulWidget {
  const Telalistapersonagens({super.key});

  @override
  State<Telalistapersonagens> createState() => _TelalistapersonagensState();
}

class _TelalistapersonagensState extends State<Telalistapersonagens> {
  bool isloading = false;
  ScrollController posicaocontroller = ScrollController();
  int pagina=1;
  List<Personagem> todosPersonagens = [];
  int paginamaior = 9999999;

  Future<List<Personagem>> pageData(int page) async {
    debugPrint("estou chamando $page");
    if (!isloading){
      isloading = true;
      final response = await http.Client()
        .get(Uri.parse("https://rickandmortyapi.com/api/character?page=$page"));

    if (response.statusCode == 200) {
      var dados = json.decode(response.body);
      List dados_result = dados['results'] as List;
      paginamaior = dados['info']['pages'];
      // paginamaior = int

      dados_result.forEach(
        (personagem) {
          // debugPrint("Dados: $personagem");
          Personagem p = Personagem(
              id: personagem['id'],
              name: personagem['name'],
              status: personagem['status'],
              species: personagem['species'],
              type: personagem['type'],
              gender: personagem['gender'],
              image: personagem['image'],
              episode: personagem['episode'],
              url: personagem['url'],
              created: personagem['created']);

          todosPersonagens.add(p);

        },
      );
      pagina ++;
      isloading = false;
    } else {
      debugPrint("Deu erro na conexão.");  
      return [];
    }
  
    }
    return todosPersonagens;
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
        title: const Text("Lista de Personagens"),
      ),
      body: FutureBuilder(
          future: pageData(pagina),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Text("Não há dados para exibir");
            } else {
              List<Personagem> listaPersonagens =
                  snapshot.data as List<Personagem>;
              return ListView.builder(
                  controller: posicaocontroller,
                  itemCount: listaPersonagens.length,
                  itemBuilder: (context, index) {
                    Color cor = Colors.green;
                    if (listaPersonagens[index].status == "unknown") {
                      cor = Colors.yellow;
                    } else if (listaPersonagens[index].status == "Alive") {
                      cor = Colors.green;
                    } else {
                      cor = Colors.red;
                    }
                    return GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TelaDetalhePersonagem(
                                personagem: listaPersonagens[index]),
                          )),
                      child: Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(listaPersonagens[index].image),
                          ),
                          title: Text(listaPersonagens[index].name),
                          subtitle: Text(listaPersonagens[index].species),
                          trailing: Icon(
                            Icons.circle,
                            color: cor,
                            size: 15.0,
                          ),
                        ),
                      ),
                    );
                    // return Text("Nome do Personagem: " +
                    //     listaPersonagens[index].name.toString());
                  });
            }
          }),
    );
  }
}
