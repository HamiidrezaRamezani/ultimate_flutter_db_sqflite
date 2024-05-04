import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
                                    effectsItemId: effectsItemsList[index].id.toString(),
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
    print('get data from server');
    effectsItemsList.clear();
    var url = Uri.parse(
        'https://api.ganjoor.net/api/ganjoor/page?url=%2Fhafez%2F${widget.slugUrl}&catPoems=true');

    var response = await http.get(url);

    var result;
    if (response.statusCode == 200) {
      setState(() {
        result = jsonDecode(response.body);
      });

      print(result['poetOrCat']['cat']['poems']);

      result['poetOrCat']['cat']['poems'].forEach((element) {
        var effect = EffectsItemsModel(
            id: element['id'],
            title: element['title'],
            urlSlug: element['urlSlug'],
            excerpt: element['excerpt']);
        effectsItemsList.add(effect);
        // dbEffectService.addEffects(effect);
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }
}
