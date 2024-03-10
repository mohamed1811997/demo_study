import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../Services/constant.dart';
import '../Services/helper.dart';

class Teams extends StatefulWidget {
  String? sport;
  String? country;
  Teams({super.key, required this.sport, required this.country});

  @override
  State<Teams> createState() => _TeamsState();
}

class _TeamsState extends State<Teams> {
  List<dynamic> allTeams = [];
  List<dynamic> filteredTeams = [];
  bool isLoading = false;

  void getTeams() {
    DioHelper.getData(url: allTeamsPath, query: {
      "s": widget.sport,
      "c": widget.country,
    }).then((value) {
      setState(() {
        isLoading = false;
        allTeams = value.data['teams'];
        filteredTeams = allTeams;
      });
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
    });
  }

  void filterTeams(String query) {
    setState(() {
      if (query.isNotEmpty) {
        filteredTeams = allTeams
            .where((country) =>
                country['strTeam'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      } else {
        filteredTeams = allTeams;
      }
    });
  }

  @override
  void initState() {
    getTeams();
    isLoading = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Teams",
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: isLoading == true
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextField(
                    onChanged: filterTeams,
                    decoration: const InputDecoration(
                      labelText: 'Search',
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredTeams.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          width: double.infinity,
                          color: Colors.grey[100],
                          child: Row(
                            children: [
                              Container(
                                width: 120.0,
                                height: 120.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        '${filteredTeams[index]['strTeamBadge']}'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 15.0,
                              ),
                              Expanded(
                                child: SizedBox(
                                  height: 120.0,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          ' ${filteredTeams[index]['strTeam']}',
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold),
                                          maxLines: 4,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Text(
                                        '${filteredTeams[index]['strDescriptionEN']}',
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12.0,
                                        ),
                                        maxLines: 4,
                                        overflow: TextOverflow.ellipsis,
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
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
