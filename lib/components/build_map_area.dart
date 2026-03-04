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
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Container(
      height: screenHeight * 0.20, // Responsive height
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
        child: Stack(
          children: [
            // Center location icon
            Center(
              child: Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  color: Color(0xFF5B7C99),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.location_on,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
            
            // Live location badge
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
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
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 14,
                      color: Color(0xFF6B7280),
                    ),
                    SizedBox(width: 4),
                    Text(
                      "Live Location",
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}