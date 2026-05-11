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

    // API returns "trip_date" — also keep legacy fallbacks
    final rawDate = json['trip_date']?.toString() ??
        json['date']?.toString() ??
        json['createdAt']?.toString() ??
        json['tripDate']?.toString() ??
        '';

    if (rawDate.isNotEmpty) {
      try {
        // "2026-05-06 22:32:21" is not strict ISO-8601; replace space with T
        final normalized = rawDate.contains('T') ? rawDate : rawDate.replaceFirst(' ', 'T');
        final dt = DateTime.parse(normalized).toLocal();
        const months = [
          'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
          'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
        ];
        date = '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
        final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
        final m = dt.minute.toString().padLeft(2, '0');
        final period = dt.hour < 12 ? 'AM' : 'PM';
        time = '$h:$m $period';
      } catch (_) {
        date = rawDate;
      }
    }

    return TripRecord(
      from: json['fromStation']?.toString() ??
            json['from']?.toString() ??
            json['startStation']?.toString() ??
            '',
      to: json['toStation']?.toString() ??
          json['to']?.toString() ??
          json['endStation']?.toString() ??
          '',
      line: json['line']?.toString() ??
            json['metroLine']?.toString() ??
            json['lineName']?.toString() ??
            '',
      date: date,
      time: time,
      // API returns "totalPrice" — also keep legacy fallbacks
      price: double.tryParse(
              json['totalPrice']?.toString() ??
              json['price']?.toString() ??
              json['amount']?.toString() ??
              json['cost']?.toString() ??
              '0') ??
          0.0,
      // API returns "payment_method" — also keep legacy fallbacks
      paymentMethod: json['payment_method']?.toString() ??
                     json['paymentMethod']?.toString() ??
                     json['payment']?.toString() ??
                     'Wallet',
    );
  }
}