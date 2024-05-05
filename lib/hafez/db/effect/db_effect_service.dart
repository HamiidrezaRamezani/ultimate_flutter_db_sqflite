import 'dart:convert';

import 'package:ultimate_flutter_db_sqflite/hafez/model/effect_model.dart';
import 'package:ultimate_flutter_db_sqflite/hafez/db/effect/db_effect_helper.dart';

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

  Future<bool> addEffects(EffectModel model) async {
    await DBEffectHelper.init();
    int ret = await DBEffectHelper.insert('effects', model);
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
