import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/nearest_metro/nearest_metro_cubit.dart';
import '../cubits/nearest_metro/nearest_metro_state.dart';
import '../utils/map_utils.dart';

class buildStationInfo extends StatelessWidget {
  const buildStationInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NearestMetroCubit, NearestMetroState>(
      builder: (context, state) {
        if (state is NearestMetroLoaded) return _buildLoaded(context, state);
        if (state is NearestMetroLoading) return _buildLoading(state.message);
        if (state is NearestMetroError) return _buildError(state.message);
        return _buildPlaceholder();
      },
    );
  }

  Widget _buildLoaded(BuildContext context, NearestMetroLoaded state) {
    final station = state.nearestStation;

    final distanceText = station.distanceInKm != null
        ? '${station.distanceInKm!.toStringAsFixed(1)} km'
        : 'N/A';

    final walkingTimeText = station.walkingTimeInMinutes != null
        ? '${station.walkingTimeInMinutes} min walk'
        : 'N/A';

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            station.name,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3142),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF5B7C99).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  station.lineLabel,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF5B7C99),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (station.isTransfer && station.transferLabel.isNotEmpty) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4ECDC4).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.swap_horiz, size: 12, color: Color(0xFF4ECDC4)),
                      const SizedBox(width: 4),
                      Text(
                        station.transferLabel,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF4ECDC4),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 18, color: Color(0xFF6B7280)),
              const SizedBox(width: 4),
              Text(distanceText,
                  style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280))),
              const SizedBox(width: 16),
              const Icon(Icons.directions_walk, size: 18, color: Color(0xFF6B7280)),
              const SizedBox(width: 4),
              Text(walkingTimeText,
                  style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280))),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF5B7C99), Color(0xFF4ECDC4)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(37),
              ),
              child: ElevatedButton.icon(
                onPressed: () => _onGetDirections(context, state),
                icon: const Icon(Icons.navigation, size: 20),
                label: const Text(
                  "Get Directions",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  surfaceTintColor: Colors.transparent,
                  overlayColor: Colors.white.withOpacity(0.1),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(37),
                  ),
                  padding: EdgeInsets.zero,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onGetDirections(
      BuildContext context, NearestMetroLoaded state) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Opening Maps...'),
                ],
              ),
            ),
          ),
        ),
      );

      await MapUtils.openGoogleMapsDirections(
        originLat: state.userLocation.latitude,
        originLng: state.userLocation.longitude,
        destLat: state.nearestStation.lat!,
        destLng: state.nearestStation.lng!,
        travelMode: 'walking',
      );

      if (context.mounted) Navigator.of(context).pop();
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open maps: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildLoading(String? message) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 200, height: 28,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: 150, height: 16,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity, height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(37),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(String message) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Error Loading Station",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.red)),
          const SizedBox(height: 12),
          Text(message,
              style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280))),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return const Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Nearest Metro Station",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D3142))),
          SizedBox(height: 12),
          Text("Finding nearest station...",
              style: TextStyle(fontSize: 14, color: Color(0xFF6B7280))),
        ],
      ),
    );
  }
}