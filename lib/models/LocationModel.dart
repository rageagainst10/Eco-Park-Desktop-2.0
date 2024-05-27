import 'ParkingSpaceModel.dart';

class LocationModel {
  final String id;
  final String name;
  final String address;
  final int reservationGraceInMinutes;
  final int cancellationFeeRate;
  final int reservationFeeRate;
  final int hourlyParkingRate;
  final List<ParkingSpaceModel> parkingSpaces;

  LocationModel({
    required this.id,
    required this.name,
    required this.address,
    required this.reservationGraceInMinutes,
    required this.cancellationFeeRate,
    required this.reservationFeeRate,
    required this.hourlyParkingRate,
    required this.parkingSpaces,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      reservationGraceInMinutes: json['reservationGraceInMinutes'],
      cancellationFeeRate: json['cancellationFeeRate'],
      reservationFeeRate: json['reservationFeeRate'],
      hourlyParkingRate: json['hourlyParkingRate'],
      parkingSpaces: List<ParkingSpaceModel>.from(
        json['parkingSpaces'].map((x) => ParkingSpaceModel.fromJson(x)),
      ),
    );
  }
}