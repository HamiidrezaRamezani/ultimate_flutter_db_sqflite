import 'package:ultimate_flutter_db_sqflite/hafez/model/effect_model.dart';
import 'package:ultimate_flutter_db_sqflite/hafez/db/effect/db_effect_helper.dart';

import '../../model/effects_items_model.dart';
import '../../model/effects_items_verse_model.dart';

class DBEffectService {
  Future<List<EffectModel>> getEffect() async {
    await DBEffectHelper.init();
    List<Map<String, dynamic>> effects = await DBEffectHelper.query("effects");

    return effects
        .map((item) => EffectModel(
            id: item['id'], title: item['title'], slugUrl: item['slugUrl']))
        .toList();
  }

  Future<List<EffectsItemsModel>> getEffectsItems(String slugUrl) async {
    await DBEffectHelper.init();
    List<Map<String, dynamic>> effectsItems =
        await DBEffectHelper.customQuery("effectsItems", "urlSlug", [slugUrl]);

    return effectsItems
        .map((item) => EffectsItemsModel(
            id: item['id'],
            effectItemId: item['effectItemsId'],
            title: item['title'],
            urlSlug: item['urlSlug'],
            excerpt: item['excerpt']))
        .toList();
  }

  Future<List<EffectsItemsVerseModel>> getEffectsItemsVerse(
      int effectItemsId) async {
    await DBEffectHelper.init();
    List<Map<String, dynamic>> effectsItemsVerse =
        await DBEffectHelper.customQuery(
            "effectsItemsVerse", "effectItemsId", [effectItemsId.toString()]);

    return effectsItemsVerse
        .map((item) => EffectsItemsVerseModel(
            id: item['id'],
            text: item['text'],
            coupletSummary: item['coupletSummary'],
            effectsItemId: item['effectItemsId']))
        .toList();
  }

  Future<bool> addEffects(EffectModel model) async {
    await DBEffectHelper.init();
    int ret = await DBEffectHelper.insertEffects('effects', model);
    return ret > 0 ? true : false;
  }

  Future<bool> addEffectsItems(EffectsItemsModel model) async {
    await DBEffectHelper.init();
    int ret = await DBEffectHelper.insertEffectsItem('effectsItems', model);
    return ret > 0 ? true : false;
  }


  Future<bool> addEffectsItemsVerse(EffectsItemsVerseModel model) async {
    await DBEffectHelper.init();
    int ret = await DBEffectHelper.insertEffectsItemVerse('effectsItemsVerse', model);
    return ret > 0 ? true : false;
  }


// Future<bool> updateProduct(EffectModel model) async {
//   await DBEffectHelper.init();
//
//   int ret = await DBEffectHelper.update(EffectModel.table, model);
//
//   return ret > 0 ? true : false;
// }
//
// Future<bool> deleteProduct(EffectModel model) async {
//   await DBEffectHelper.init();
//
//   int ret = await DBEffectHelper.delete(EffectModel.table, model);
//
//   return ret > 0 ? true : false;
// }
}
