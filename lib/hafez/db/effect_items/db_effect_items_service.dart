import '../../model/effects_items_model.dart';
import 'db_effect_items_helper.dart';

class DBEffectsItemsService {
  Future<List<EffectsItemsModel>> getEffectsItems() async {
    await DBEffectsItemsHelper.init();
    List<Map<String, dynamic>> effectsItems =
    await DBEffectsItemsHelper.query("effectsItems");

    return effectsItems.map((item) => EffectsItemsModel(
      id: item['id'],
      title: item['title'],
      urlSlug: item['urlSlug'],
      excerpt: item['excerpt']
    )).toList();

  }

  Future<bool> addEffectsItems(EffectsItemsModel model) async {
    await DBEffectsItemsHelper.init();
    int ret = await DBEffectsItemsHelper.insert('effectsItems', model);
    return ret > 0 ? true : false;
  }
}
