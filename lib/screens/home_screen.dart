import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:flutter_api_login/services/firebase_auth_methods.dart';
import '../models/quotesModel.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  Future<List<Quote>> _getUser() async {
    var url = Uri.parse("https://type.fit/api/quotes");
    http.Response quotes = await http.get(url);

    var jsonData = json.decode(quotes.body);

    List<Quote> listOfQuotes = [];

    for (var u in jsonData) {
      Quote quote = Quote(u["text"], u["author"]);
      if (quote.author != null && quote.text != null) {
        listOfQuotes.add(quote);
      }
    }
    return listOfQuotes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              context.read<FireBaseAuthMethods>().signOut(context);
            },
          ),
        ],
        title: Text(
          "Quotes",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Container(
          child: FutureBuilder(
            future: _getUser(),
            builder: (BuildContext context, AsyncSnapshot snapShot) {
              return snapShot.data == null
                  ? CircularProgressIndicator()
                  : ListView.builder(
                      itemCount: snapShot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(snapShot.data[index].text),
                          subtitle: Text(snapShot.data[index].author),
                        );
                      });
            },
          ),
        ),
      ),
    );
  }
}
