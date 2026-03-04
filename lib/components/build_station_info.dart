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
        if (state is NearestMetroLoading) return _buildLoading(state.message);
        if (state is NearestMetroLoaded) return _buildLoaded(context, state);
        if (state is NearestMetroError) return _buildError(context, state.message);
        if (state is NearestMetroPermissionDenied) return _buildPermissionDenied(context, state);
        if (state is NearestMetroLocationDisabled) return _buildLocationDisabled(context, state.message);
        return _buildInitial();
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            station.name,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3142),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
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
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 18, color: Color(0xFF6B7280)),
              const SizedBox(width: 4),
              Text(distanceText, style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280))),
              const SizedBox(width: 16),
              const Icon(Icons.directions_walk, size: 18, color: Color(0xFF6B7280)),
              const SizedBox(width: 4),
              Text(walkingTimeText, style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280))),
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
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
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

  Future<void> _onGetDirections(BuildContext context, NearestMetroLoaded state) async {
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
        originLat: state.userLatitude,
        originLng: state.userLongitude,
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
      padding: const EdgeInsets.all(40),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF5B7C99)),
            ),
            if (message != null) ...[
              const SizedBox(height: 16),
              Text(
                message,
                style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Error Loading Station',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF2D3142)),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => context.read<NearestMetroCubit>().refresh(),
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5B7C99),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionDenied(BuildContext context, NearestMetroPermissionDenied state) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.location_off, size: 48, color: Colors.orange),
            const SizedBox(height: 16),
            const Text(
              'Location Permission Required',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF2D3142)),
            ),
            const SizedBox(height: 8),
            Text(
              state.isPermanentlyDenied
                  ? 'Please enable location permission in settings'
                  : 'We need your location to find nearest metro',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => state.isPermanentlyDenied
                  ? context.read<NearestMetroCubit>().openLocationSettings()
                  : context.read<NearestMetroCubit>().refresh(),
              icon: Icon(state.isPermanentlyDenied ? Icons.settings : Icons.refresh, size: 18),
              label: Text(state.isPermanentlyDenied ? 'Open Settings' : 'Grant Permission'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5B7C99),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationDisabled(BuildContext context, String message) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.location_disabled, size: 48, color: Colors.orange),
            const SizedBox(height: 16),
            const Text(
              'Location Services Disabled',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF2D3142)),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => context.read<NearestMetroCubit>().openLocationSettings(),
              icon: const Icon(Icons.settings, size: 18),
              label: const Text('Enable Location'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5B7C99),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInitial() {
    return const Padding(
      padding: EdgeInsets.all(40),
      child: Center(
        child: Text(
          'Finding nearest station...',
          style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
        ),
      ),
    );
  }
}