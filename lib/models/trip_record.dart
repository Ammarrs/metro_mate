class TripRecord {
  final String from;
  final String to;
  final String line;
  final String date;
  final String time;
  final double price;
  final String paymentMethod; // 'Wallet' | 'Card'

  const TripRecord({
    required this.from,
    required this.to,
    required this.line,
    required this.date,
    required this.time,
    required this.price,
    required this.paymentMethod,
  });
}