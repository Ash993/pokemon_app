import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pokemon_app/pokemon.dart';
import 'package:pokemon_app/pokemon_detail.dart';

void main() {
  runApp(MaterialApp(
    title: "Poke App",
    home: HomePage(),
    debugShowCheckedModeBanner: false,
  ));
}
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
    var url ="https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json";
     PokeHub pokeHub;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();

  }
  fetchData() async{
   var res= await http.get(url);
   var decodedJson =jsonDecode(res.body);
   pokeHub =PokeHub.fromJson(decodedJson);
   print(pokeHub.toJson());
   setState(() {

   });


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PokeApp"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search), onPressed: (){
            showSearch(context: context, delegate: DataSearch());
          })
        ],
        backgroundColor: Colors.cyan,
      ),

      body: pokeHub==null? Center(
        child: CircularProgressIndicator(),
      )
      :GridView.count(crossAxisCount: 2,
        children: pokeHub.pokemon
            .map((poke) => Padding(
          padding: const EdgeInsets.all(2.0),
          child: InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>PokeDetail(
                pokemon: poke,
              )));
            },
            child: Hero(
              tag: poke.img,
              child: Card(
                elevation: 3.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      height: 100.0,
                      width: 100.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(image: NetworkImage(poke.img))
                      ),
                    ),
                    Text(
                      poke.name,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                  ],
                ) ,
              ),
            ),
          ),
        )).toList(),
      ),
      drawer: Drawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        backgroundColor: Colors.cyan,
        child: Icon(Icons.refresh),
      ),
    );
  }
}

class DataSearch extends SearchDelegate<String>{
  final Pokemon pokemon;
  DataSearch({this.pokemon});

  final pokemones =[
    "Charizard",
    "Gengar",
    "Arcanine",
    "Bulbasaur",
    "Blaziken",
    "Umbreon",
    "Lucario",
    "Gardevoir",
    "Garchomp",
    "Mudkip",
    "Blastoise",
    "Scizor",
    "Luxray",
    "Torterra",
    "Snorlax",
    "Internape",
    "Tyranitar",
    "Ninetales",
    "Flygon",
    "Squirtle",
    "Ampharos",
    "Typhlosion",
    "Absol",
    "Dragonite",
    "Eevee",

  ];
  final recentpokemon = [
    "Luxray",
    "Torterra",
    "Snorlax",
    "Internape",
    "Tyranitar",
  ];
  @override
  List<Widget> buildActions(BuildContext context) {
    //actions for app bar
    return [
      IconButton(icon: Icon(Icons.clear), onPressed: (){
        query = "";
      })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {

    return IconButton(
        icon:AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress:transitionAnimation ,
        ) ,
        onPressed: (){
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return 
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList =query.isEmpty?recentpokemon:pokemones.where((p) => p.startsWith(query)).toList();

    return ListView.builder(itemBuilder: (context,index)=>ListTile(
      onTap: (){
        showResults(context);
      },
      // leading: Icon(Icons.),
      title: RichText(text: TextSpan(
        text: suggestionList[index].substring(0,query.length),
        style: TextStyle(
          color: Colors.black,fontWeight: FontWeight.bold,
        ),
        children: [TextSpan(
          text: suggestionList[index].substring(0,query.length),
          style: TextStyle(color: Colors.grey)
        ),],
      ),
      ),
    ),
      itemCount: suggestionList.length,
    );

  }

}

