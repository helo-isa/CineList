import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cinelist',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: CineList(),
    );
  }
}

class CineList extends StatelessWidget {
  final TextEditingController search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor:
            Colors.black.withOpacity(0.0), // Ajustado para transparência
        elevation: 0,
        title: const Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
          child: Text(
            "CINELIST",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 20, 1),
            child: Icon(
              Icons.person_outline,
              size: 40,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          // Parte superior com a imagem de fundo
          Stack(
            children: [
              // Imagem de fundo
              Container(
                width: MediaQuery.of(context).size.width,
                height: 750, // Limita a altura da imagem de fundo
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("images/background1.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Campo de pesquisa
              Positioned(
                bottom: 40,
                left: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextField(
                    controller: search,
                    decoration: const InputDecoration(
                      hintText: "Pesquisar",
                      prefixIcon: Icon(Icons.search, color: Colors.black54),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Seções abaixo da imagem de fundo
          sectionTitle("INFANTIL"),
          horizontalMovieList([
            "images/background1.jpg",
            "images/background1.jpg",
            "images/background1.jpg",
            "images/background1.jpg",
            "images/background1.jpg",
          ]),
          sectionTitle("ROMANCE"),
          horizontalMovieList([
            "images/background1.jpg",
            "images/background1.jpg",
            "images/background1.jpg",
            "images/background1.jpg",
            "images/background1.jpg",
          ]),
        ],
      ),
    );
  }

  // Widget para título da seção
  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  // Widget para lista horizontal de filmes
  Widget horizontalMovieList(List<String> imagePaths) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: imagePaths.map((path) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            width: 120,
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: AssetImage(path),
                fit: BoxFit.cover,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
