class FormularioData {
  final String reservationGraceInMinutes;
  final String reservationFeeRate;
  final String name;
  final String address;
  final String cancellationFeeRate;
  final String hourlyParkingRate;

  FormularioData({
    required this.reservationGraceInMinutes,
    required this.reservationFeeRate,
    required this.name,
    required this.address,
    required this.cancellationFeeRate,
    required this.hourlyParkingRate,
  });
}