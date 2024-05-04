import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/effects_items_poems_model.dart';
import 'bookmark_items_screen.dart';

class EffectsItemsPoemsScreen extends StatefulWidget {
  final String effectsItemId;

  const EffectsItemsPoemsScreen({Key? key, required this.effectsItemId})
      : super(key: key);

  @override
  State<EffectsItemsPoemsScreen> createState() =>
      _EffectsItemsPoemsScreenState();
}

class _EffectsItemsPoemsScreenState extends State<EffectsItemsPoemsScreen> {
  List<EffectsItemsPoemsModel> effectsItemsPoemsList = [];

  bool isBookMark = false;

  @override
  void initState() {
    getDataFromServer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: Text('حافظ'),
        leading: IconButton(
          icon: Icon(Icons.bookmark),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BookMarkItemsScreen()));
          },
        ),
      ),
      body: (effectsItemsPoemsList.isEmpty)
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: ListView.builder(
                  itemCount: effectsItemsPoemsList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      alignment:
                          (effectsItemsPoemsList[index].versePosition % 2 == 0)
                              ? Alignment.centerLeft
                              : Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          effectsItemsPoemsList[index].text,
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ),
                    );
                  }),
            ),
      bottomSheet: Container(
        height: 50.0,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                onPressed: () {
                  setState(() {
                    isBookMark = !isBookMark;
                  });
                },
                icon: Icon((isBookMark == true)
                    ? Icons.bookmark
                    : Icons.bookmark_border))
          ],
        ),
      ),
    );
  }

  getDataFromServer() async {
    print('get data from server');
    effectsItemsPoemsList.clear();
    var url = Uri.parse(
        'https://api.ganjoor.net/api/ganjoor/poem/${widget.effectsItemId}?catInfo=false&catPoems=false&comments=false&rhymes=false&recitations=false&images=false&songs=false&relatedpoems=false');

    var response = await http.get(url);

    var result;
    if (response.statusCode == 200) {
      setState(() {
        result = jsonDecode(response.body);
      });

      print(result['verses']);

      result['verses'].forEach((element) {
        var effect = EffectsItemsPoemsModel(
            id: element['id'],
            versePosition: element['vOrder'],
            text: element['text'],
            poemsSummary: element['coupletSummary']);
        effectsItemsPoemsList.add(effect);
        // dbEffectService.addEffects(effect);
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }
}
