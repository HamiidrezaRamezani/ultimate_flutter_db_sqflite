import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ultimate_flutter_db_sqflite/hafez/db/effect/db_effect_service.dart';
import 'package:ultimate_flutter_db_sqflite/hafez/pages/effects_items_poems_screen.dart';
import '../model/effects_items_model.dart';
import 'bookmark_items_screen.dart';

class EffectsItemsScreen extends StatefulWidget {
  final String slugUrl;

  const EffectsItemsScreen({Key? key, required this.slugUrl}) : super(key: key);

  @override
  State<EffectsItemsScreen> createState() => _EffectsItemsScreenState();
}

class _EffectsItemsScreenState extends State<EffectsItemsScreen> {
  List<EffectsItemsModel> effectsItemsList = [];

  late DBEffectService dbEffectService;

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
      body: (effectsItemsList.isEmpty)
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: effectsItemsList.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EffectsItemsPoemsScreen(
                                    effectsItemsModel:
                                        effectsItemsList[index],
                                  )));
                    },
                    child: Card(
                      child: SizedBox(
                        height: 75.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  effectsItemsList[index].title,
                                  style: TextStyle(
                                      fontSize: (widget.slugUrl == 'ghazal')
                                          ? 24.0
                                          : 16.0),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  effectsItemsList[index].excerpt,
                                  style: const TextStyle(fontSize: 18.0),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
    );
  }

  getDataFromServer() async {

    effectsItemsList.clear();
    var url = Uri.parse(
        'https://api.ganjoor.net/api/ganjoor/page?url=%2Fhafez%2F${widget.slugUrl}&catPoems=true');

    var response = await http.get(url);

    var result;
    if (response.statusCode == 200) {
      setState(() {
        result = jsonDecode(response.body);
      });


      result['poetOrCat']['cat']['poems'].forEach((element) {
        var effectItems = EffectsItemsModel(
            title: element['title'],
            urlSlug: widget.slugUrl,
            effectItemId: element['id'],
            excerpt: element['excerpt']);
        effectsItemsList.add(effectItems);
        dbEffectService.addEffectsItems(effectItems);
      });
    } else {
    }
  }

  bool getDataFromDB() {
    var future = dbEffectService.getEffectsItems("urlSlug", widget.slugUrl);
    future.then((value) {
      for (var element in value) {
        effectsItemsList.add(EffectsItemsModel(
            id: element.id,
            title: element.title,
            effectItemId: element.effectItemId,
            urlSlug: element.urlSlug,
            favorite: element.favorite,
            excerpt: element.excerpt));
      }
      if (value.isEmpty) getDataFromServer();

      if (effectsItemsList.isNotEmpty) {
        setState(() {});
      }
    });

    return effectsItemsList.isEmpty;
  }
}
