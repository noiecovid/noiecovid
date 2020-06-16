import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:noiecovid/constants.dart';
import 'package:noiecovid/components/reusable_card.dart';
import 'package:noiecovid/components/search.dart';

class CountryPage extends StatefulWidget {
  @override
  _CountryPageState createState() => _CountryPageState();
}

class _CountryPageState extends State<CountryPage> {
  List countryData;

  void fetchCountryData() async {
    http.Response response =
        await http.get('https://corona.lmao.ninja/v2/countries');
    setState(
      () {
        countryData = json.decode(response.body);
        print(countryData);
      },
    );
  }

  @override
  void initState() {
    fetchCountryData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: Search(countryData));
            },
          )
        ],
        title: Text('NOI E COVID'),
      ),
      body: countryData == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemBuilder: (context, index) {
                return Expanded(
                  child: ReusableCard(
                    colour: kActiveCardColour,
                    cardChild: Container(
                      height: 130,
                      margin: EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 200,
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  countryData[index]['country'],
                                  style: kLabelTextStyle,
                                ),
                                Image.network(
                                  countryData[index]['countryInfo']['flag'],
                                  height: 50,
                                  width: 60,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                      countryData[index]['deaths']
                                          .toString(),
                                      style: kNumberTextStyle),
                                  Text(
                                    'MORTI',
                                    style: kLabelTextStyle,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              itemCount: countryData == null ? 0 : countryData.length,
            ),
    );
  }
}
