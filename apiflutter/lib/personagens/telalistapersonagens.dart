import 'dart:convert';
// ignore: unused_import
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/personagem.dart';
import 'teladetalhepersonagem.dart';

class Telalistapersonagens extends StatelessWidget {
  const Telalistapersonagens({super.key});

  Future<List<Personagem>> pageData() async {
    final response = await http.Client()
        .get(Uri.parse("https://rickandmortyapi.com/api/character"));

    if (response.statusCode == 200) {
      var dados = json.decode(response.body);
      List dados_result = dados['results'] as List;
      List<Personagem> todosPersonagens = [];
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
      return todosPersonagens;
    } else {
      debugPrint("Deu erro na conexão.");
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de Personagens"),
      ),
      body: FutureBuilder(
          future: pageData(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Text("Não há dados para exibir");
            } else {
              List<Personagem> listaPersonagens =
                  snapshot.data as List<Personagem>;
              return ListView.builder(
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
