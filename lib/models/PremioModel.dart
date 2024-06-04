class PremioModel {
  final String id;
  final int quantity;
  final int pointCost;
  final String name;
  final String description;
  final String url;
  final String imageUrl;
  final String expirationDate;

  PremioModel({
    required this.id,
    required this.quantity,
    required this.pointCost,
    required this.name,
    required this.description,
    required this.url,
    required this.imageUrl,
    required this.expirationDate
  });

  factory PremioModel.fromJson(Map<String, dynamic> json) {
    return PremioModel(
      id: json['id'],
      quantity: json['quantity'],
      pointCost: json['pointCost'],
      name: json['name'],
      description: json['description'],
      url: json['url'],
      imageUrl: json['imageUrl'],
      expirationDate: json['expirationDate']
    );
  }
}
