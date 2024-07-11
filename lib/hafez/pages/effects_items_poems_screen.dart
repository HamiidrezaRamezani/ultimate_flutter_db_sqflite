import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../db/effect/db_effect_service.dart';
import '../model/effects_items_verse_model.dart';
import 'bookmark_items_screen.dart';

class EffectsItemsPoemsScreen extends StatefulWidget {
  final int effectsItemId;

  const EffectsItemsPoemsScreen({Key? key, required this.effectsItemId})
      : super(key: key);

  @override
  State<EffectsItemsPoemsScreen> createState() =>
      _EffectsItemsPoemsScreenState();
}

class _EffectsItemsPoemsScreenState extends State<EffectsItemsPoemsScreen> {
  List<EffectsItemsVerseModel> effectsItemsVerseList = [];
  late DBEffectService dbEffectService;
  bool isBookMark = false;

  @override
  void initState() {
    dbEffectService = DBEffectService();
    getDataFromDB();
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
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => BookMarkItemsScreen()));
          },
        ),
      ),
      body: (effectsItemsVerseList.isEmpty)
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: ListView.builder(
                  itemCount: effectsItemsVerseList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      alignment: (index % 2 == 0)
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          effectsItemsVerseList[index].text,
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
    effectsItemsVerseList.clear();
    var url = Uri.parse(
        'https://api.ganjoor.net/api/ganjoor/poem/${widget.effectsItemId.toString()}?catInfo=false&catPoems=false&comments=false&rhymes=false&recitations=false&images=false&songs=false&relatedpoems=false');

    var response = await http.get(url);

    var result;
    if (response.statusCode == 200) {
      setState(() {
        result = jsonDecode(response.body);
      });

      result['verses'].forEach((element) {
        var effect = EffectsItemsVerseModel(
            effectsItemId: widget.effectsItemId,
            text: element['text'],
            coupletSummary: element['coupletSummary']);
        effectsItemsVerseList.add(effect);
        dbEffectService.addEffectsItemsVerse(effect);
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  bool getDataFromDB() {
    var future = dbEffectService.getEffectsItemsVerse(widget.effectsItemId);
    future.then((value) {
      for (var element in value) {
        effectsItemsVerseList.add(EffectsItemsVerseModel(
            id: element.id,
            effectsItemId: element.effectsItemId,
            coupletSummary: element.coupletSummary,
            text: element.text));
      }
      if (value.isEmpty) getDataFromServer();

      if (effectsItemsVerseList.isNotEmpty) {
        setState(() {});
      }
    });

    return effectsItemsVerseList.isEmpty;
  }
}
