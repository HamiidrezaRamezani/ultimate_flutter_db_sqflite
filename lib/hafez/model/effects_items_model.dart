class EffectsItemsModel {
  int id;
  int favorite;
  int effectItemId;
  String title;
  String urlSlug;
  String excerpt;

  EffectsItemsModel(
      {this.id = 0,
      this.favorite = 0,
      required this.effectItemId,
      required this.title,
      required this.urlSlug,
      required this.excerpt});
}
