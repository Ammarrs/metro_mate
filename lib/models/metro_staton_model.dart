class MetroStationModel {
  final String id;
  final String name;
  final int lineNumber;
  final int position;
  final bool isTransfer;
  final List<int> transferTo;
  final double? lat;
  final double? lng;
  double? distanceInKm;
  int? walkingTimeInMinutes;

  MetroStationModel({
    required this.id,
    required this.name,
    required this.lineNumber,
    required this.position,
    required this.isTransfer,
    required this.transferTo,
    this.lat,
    this.lng,
    this.distanceInKm,
    this.walkingTimeInMinutes,
  });

  factory MetroStationModel.fromAllStationsJson(Map<String, dynamic> json) {
    return MetroStationModel(
      id: json['_id']?.toString() ?? '',
      name: json['name'] ?? 'Unknown Station',
      lineNumber: (json['line_number'] ?? 0) as int,
      position: (json['position'] ?? 0) as int,
      isTransfer: json['is_transfer'] ?? false,
      transferTo: json['transfer_to'] != null ? List<int>.from(json['transfer_to']) : [],
      lat: null,
      lng: null,
    );
  }

  factory MetroStationModel.fromNearestStationJson(Map<String, dynamic> json) {
    return MetroStationModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? 'Unknown Station',
      lineNumber: (json['line'] ?? 0) as int,
      position: 0,
      isTransfer: false,
      transferTo: [],
      lat: (json['lat'] ?? 0.0).toDouble(),
      lng: (json['lng'] ?? 0.0).toDouble(),
    );
  }

  String get lineLabel => 'Line $lineNumber';

  String get transferLabel {
    if (!isTransfer || transferTo.isEmpty) return '';
    return 'Transfers to: ${transferTo.map((l) => 'Line $l').join(', ')}';
  }
}