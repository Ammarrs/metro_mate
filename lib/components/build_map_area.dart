import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/nearest_metro/nearest_metro_cubit.dart';
import '../cubits/nearest_metro/nearest_metro_state.dart';

class buildMapArea extends StatefulWidget {
  const buildMapArea({super.key});

  @override
  State<buildMapArea> createState() => _buildMapAreaState();
}

class _buildMapAreaState extends State<buildMapArea> {
  // GoogleMapController? _mapController;

  @override
  void dispose() {
    // _mapController?.dispose();
    super.dispose();
  }

  // void _onMapCreated(GoogleMapController controller) {
  //   _mapController = controller;
  //   context.read<NearestMetroCubit>().setMapController(controller);
  //   print('✅ Map controller created');
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 233, 230, 230),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        child: BlocBuilder<NearestMetroCubit, NearestMetroState>(
          builder: (context, state) {
            if (state is NearestMetroLoading) return _buildLoading(state.message);
            if (state is NearestMetroLoaded) return _buildMap(state);
            if (state is NearestMetroError) return _buildError(state.message);
            if (state is NearestMetroPermissionDenied) return _buildPermissionDenied(state);
            if (state is NearestMetroLocationDisabled) return _buildLocationDisabled(state.message);
            return _buildPlaceholder();
          },
        ),
      ),
    );
  }

  Widget _buildMap(NearestMetroLoaded state) {
    print('🗺️ Building Google Map widget');
    return Stack(
      children: [
        // GoogleMap(
        //   onMapCreated: _onMapCreated,
        //   initialCameraPosition: state.initialCameraPosition,
        //   markers: state.markers,
        //   myLocationEnabled: false,
        //   myLocationButtonEnabled: false,
        //   zoomControlsEnabled: false,
        //   mapToolbarEnabled: false,
        //   compassEnabled: false,
        //   mapType: MapType.normal,
        //   liteModeEnabled: false,
        //   padding: const EdgeInsets.only(top: 40, bottom: 20),
        //   minMaxZoomPreference: const MinMaxZoomPreference(10, 20),
        // ),
        Positioned(
          top: 12,
          right: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F4F4).withOpacity(0.95),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.my_location, size: 14, color: Color(0xFF4ECDC4)),
                SizedBox(width: 4),
                Text(
                  "Live Location",
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoading(String? message) {
    return Container(
      color: const Color.fromARGB(255, 233, 230, 230),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF5B7C99)),
            ),
            if (message != null) ...[
              const SizedBox(height: 12),
              Text(message,
                  style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildError(String message) {
    return Container(
      color: const Color.fromARGB(255, 233, 230, 230),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 12),
              Text(message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280))),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => context.read<NearestMetroCubit>().refresh(),
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5B7C99),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionDenied(NearestMetroPermissionDenied state) {
    return Container(
      color: const Color.fromARGB(255, 233, 230, 230),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_off, size: 48, color: Colors.orange),
              const SizedBox(height: 12),
              const Text('Location Permission Required',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D3142))),
              const SizedBox(height: 8),
              Text(
                state.isPermanentlyDenied
                    ? 'Please enable location permission in settings'
                    : 'We need your location to find nearest metro',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => state.isPermanentlyDenied
                    ? context.read<NearestMetroCubit>().openLocationSettings()
                    : context.read<NearestMetroCubit>().refresh(),
                icon: Icon(
                    state.isPermanentlyDenied ? Icons.settings : Icons.refresh,
                    size: 18),
                label: Text(state.isPermanentlyDenied
                    ? 'Open Settings'
                    : 'Grant Permission'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5B7C99),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationDisabled(String message) {
    return Container(
      color: const Color.fromARGB(255, 233, 230, 230),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_disabled, size: 48, color: Colors.orange),
              const SizedBox(height: 12),
              const Text('Location Services Disabled',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D3142))),
              const SizedBox(height: 8),
              Text(message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () =>
                    context.read<NearestMetroCubit>().openLocationSettings(),
                icon: const Icon(Icons.settings, size: 18),
                label: const Text('Enable Location'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5B7C99),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: const Color.fromARGB(255, 233, 230, 230),
      child: Center(
        child: Container(
          width: 50,
          height: 50,
          decoration: const BoxDecoration(
            color: Color(0xFF5B7C99),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.location_on, color: Colors.white, size: 30),
        ),
      ),
    );
  }
}