import 'package:flutter/material.dart';
import 'package:dota_stats/apiCalls.dart';
import 'package:dota_stats/models/playerResults.dart';
import 'package:dota_stats/screens/playerSearch/components/playerList.dart';

// TODO: implement as Singleton

class PlayerSearch extends StatefulWidget {
  PlayerSearch();
  @override
  _PlayerSearchState createState() => _PlayerSearchState();
}

class _PlayerSearchState extends State<PlayerSearch> {
  Future<PlayerResults> playerResults;
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(children: <Widget>[
      TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: 'Look up a Player:',
        ),
        onSubmitted: (String query) {
          setState(() {
            playerResults = fetchPlayerResults(controller.text);
          });
        },
      ),
      FutureBuilder<PlayerResults>(
        future: playerResults,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snapshot.connectionState == ConnectionState.done) {
            if ( snapshot.data.players.length == 0) {
              return Text("No profiles found. Try again");
            }
             return PlayerList(snapshot.data.players);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Expanded(
              child: Container(
                  color: Color.fromRGBO(3, 20, 31, 1)
                  ));
  },
      )
    ]));
  }
}
