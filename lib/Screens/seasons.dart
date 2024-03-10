import 'package:demo_study/Screens/teams.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../Services/constant.dart';
import '../Services/helper.dart';

class Seasons extends StatefulWidget {
  String? leagueId;
  String? sport;
  String? country;
  Seasons(
      {super.key,
      required this.leagueId,
      required this.sport,
      required this.country});

  @override
  State<Seasons> createState() => _SeasonsState();
}

class _SeasonsState extends State<Seasons> {
  List<dynamic> allSeasons = [];
  List<dynamic> filteredSeasons = [];
  bool isLoading = false;

  void getSeasons() {
    DioHelper.getData(url: allSeasonsPath, query: {
      "id": widget.leagueId,
    }).then((value) {
      setState(() {
        isLoading = false;
        allSeasons = value.data['seasons'];
        filteredSeasons = allSeasons;
      });
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
    });
  }

  void filterSeasons(String query) {
    setState(() {
      if (query.isNotEmpty) {
        filteredSeasons = allSeasons
            .where((country) => country['strSeason']
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
      } else {
        filteredSeasons = allSeasons;
      }
    });
  }

  @override
  void initState() {
    getSeasons();
    isLoading = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Seasons",
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              onChanged: filterSeasons,
              decoration: const InputDecoration(
                labelText: 'Search',
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredSeasons.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: InkWell(
                    onTap: () {
                       Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Teams(
                                sport:widget.sport,
                                country: widget.country,
                                )));
                    },
                    child: Container(
                      width: double.infinity,
                      color: Colors.grey[100],
                      child: Text(
                        filteredSeasons[index]['strSeason'],
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
