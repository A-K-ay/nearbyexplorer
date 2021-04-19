class Shop {
  final String name, currency, slug, imgUrl;
  final List tag;
  final bool active;
  final double appPricing, labourPricing;

  Shop({
    this.name,
    this.currency,
    this.slug,
    this.tag,
    this.active,
    this.appPricing,
    this.labourPricing,
    this.imgUrl,
  });
}
