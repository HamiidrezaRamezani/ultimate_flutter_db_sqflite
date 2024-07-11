class EffectsItemsModel {
  int id;
  int effectItemId;
  String title;
  String urlSlug;
  String excerpt;

  EffectsItemsModel(
      {this.id = 0,
      required this.effectItemId,
      required this.title,
      required this.urlSlug,
      required this.excerpt});
}
