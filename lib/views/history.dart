import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:second/generated/l10n.dart';
import '../cubits/history/history_cubit.dart';
import '../cubits/history/history_state.dart';
import '../models/trip_record.dart';
import '../services/history_service.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HistoryCubit(HistoryService())..loadHistory(),
      child: const _HistoryContent(),
    );
  }
}

class _HistoryContent extends StatefulWidget {
  const _HistoryContent();
  @override
  State<_HistoryContent> createState() => _HistoryContentState();
}

class _HistoryContentState extends State<_HistoryContent> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<TripRecord> _filter(List<TripRecord> trips) {
    if (_query.isEmpty) return trips;
    final q = _query.toLowerCase();
    return trips
        .where((t) =>
            t.from.toLowerCase().contains(q) ||
            t.to.toLowerCase().contains(q) ||
            t.line.toLowerCase().contains(q))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: BlocBuilder<HistoryCubit, HistoryState>(
              builder: (context, state) {
                if (state is HistoryLoading) {
                  return const Center(
                      child:
                          CircularProgressIndicator(color: Color(0xFF4A6FA5)));
                }
                if (state is HistoryError) {
                  return Center(
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                    const Icon(Icons.wifi_off,
                        color: Color(0xFF8FA8BE), size: 48),
                    const SizedBox(height: 12),
                    Text(state.message,
                        style: const TextStyle(color: Color(0xFF8FA8BE))),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () =>
                          context.read<HistoryCubit>().loadHistory(),
                      child: Text(S.of(context).retry),
                    ),
                  ]));
                }
                if (state is HistoryLoaded) {
                  final filtered = _filter(state.trips);
                  if (filtered.isEmpty) {
                    return Center(
                        child:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                      const Icon(Icons.history,
                          color: Color(0xFF8FA8BE), size: 48),
                      const SizedBox(height: 12),
                      Text(
                        _query.isEmpty
                            ? S.of(context).noTripsYet
                            : '${S.of(context).noTripsMatch} "$_query"',
                        style: const TextStyle(
                            color: Color(0xFF8FA8BE), fontSize: 15),
                      ),
                    ]));
                  }
                  return RefreshIndicator(
                    color: const Color(0xFF4A6FA5),
                    onRefresh: () => context.read<HistoryCubit>().loadHistory(),
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      itemCount: filtered.length,
                      itemBuilder: (_, i) => _TripCard(trip: filtered[i]),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
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
              Row(children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(S.of(context).history,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold)),
                  Text(S.of(context).ViewYourRecentTrips,
                      style: TextStyle(color: Colors.white70, fontSize: 13)),
                ]),
              ]),
              const SizedBox(height: 12),
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
                    decoration: InputDecoration(
                      hintText: S.of(context).searchRoutes,
                      hintStyle: TextStyle(color: Colors.white70),
                      prefixIcon: Icon(Icons.search, color: Colors.white70),
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
    );
  }
}

class _TripCard extends StatelessWidget {
  final TripRecord trip;
  const _TripCard({required this.trip});

  Color get _lineColor {
    final l = trip.line.toLowerCase();
    if (l.contains('1')) return const Color(0xFF4A6FA5);
    if (l.contains('2')) return const Color(0xFF5BC8E8);
    if (l.contains('3')) return const Color(0xFF27AE60);
    return const Color(0xFF5B7C99);
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
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(
              child: Row(children: [
            const Icon(Icons.location_on_outlined,
                color: Color(0xFF5B7C99), size: 18),
            const SizedBox(width: 4),
            Expanded(
                child: Text('${trip.from} → ${trip.to}',
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A2E3D)),
                    overflow: TextOverflow.ellipsis)),
          ])),
          const SizedBox(width: 8),
          Text('${S.of(context).egp} ${trip.price.toStringAsFixed(2)}',
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF4A6FA5))),
        ]),
        const SizedBox(height: 10),
        Wrap(
            spacing: 10,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              if (trip.line.isNotEmpty)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                      color: _lineColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20)),
                  child: Text(trip.line,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _lineColor)),
                ),
              if (trip.date.isNotEmpty)
                Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.calendar_today_outlined,
                      size: 13, color: Color(0xFF8FA8BE)),
                  const SizedBox(width: 4),
                  Text(trip.date,
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF8FA8BE))),
                ]),
              if (trip.time.isNotEmpty)
                Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.access_time,
                      size: 13, color: Color(0xFF8FA8BE)),
                  const SizedBox(width: 4),
                  Text(trip.time,
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF8FA8BE))),
                ]),
              if (trip.paymentMethod.isNotEmpty)
                Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.credit_card,
                      size: 13, color: Color(0xFF8FA8BE)),
                  const SizedBox(width: 4),
                  Text(trip.paymentMethod,
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF8FA8BE))),
                ]),
            ]),
      ]),
    );
  }
}
