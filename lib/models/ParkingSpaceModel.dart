class ParkingSpaceModel {
  final String id;
  final int floor;
  final String name;
  final bool isOccupied;
  final String type;

  ParkingSpaceModel({
    required this.id,
    required this.floor,
    required this.name,
    required this.isOccupied,
    required this.type,
  });

  factory ParkingSpaceModel.fromJson(Map<String, dynamic> json) {
    return ParkingSpaceModel(
      id: json['id'],
      floor: json['floor'],
      name: json['name'],
      isOccupied: json['isOccupied'],
      type: json['type'],
    );
  }
}
