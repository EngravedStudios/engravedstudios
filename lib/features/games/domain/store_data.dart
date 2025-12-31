class StoreData {
  final double? price;
  final double? originalPrice;
  final int discountPercent;
  final String currency;
  final bool isFree;

  const StoreData({
    this.price,
    this.originalPrice,
    this.discountPercent = 0,
    this.currency = '\$',
    this.isFree = false,
  });
  
  bool get isDiscounted => discountPercent > 0;
  
  String get formattedPrice {
    if (isFree) return 'FREE';
    if (price == null) return '';
    return '$currency${price!.toStringAsFixed(2)}';
  }
}
