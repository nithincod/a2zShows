import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../MovieDetails/MovieDetail.dart';

class Adult extends StatefulWidget {
  const Adult({Key? key}) : super(key: key);

  @override
  State<Adult> createState() => _AdultState();
}

class _AdultState extends State<Adult> {
  List<String>? adultImageUrls;
  List<String>? adultImageUrls2;
  List<String>? adultImageUrls3;
  List<Map<String, dynamic>>? MovieDetails;
  List<Map<String, dynamic>>? MovieDetails2;
  List<Map<String, dynamic>>? MovieDetails3;
  bool _dataLoaded = false;

  @override
  void initState() {
    super.initState();
    adultSeriesurlFunction();
    adultSeriesurlFunction2();
    adultSeriesurlFunction3();
  }

  Future<void> adultSeriesurlFunction() async {
    try {
      var adultTvResponse = await http.get(Uri.parse('https://api.tvmaze.com/shows'));
      if (adultTvResponse.statusCode == 200) {
        var tempData = jsonDecode(adultTvResponse.body);
        List<String> tempImageUrls = [];
        for (int i = 0; i < tempData.length; i++) {
          String? imageUrl = tempData[i]['image']['medium'];
          if (imageUrl != null) {
            tempImageUrls.add(imageUrl);
          }
        }

        List<Map<String, dynamic>> tempMovieDetails = [];
        for (int i = 0; i < tempData.length; i++) {
          String? imageUrl = tempData[i]['image']['medium'];
          if (imageUrl != null) {
            tempMovieDetails.add({
              'id': tempData[i]['id'],
              'name': tempData[i]['name'],
              'language': tempData[i]['language'],
              'summary': tempData[i]['summary'],
              'imageUrl': imageUrl,
            });
          }
        }

        setState(() {
          adultImageUrls = tempImageUrls;
          MovieDetails = tempMovieDetails;
          _dataLoaded = true;
        });
      } else {
        print('Failed to fetch data: ${adultTvResponse.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }


  Future<void> adultSeriesurlFunction2() async {
    try {
      var adultTvResponse2 = await http.get(Uri.parse('https://api.tvmaze.com/shows'));
      if (adultTvResponse2.statusCode == 200) {
        var tempData = jsonDecode(adultTvResponse2.body);
        List<Map<String, dynamic>> tempMovieDetails2 = [];
        for (int i = 20; i < tempData.length; i++) {
          List<dynamic>? genres = tempData[i]['genres'];
          if (genres != null && genres.contains('Thriller')) {
            String? imageUrl = tempData[i]['image']['medium'];
            if (imageUrl != null) {
              tempMovieDetails2.add({
                'id': tempData[i]['id'],
                'name': tempData[i]['name'],
                'language': tempData[i]['language'],
                'summary': tempData[i]['summary'],
                'imageUrl': imageUrl,
              });

            }
          }
        }
        setState(() {
          MovieDetails2 = tempMovieDetails2;
          _dataLoaded = true;
        });
      } else {
        print('Failed to fetch data: ${adultTvResponse2.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> adultSeriesurlFunction3() async {
    try {
      var adultTvResponse3 = await http.get(Uri.parse('https://api.tvmaze.com/shows'));
      if (adultTvResponse3.statusCode == 200) {
        var tempData = jsonDecode(adultTvResponse3.body);

        List<Map<String, dynamic>> tempMovieDetails3 = [];
        for (int i = 40; i < tempData.length; i++) {
          String? status = tempData[i]['status'];
          if (status != null && status == 'Ended') {
            String? imageUrl = tempData[i]['image']['medium'];
            if (imageUrl != null) {
              tempMovieDetails3.add({
                'id': tempData[i]['id'],
                'name': tempData[i]['name'],
                'language': tempData[i]['language'],
                'summary': tempData[i]['summary'],
                'imageUrl': imageUrl,
              });
            }
          }
        }
        setState(() {
          MovieDetails3 = tempMovieDetails3;
          _dataLoaded = true;
        });
      } else {
        print('Failed to fetch data: ${adultTvResponse3.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _dataLoaded
          ? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 15),
            child: Text(
              'Popular Tv Shows',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 3),
            child: SizedBox(
              width: 130,
              height: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 15, bottom: 40),
            child: SizedBox(
              height: 250,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: adultImageUrls?.length ?? 0,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => MovieDetail(MovieDetails?[index]['id']),
                        ),
                      );
                      print(MovieDetails?[index]['id']);
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Image.network(
                        adultImageUrls![index],
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 15),
            child: Text(
              'Thriller Hits',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 3),
            child: SizedBox(
              width: 90,
              height: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 15, bottom: 40),
            child: SizedBox(
              height: 250,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: MovieDetails2?.length ?? 0,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => MovieDetail(MovieDetails2?[index]['id']),
                        ),
                      );

                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Image.network(
                        MovieDetails2![index]['imageUrl'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 15),
            child: Text(
              'Past classics',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 3),
            child: SizedBox(
              width: 100,
              height: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 15, bottom: 40),
            child: SizedBox(
              height: 250,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: MovieDetails3?.length ?? 0,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => MovieDetail(MovieDetails3?[index]['id']),
                        ),
                      );

                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Image.network(
                        MovieDetails3![index]['imageUrl'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
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
