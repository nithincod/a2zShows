import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';

import '../SectionPage/Adult.dart';
import '../SectionPage/Asian.dart';
import '../SectionPage/HighRated.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  List<String>? trendingImageUrls;
  bool _dataLoaded = false;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    trendinglisthome();
  }

  Future<void> trendinglisthome() async {
    var trendingweekresponse =
    await http.get(Uri.parse('https://api.tvmaze.com/shows'));
    if (trendingweekresponse.statusCode == 200) {
      var temData = jsonDecode(trendingweekresponse.body);
      List<Map<String, dynamic>> tempTrendingList = [];
      for (int i = 0; i < temData.length; i++) {
        String? imageUrl = temData[i]['image']['medium'];
        if (imageUrl != null) {
          tempTrendingList.add({'medium': imageUrl});
        }
      }
      setState(() {
        trendingImageUrls =
            tempTrendingList.map<String>((item) => item['medium'] as String).toList();
        _dataLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            centerTitle: true,
            toolbarHeight: 60,
            pinned: true,
            expandedHeight: MediaQuery.of(context).size.height * 0.5,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: _dataLoaded
                  ? CarouselSlider(
                options: CarouselOptions(
                  viewportFraction: 1,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 1),
                  height: MediaQuery.of(context).size.height,
                ),
                items: trendingImageUrls!.map((imageUrl) {
                  return Builder(
                    builder: (BuildContext context) {
                      return GestureDetector(
                        onTap: () {
                          // Handle image tap
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.3),
                                BlendMode.darken,
                              ),
                              image: NetworkImage(
                                imageUrl,
                              ),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              )
                  : Center(
                child: CircularProgressIndicator(
                  color: Colors.amberAccent,
                ),
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Trending' + '🔥',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,

                  ),
                ),
                const Icon(
                  Icons.search, // This is the IconData parameter
                ),

              ],
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([

              Padding(
                padding: const EdgeInsets.only(top:5 ),
                child: Container(
                    height: 45,

                    width: MediaQuery.of(context).size.width,
                    child: TabBar(
                        physics: BouncingScrollPhysics(),
                        labelPadding: EdgeInsets.symmetric(horizontal: 50),

                        isScrollable: true,
                        controller: _tabController,
                        indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.amber.withOpacity(0.4)),
                        tabs: [
                          Tab(child: Text('Adult')),
                          Tab(child: Text('Asian')),
                          Tab(child: Text('HighRated'))
                        ])),
              ),
              Container(
                  color: Colors.white38,
                  height: 1100,
                  width: MediaQuery.of(context).size.width,
                   
                  child: TabBarView(controller: _tabController, children: const [
                    Adult(),
                    Asian(),
                    HighRated(),
                  ]))
            ]),
          ),
        ],
      ),
    );
  }
}
