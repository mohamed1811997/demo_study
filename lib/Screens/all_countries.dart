import 'package:demo_study/Screens/all_leagues.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../Services/constant.dart';
import '../Services/helper.dart';

class AllCountries extends StatefulWidget {
  const AllCountries({super.key});

  @override
  State<AllCountries> createState() => _AllCountriesState();
}

class _AllCountriesState extends State<AllCountries> {
  var searchController = TextEditingController();
  List<dynamic> allCountries = [];
  List<dynamic> filteredCountries = [];
  bool isLoading = false;

  void getCountry() {
    
    DioHelper.getData(
      url: allCountriesPath,
    ).then((value) {
      setState(() { 
        isLoading =false;
        allCountries = value.data['countries'];
        filteredCountries = allCountries;
      });
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
    });
  }

  void filterCountries(String query) {
    setState(() {
      if (query.isNotEmpty) {
        filteredCountries = allCountries
            .where((country) =>
                country['name_en'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      } else {
        filteredCountries = allCountries;
      }
    });
  }

  @override
  void initState() {
    getCountry();
    isLoading =true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Countries",style: TextStyle(fontSize:18.0,fontWeight: FontWeight.bold),),
      ),
      body:isLoading ==true ?const Center(child: CircularProgressIndicator(),)
       : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              controller: searchController,
              onChanged: filterCountries,
              decoration: const InputDecoration(
                labelText: 'Search',
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredCountries.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AllLeagues(country: filteredCountries[index]['name_en'],)));
                    },
                    child: Container(
                      width: double.infinity,
                      color: Colors.grey[100],
                      child: Text(
                        filteredCountries[index]['name_en'],
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
