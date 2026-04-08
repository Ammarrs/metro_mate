import 'package:flutter/material.dart';
import '../models/trip_record.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  // TODO: Replace with real API data from your backend
  final List<TripRecord> _allTrips = const [
    TripRecord(
        from: 'Sadat',
        to: 'Attaba',
        line: 'Line 1',
        date: 'Oct 25, 2025',
        time: '09:30 AM',
        price: 8.00,
        paymentMethod: 'Wallet'),
    TripRecord(
        from: 'Opera',
        to: 'Shohadaa',
        line: 'Line 2',
        date: 'Oct 24, 2025',
        time: '02:15 PM',
        price: 8.00,
        paymentMethod: 'Card'),
    TripRecord(
        from: 'Zamalek',
        to: 'Nasser',
        line: 'Line 3',
        date: 'Oct 23, 2025',
        time: '11:45 AM',
        price: 6.00,
        paymentMethod: 'Wallet'),
    TripRecord(
        from: 'Kit Kat',
        to: 'Saad Zaghlool',
        line: 'Line 1',
        date: 'Oct 22, 2025',
        time: '05:20 PM',
        price: 10.00,
        paymentMethod: 'Wallet'),
  ];

  List<TripRecord> get _filtered {
    if (_query.isEmpty) return _allTrips;
    final q = _query.toLowerCase();
    return _allTrips
        .where((t) =>
            t.from.toLowerCase().contains(q) ||
            t.to.toLowerCase().contains(q) ||
            t.line.toLowerCase().contains(q))
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      body: Column(
        children: [
          // ── Gradient Header ──────────────────────────────────────────────
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xFF4A6FA5), Color(0xFF5BC8E8)],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 16, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back button + title
                    Row(
                      children: [
                        IconButton(
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('History',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold)),
                            Text('Your recent trips',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 13)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Search bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Container(
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (v) => setState(() => _query = v),
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            hintText: 'Search routes...',
                            hintStyle: TextStyle(color: Colors.white70),
                            prefixIcon:
                                Icon(Icons.search, color: Colors.white70),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Trip list ────────────────────────────────────────────────────
          Expanded(
            child: _filtered.isEmpty
                ? const Center(
                    child: Text('No trips found',
                        style:
                            TextStyle(color: Color(0xFF8FA8BE), fontSize: 15)),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    itemCount: _filtered.length,
                    itemBuilder: (context, index) =>
                        _TripCard(trip: _filtered[index]),
                  ),
          ),
        ],
      ),
    );
  }
}

// ── Trip card ─────────────────────────────────────────────────────────────────

class _TripCard extends StatelessWidget {
  final TripRecord trip;
  const _TripCard({required this.trip});

  Color get _lineColor {
    switch (trip.line) {
      case 'Line 1':
        return const Color(0xFF4A6FA5);
      case 'Line 2':
        return const Color(0xFF5BC8E8);
      case 'Line 3':
        return const Color(0xFF27AE60);
      default:
        return const Color(0xFF5B7C99);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Route + price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.location_on_outlined,
                      color: Color(0xFF5B7C99), size: 18),
                  const SizedBox(width: 4),
                  Text('${trip.from} → ${trip.to}',
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A2E3D))),
                ],
              ),
              Text('EGP ${trip.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF4A6FA5))),
            ],
          ),
          const SizedBox(height: 10),
          // Line chip + date + time + payment
          Wrap(
            spacing: 10,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              // Line chip
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: _lineColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(trip.line,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _lineColor)),
              ),
              // Date
              Row(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.calendar_today_outlined,
                    size: 13, color: Color(0xFF8FA8BE)),
                const SizedBox(width: 4),
                Text(trip.date,
                    style: const TextStyle(
                        fontSize: 12, color: Color(0xFF8FA8BE))),
              ]),
              // Time
              Row(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.access_time,
                    size: 13, color: Color(0xFF8FA8BE)),
                const SizedBox(width: 4),
                Text(trip.time,
                    style: const TextStyle(
                        fontSize: 12, color: Color(0xFF8FA8BE))),
              ]),
              // Payment method
              Row(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.credit_card,
                    size: 13, color: Color(0xFF8FA8BE)),
                const SizedBox(width: 4),
                Text(trip.paymentMethod,
                    style: const TextStyle(
                        fontSize: 12, color: Color(0xFF8FA8BE))),
              ]),
            ],
          ),
        ],
      ),
    );
  }
}
