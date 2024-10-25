import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../model/episodios.dart';
import '../model/personagem.dart';

class TelaDetalhePersonagem extends StatelessWidget {
  final Personagem personagem;

  TelaDetalhePersonagem({required this.personagem});

  Future<List<Episodio>> pageData() async {
    final response = await http.Client()
        .get(Uri.parse("https://rickandmortyapi.com/api/episode"));

    if (response.statusCode == 200) {
      var dados = json.decode(response.body);
      List dados_result = dados['results'] as List;
      List<Episodio> todosEpisodios = [];
      dados_result.forEach(
        (episodio) {
          // debugPrint("Dados: $episodio");
          Episodio p = Episodio(
              id: episodio['id'],
              name: episodio['name'],
              air_date: episodio['air_date'],
              episode: episodio['episode'],
              characters: episodio['characters'],
              url: episodio['url']);

          todosEpisodios.add(p);
        },
      );
      return todosEpisodios;
    } else {
      debugPrint("Deu erro na conexão.");
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    // debugPrint("AQUII" + personagem.episode.length.toString());
    // debugPrint(personagem.episode[1].toString());
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalhes do Personagem: " + personagem.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
              child: SizedBox(
                child: Image.network(personagem.image),
                height: 300,
                width: 300,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(100, 5, 100, 0),
              child: Text("Nome: " + personagem.name),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(100, 5, 100, 0),
              child: Text("Gênero: " + personagem.gender),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(100, 5, 100, 0),
              child: Text("Raça: " + personagem.species),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(100, 5, 100, 0),
              child: Text("Status: " + personagem.status),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: Text(
                "Episódios:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: SizedBox(
                  height: 600,
                  child: FutureBuilder(
                      future: pageData(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Text("Não há dados para exibir");
                        } else {
                          List<Episodio> listaEpisodios =
                              snapshot.data as List<Episodio>;
                          List<Episodio> episodiosPersonamgem = [];
                          for (Episodio i in listaEpisodios) {
                            for (String j in personagem.episode) {
                              if (i.url == j) {
                                episodiosPersonamgem.add(i);
                              }
                            }
                          }
                          return ListView.builder(
                            itemCount: episodiosPersonamgem.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading:
                                    Text(episodiosPersonamgem[index].episode),
                                title: Text(episodiosPersonamgem[index].name),
                              );
                            },
                          );
                        }
                      })),
            ),
          ],
        ),
      ),
    );
  }
}
