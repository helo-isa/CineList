import 'package:cinelist/model/movies.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
// import 'package:google_translator/google_translator.dart';

void main() {
  runApp(const CineListApp());
}

class CineListApp extends StatelessWidget {
  const CineListApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CineList',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Movie> _movies = [];
  bool _isLoading = false;

  Future<void> _searchMovies(String query) async {
    const apiKey = '53c82e3a';
    final url =
        Uri.parse('http://www.omdbapi.com/?apikey=$apiKey&s=$query&lang=pt_BR');

    setState(() => _isLoading = true);

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['Response'] == 'True' && data['Search'] != null) {
          setState(() {
            _movies = (data['Search'] as List)
                .map((movieData) => Movie(
                      title: movieData['Title'] ?? '',
                      year: movieData['Year'] ?? '',
                      rated: movieData['Rated'] ?? '',
                      released: movieData['Released'] ?? '',
                      runtime: movieData['Runtime'] ?? '',
                      genre: movieData['Genre'] ?? '',
                      director: movieData['Director'] ?? '',
                      writer: movieData['Writer'] ?? '',
                      actors: movieData['Actors'] ?? '',
                      plot: movieData['Plot'] ?? '',
                      language: movieData['Language'] ?? '',
                      country: movieData['Country'] ?? '',
                      awards: movieData['Awards'] ?? '',
                      poster: movieData['Poster'] ?? '',
                      ratings: (movieData['Ratings'] as List?)
                              ?.map(
                                  (rating) => Map<String, String>.from(rating))
                              .toList() ??
                          [],
                      metascore: movieData['Metascore'] ?? '',
                      imdbRating: movieData['imdbRating'] ?? '',
                      imdbVotes: movieData['imdbVotes'] ?? '',
                      imdbID: movieData['imdbID'] ?? '',
                      type: movieData['Type'] ?? '',
                      dvd: movieData['DVD'] ?? '',
                      boxOffice: movieData['BoxOffice'] ?? '',
                      production: movieData['Production'] ?? '',
                      website: movieData['Website'] ?? '',
                      response: movieData['Response'] ?? '',
                    ))
                .toList();
          });
        } else {
          setState(() {
            _movies = [];
          });
        }
      }
    } catch (e) {
      debugPrint('Erro ao buscar filmes: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration:
                  const BoxDecoration(color: Color.fromARGB(255, 9, 76, 131)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'CineList',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Pesquisar filmes...',
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(Icons.search,
                          color: Color.fromARGB(255, 9, 76, 131)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onSubmitted: _searchMovies,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Resultados em carrossel
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _movies.isEmpty
                      ? const Center(child: Text('Nenhum filme encontrado.'))
                      : ListView(
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(
                                'Resultados',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 250, // Altura ajustada do carrossel
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _movies.length,
                                itemBuilder: (context, index) {
                                  final movie = _movies[index];
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        // Pôster do filme como botão clicável
                                        GestureDetector(
                                          onTap: () {
                                            // Exemplo de ação ao clicar no pôster
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    MovieDetailScreen(
                                                        movie: movie),
                                              ),
                                            );
                                          },
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            child: Image.network(
                                              movie.poster,
                                              width: 120, // Largura do pôster
                                              height: 180, // Altura do pôster
                                              fit: BoxFit.cover,
                                              errorBuilder: (_, __, ___) =>
                                                  Container(
                                                width: 120,
                                                height: 180,
                                                color: Colors.grey,
                                                child: const Icon(Icons.movie,
                                                    size: 50),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        // Título do filme
                                        SizedBox(
                                          width: 120, // Mesma largura do pôster
                                          child: Text(
                                            movie.title,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                            style:
                                                const TextStyle(fontSize: 14),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailScreen({Key? key, required this.movie}) : super(key: key);

  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  Movie? _detailedMovie;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMovieDetails();
  }

  Future<void> _fetchMovieDetails() async {
    const apiKey = '53c82e3a'; // Substitua pela sua chave OMDb API
    final url = Uri.parse(
        'http://www.omdbapi.com/?apikey=$apiKey&i=${widget.movie.imdbID}');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['Response'] == 'True') {
          setState(() {
            _detailedMovie = Movie(
              title: data['Title'] ?? '',
              year: data['Year'] ?? '',
              rated: data['Rated'] ?? '',
              released: data['Released'] ?? '',
              runtime: data['Runtime'] ?? '',
              genre: data['Genre'] ?? '',
              director: data['Director'] ?? '',
              writer: data['Writer'] ?? '',
              actors: data['Actors'] ?? '',
              plot: data['Plot'] ?? '',
              language: data['Language'] ?? '',
              country: data['Country'] ?? '',
              awards: data['Awards'] ?? '',
              poster: data['Poster'] ?? '',
              ratings: (data['Ratings'] as List?)
                      ?.map((rating) => Map<String, String>.from(rating))
                      .toList() ??
                  [],
              metascore: data['Metascore'] ?? '',
              imdbRating: data['imdbRating'] ?? '',
              imdbVotes: data['imdbVotes'] ?? '',
              imdbID: data['imdbID'] ?? '',
              type: data['Type'] ?? '',
              dvd: data['DVD'] ?? '',
              boxOffice: data['BoxOffice'] ?? '',
              production: data['Production'] ?? '',
              website: data['Website'] ?? '',
              response: data['Response'] ?? '',
            );
          });
        }
      }
    } catch (e) {
      debugPrint('Erro ao buscar detalhes do filme: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          widget.movie.title,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 9, 76, 131),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _detailedMovie == null
              ? const Center(child: Text('Erro ao carregar os detalhes.'))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.network(
                                  _detailedMovie!.poster,
                                  height: 300,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    width: 200,
                                    height: 300,
                                    color: Colors.grey,
                                    child: const Icon(Icons.movie, size: 50),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _detailedMovie!.title,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Divider(),
                        // Detalhes principais
                        _buildDetailRow(
                            icon: Icons.calendar_today,
                            label: 'Ano',
                            value: _detailedMovie!.year),
                        _buildDetailRow(
                            icon: Icons.person,
                            label: 'Diretor',
                            value: _detailedMovie!.director),
                        _buildDetailRow(
                            icon: Icons.category,
                            label: 'Gênero',
                            value: _detailedMovie!.genre),
                        const Divider(),
                        // Sinopse
                        const Text(
                          'Sinopse',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _detailedMovie!.plot.isNotEmpty
                              ? _detailedMovie!.plot
                              : 'Sinopse não disponível.',
                          style: const TextStyle(fontSize: 14),
                          textAlign: TextAlign.justify,
                        ),
                        const Divider(),
                        // Informação adicional
                        const Text(
                          'Informações Adicionais',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildDetailRow(
                            icon: Icons.language,
                            label: 'Idioma',
                            value: _detailedMovie!.language),
                        _buildDetailRow(
                            icon: Icons.public,
                            label: 'País',
                            value: _detailedMovie!.country),
                        _buildDetailRow(
                            icon: Icons.star,
                            label: 'IMDb Rating',
                            value: _detailedMovie!.imdbRating),
                        _buildDetailRow(
                            icon: Icons.emoji_events,
                            label: 'Prêmios',
                            value: _detailedMovie!.awards),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildDetailRow(
      {required IconData icon, required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Color.fromARGB(255, 9, 76, 131), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  value.isNotEmpty ? value : 'Não disponível',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
