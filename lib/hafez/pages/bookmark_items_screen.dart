import 'package:flutter/material.dart';
import 'package:ultimate_flutter_db_sqflite/hafez/pages/effects_items_poems_screen.dart';

import '../db/effect/db_effect_service.dart';
import '../model/effects_items_model.dart';

class BookMarkItemsScreen extends StatefulWidget {
  EffectsItemsModel? effectsItemsModel;
  BookMarkItemsScreen({this.effectsItemsModel, Key? key}) : super(key: key);


  @override
  State<BookMarkItemsScreen> createState() => _BookMarkItemsScreenState();
}

class _BookMarkItemsScreenState extends State<BookMarkItemsScreen> {
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
    return WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, 'refresh');
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.yellow,
            title: const Text('علاقه مندی ها'),
          ),
          body: ListView.builder(
              itemCount: effectsItemsList.length,
              itemBuilder: (BuildContext context, int index) {
                return Directionality(
                  textDirection: TextDirection.rtl,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EffectsItemsPoemsScreen(
                                  effectsItemsModel: effectsItemsList[index])));
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                                child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(effectsItemsList[index].title)
                                  ],
                                ),
                                SizedBox(
                                  height: 12.0,
                                ),
                                Row(
                                  children: [
                                    Text(effectsItemsList[index].excerpt)
                                  ],
                                )
                              ],
                            )),
                            IconButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          backgroundColor: Colors.grey,
                                          title: Text(
                                              'آیا میخواهید این ایتم حذف شود؟'),
                                          actions: [
                                            ElevatedButton(
                                                onPressed: () {
                                                  if (widget.effectsItemsModel != null) {
                                                    if (widget.effectsItemsModel!.effectItemId == effectsItemsList[index].effectItemId) {
                                                      widget.effectsItemsModel!.favorite = 0;
                                                    }
                                                  }
                                                  effectsItemsList[index]
                                                      .favorite = 0;
                                                  dbEffectService
                                                      .updateFavorite(
                                                          "effectsItems",
                                                          effectsItemsList[
                                                              index]);
                                                  setState(() {
                                                    effectsItemsList.remove(
                                                        effectsItemsList[
                                                            index]);
                                                  });
                                                  Navigator.pop(context);
                                                },
                                                child: Text('آری')),
                                            ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text('خیر')),
                                          ],
                                        );
                                      });
                                },
                                icon: const Icon(Icons.bookmark))
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
        ));
  }

  bool getDataFromDB() {
    var future = dbEffectService.getEffectsItems("favorite", "1");
    future.then((value) {
      for (var element in value) {
        effectsItemsList.add(EffectsItemsModel(
            id: element.id,
            title: element.title,
            effectItemId: element.effectItemId,
            urlSlug: element.urlSlug,
            excerpt: element.excerpt));
      }
      // if (value.isEmpty) getDataFromServer();

      if (effectsItemsList.isNotEmpty) {
        setState(() {});
      }
    });

    return effectsItemsList.isEmpty;
  }
}
