import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pokemon_app/pokemon.dart';
import 'package:pokemon_app/pokemon_detail.dart';

void main() => runApp(MaterialApp(
  title: "Poke App",
  home: HomePage(),
  debugShowCheckedModeBanner: false,
));

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  SearchBar searchBar;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var url =
      "https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json";
    // final ScrollController _scrollController = ScrollController();
  PokeHub pokeHub;

  @override
  void initState() {
    super.initState();

    fetchData();
  }

  fetchData() async {
    var res = await http.get(Uri.parse(url));
    var decodedJson = jsonDecode(res.body);
    pokeHub = PokeHub.fromJson(decodedJson);
    print(pokeHub.toJson());
    setState(() {});
  }
  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
        title: Text("Poke App"),
        backgroundColor: Colors.cyan,
        actions: [searchBar.getSearchAction(context)]
    );
  }
  void onSubmitted(String value) {
    setState(() => _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text('You wrote $value!'))));
  }

  HomePageState() {
    searchBar = new SearchBar(
        inBar: false,
        setState: setState,
        onSubmitted: onSubmitted,
        buildDefaultAppBar: buildAppBar

    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      appBar:searchBar.build(context),
      key: _scaffoldKey,
      
      body: new Scrollbar(
          isAlwaysShown: true,
        // controller: _scrollController,
        //
        // radius: Radius.circular(20),
        thickness: 20,



        child: pokeHub == null
            ? Center(
          child: CircularProgressIndicator(),
        )
            : GridView.count(
          crossAxisCount: 2,
          children: pokeHub.pokemon
              .map((poke) => Padding(
            padding: const EdgeInsets.all(2.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PokeDetail(
                          pokemon: poke,
                        )));
              },

              child: Hero(
                tag: poke.img,
                child: Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment:
                    MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height*0.2,
                        width: MediaQuery.of(context).size.width*0.3,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(poke.img))),
                      ),
                      Text(
                        poke.name,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ))
              .toList(),
        ),
      ),
      drawer: Drawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.cyan,
        child: Icon(Icons.refresh),
      ),
    );
  }
}
