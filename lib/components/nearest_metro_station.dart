import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:second/generated/l10n.dart';
import '../cubits/nearest_metro/nearest_metro_cubit.dart';
import '../services/location_services.dart';
import '../services/metro_services.dart';
import '../services/routing_service.dart';
import 'build_header.dart';
import 'build_station_info.dart';

class NearestMetroStation extends StatelessWidget {
  const NearestMetroStation({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NearestMetroCubit(
        locationService: LocationService(),
        metroService: MetroService(),
        routingService: RoutingService(),
      )..loadNearestMetro(),
      child: const _NearestMetroContent(),
    );
  }
}

class _NearestMetroContent extends StatelessWidget {
  const _NearestMetroContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: buildHeader(title: S.of(context).NearestMetroStation),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: IconButton(
                icon: const Icon(Icons.refresh, color: Color(0xFF5B7C99)),
                onPressed: () => context.read<NearestMetroCubit>().refresh(),
                tooltip: 'Refresh',
              ),
            ),
          ],
        ),
        Container(
          width: 500,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(80),
                blurRadius: 20,
                spreadRadius: 0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const buildStationInfo(),
        ),
      ],
    );
  }
}
