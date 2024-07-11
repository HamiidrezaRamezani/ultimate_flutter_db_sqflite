class EffectsItemsVerseModel {
  int id;
  int effectsItemId;
  String text;
  String? coupletSummary;

  EffectsItemsVerseModel(
      {this.id = 0,
      required this.effectsItemId,
      required this.text,
      required this.coupletSummary});
}
