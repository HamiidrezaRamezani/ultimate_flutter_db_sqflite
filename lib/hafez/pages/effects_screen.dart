import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ultimate_flutter_db_sqflite/hafez/pages/bookmark_items_screen.dart';
import 'package:ultimate_flutter_db_sqflite/hafez/pages/effects_items_screen.dart';

import '../db/db_effect_service.dart';
import '../model/effect_model.dart';

class EffectScreen extends StatefulWidget {
  const EffectScreen({Key? key}) : super(key: key);

  @override
  State<EffectScreen> createState() => _EffectScreenState();
}

class _EffectScreenState extends State<EffectScreen> {
  List<EffectModel> effectsItems = [];

  late DBEffectService dbEffectService;

  @override
  void initState() {
    super.initState();
    dbEffectService = DBEffectService();
    getDataFromDB();
    // getDataFromServer();
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
        body: (effectsItems.isEmpty)
            ? CircularProgressIndicator()
            : ListView.builder(
                itemCount: effectsItems.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EffectsItemsScreen(
                                      slugUrl: effectsItems[index].slugUrl,
                                    )));
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            effectsItems[index].title,
                            style: TextStyle(fontSize: 25),
                          ),
                        ),
                      ),
                    ),
                  );
                }));
  }

  getDataFromServer() async {
    print('get data from server');
    effectsItems.clear();
    var url =
        Uri.parse('https://api.ganjoor.net/api/ganjoor/poet?url=%2Fhafez');

    var response = await http.get(url);

    var result;
    if (response.statusCode == 200) {
      setState(() {
        result = jsonDecode(response.body);
      });
      result['cat']['children'].forEach((element) {
        var effect = EffectModel(
            id: element['id'],
            title: element['title'],
            slugUrl: element['urlSlug']);
        effectsItems.add(effect);
        dbEffectService.addEffects(effect);
      });
      print(result['cat']['children']);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  bool getDataFromDB() {
    var future = dbEffectService.getEffect();
    future.then((value) {
      for (var element in value) {
        effectsItems.add(EffectModel(
            id: element.id, title: element.title, slugUrl: element.slugUrl));
        print('${element.id}  121212121');
      }
      if (value.isEmpty) getDataFromServer();

      if (effectsItems.isNotEmpty) {
        setState(() {});
      }
    });

    return effectsItems.isEmpty;
  }
}
