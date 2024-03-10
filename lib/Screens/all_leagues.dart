import 'package:demo_study/Screens/seasons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../Services/constant.dart';
import '../Services/helper.dart';

class AllLeagues extends StatefulWidget {
  String? country;
  AllLeagues({
    super.key,
    required this.country,
  });

  @override
  State<AllLeagues> createState() => _AllLeaguesState();
}

class _AllLeaguesState extends State<AllLeagues> {
  List<dynamic> allLeagues = [];
  List<dynamic> filteredLeagues = [];
  bool isLoading = false;

  void getLeagues() {
    DioHelper.getData(url: allLeaguesPath, query: {
      "c": widget.country,
    }).then((value) {
      setState(() {
        isLoading = false;
        allLeagues = value.data['countries'];
        filteredLeagues = allLeagues;
      });
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
    });
  }

  void filterLeagues(String query) {
    setState(() {
      if (query.isNotEmpty) {
        filteredLeagues = allLeagues
            .where((country) => country['strLeague']
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
      } else {
        filteredLeagues = allLeagues;
      }
    });
  }

  @override
  void initState() {
    getLeagues();
    isLoading = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Leagues",
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              onChanged: filterLeagues,
              decoration: const InputDecoration(
                labelText: 'Search',
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredLeagues.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: InkWell(
                    onTap: () {
                       Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Seasons(
                                leagueId: filteredLeagues[index]['idLeague'],
                                sport:filteredLeagues[index]['strSport'],
                                country: widget.country,
                                )));
                    },
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
                                    '${filteredLeagues[index]['strBadge']}'),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Text(
                                      ' ${filteredLeagues[index]['strLeague']}',
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold),
                                      maxLines: 4,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    '${filteredLeagues[index]['strDescriptionEN']}',
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
