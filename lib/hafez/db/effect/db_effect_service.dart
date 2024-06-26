import 'dart:convert';

import 'package:ultimate_flutter_db_sqflite/hafez/model/effect_model.dart';
import 'package:ultimate_flutter_db_sqflite/hafez/db/effect/db_effect_helper.dart';

import '../../model/effects_items_model.dart';

class DBEffectService {
  Future<List<EffectModel>> getEffect() async {
    await DBEffectHelper.init();
    List<Map<String, dynamic>> effects =
    await DBEffectHelper.query("effects");

    return effects.map((item) => EffectModel(
      id: item['id'],
      title: item['title'],
      slugUrl: item['slugUrl']
    )).toList();

  }

  Future<List<EffectsItemsModel>> getEffectsItems() async {
    await DBEffectHelper.init();
    List<Map<String, dynamic>> effectsItems =
    await DBEffectHelper.query("effectsItems");

    return effectsItems.map((item) => EffectsItemsModel(
        id: item['id'],
        title: item['title'],
        urlSlug: item['urlSlug'],
        excerpt: item['excerpt']
    )).toList();

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
