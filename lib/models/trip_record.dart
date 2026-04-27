class TripRecord {
  final String from;
  final String to;
  final String line;
  final String date;
  final String time;
  final double price;
  final String paymentMethod;

  const TripRecord({
    required this.from,
    required this.to,
    required this.line,
    required this.date,
    required this.time,
    required this.price,
    required this.paymentMethod,
  });

  factory TripRecord.fromJson(Map<String, dynamic> json) {
    String date = '';
    String time = '';

    final rawDate = json['date']?.toString() ??
        json['createdAt']?.toString() ??
        json['tripDate']?.toString() ?? '';

    if (rawDate.isNotEmpty) {
      try {
        final dt = DateTime.parse(rawDate).toLocal();
        const months = ['Jan','Feb','Mar','Apr','May','Jun',
                        'Jul','Aug','Sep','Oct','Nov','Dec'];
        date = '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
        final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
        final m = dt.minute.toString().padLeft(2, '0');
        final period = dt.hour < 12 ? 'AM' : 'PM';
        time = '$h:$m $period';
      } catch (_) {
        date = rawDate;
      }
    } else {
      date = json['date']?.toString() ?? '';
      time = json['time']?.toString() ?? '';
    }

    return TripRecord(
      from: json['from']?.toString() ??
            json['startStation']?.toString() ??
            json['fromStation']?.toString() ?? '',
      to:   json['to']?.toString() ??
            json['endStation']?.toString() ??
            json['toStation']?.toString() ?? '',
      line: json['line']?.toString() ??
            json['metroLine']?.toString() ??
            json['lineName']?.toString() ?? '',
      date: date,
      time: time,
      price: double.tryParse(
              json['price']?.toString() ??
              json['amount']?.toString() ??
              json['cost']?.toString() ?? '0') ?? 0.0,
      paymentMethod: json['paymentMethod']?.toString() ??
                     json['payment']?.toString() ?? 'Wallet',
    );
  }
}