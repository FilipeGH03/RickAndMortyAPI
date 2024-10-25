import 'package:flutter/material.dart';

// ignore: unused_import
import 'episodios/Telalistaepisodios.dart';
import 'locais/Telalistalocais.dart';
import 'personagens/telalistapersonagens.dart';

void main() {
  runApp(MaterialApp(
    title: "Aplicativo do Rick & Morty",
    home: Home(),
    theme: ThemeData(
      fontFamily: 'Rick and Morty Font',
      brightness: Brightness.dark,
    ),
  ));
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Aplicativo do Rick & Morty"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment
                .spaceEvenly, //Divides the extra space evenly between children and before and after the children.

            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Telalistapersonagens()));
                },
                child: Column(
                  children: [
                    Image.asset(
                      "images/characters.png",
                      width: 120,
                      height: 120,
                    ),
                    const Text("Personagens", style: TextStyle(fontSize: 48)),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Telalistalocais()));
                },
                child: Column(
                  children: [
                    Image.asset(
                      "images/locations.png",
                      width: 120,
                      height: 120,
                    ),
                    const Text("Locais", style: TextStyle(fontSize: 48))
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Telalistaepisodios(),
                      ));
                },
                child: Column(children: [
                  Image.asset(
                    "images/episodes.png",
                    width: 120,
                    height: 120,
                  ),
                  const Text("Episódios", style: TextStyle(fontSize: 48)),
                ]),
              )
            ],
          ),
        ));
  }
}
