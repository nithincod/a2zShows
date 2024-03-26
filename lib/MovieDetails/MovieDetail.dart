import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MovieDetail extends StatefulWidget {
  final int id;

  const MovieDetail(this.id, {Key? key}) : super(key: key);

  @override
  State<MovieDetail> createState() => _MovieDetailState();
}

class _MovieDetailState extends State<MovieDetail> {
  late Map<String, dynamic> movieDetails = {};
  late List<Map<String, dynamic>> crewDetails = [];

  bool _dataLoaded = false;

  @override
  void initState() {
    super.initState();
    fetchMovieDetails(widget.id);
    fetchCrewdetails(widget.id);
  }

  Future<void> fetchCrewdetails(int id) async {
    try {
      var response = await http.get(Uri.parse('https://api.tvmaze.com/shows/$id/crew'));
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        List<Map<String, dynamic>> tempcrewdetails = [];
        for (int i = 0; i < jsonData.length; i++) {
          if (jsonData[i]['person'] != null && jsonData[i]['person']['image'] != null && jsonData[i]['country'] != null) {
            tempcrewdetails.add({
              'type': jsonData[i]['type'],
              'name': jsonData[i]['person']['name'],
              'country': jsonData[i]['country']['name'],
              'image': jsonData[i]['person']['image']['medium'],
            });
          }
        }

        setState(() {
          crewDetails = tempcrewdetails;
          _dataLoaded = true;
        });
      } else {
        print('Failed to fetch crew details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching crew details: $e');
    }
  }

  Future<void> fetchMovieDetails(int id) async {
    try {
      var response = await http.get(Uri.parse('https://api.tvmaze.com/shows/$id'));
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        setState(() {
          // Remove HTML tags from summary using regex
          String summaryWithoutHtml = jsonData['summary'].replaceAll(RegExp(r'<[^>]*>'), '');

          movieDetails = {
            'imageUrl': jsonData['image']['medium'],
            'name': jsonData['name'],
            'summary': summaryWithoutHtml,
            'runtime': jsonData['runtime'],
            'premiered': jsonData['premiered'],
            'rating': jsonData['rating']['average'],
          };
          _dataLoaded = true;
        });
      } else {
        print('Failed to fetch movie details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching movie details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _dataLoaded
          ? CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 350,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                movieDetails['imageUrl'],
                fit: BoxFit.fill,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        movieDetails['name'],
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '⭐️' + movieDetails['rating'].toString(),
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    movieDetails['summary'].toString(),
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Runtime: ${movieDetails['runtime']}',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Premiered: ${movieDetails['premiered']}',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Container(
                    height: 150,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: crewDetails.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {},

                          child: Container(

                            margin: const EdgeInsets.symmetric(horizontal: 8.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Image.network(
                              crewDetails[index]['image'],
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
      )
          : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
