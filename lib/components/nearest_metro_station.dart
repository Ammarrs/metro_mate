import 'package:flutter/material.dart';

import 'build_header.dart';
import 'build_map_area.dart';
import 'build_station_info.dart';

class NearestMetroStation extends StatelessWidget {
  const NearestMetroStation({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        buildHeader(title: "Nearest Metro Station"),
        
        Container(
          width: double.infinity,
          constraints: BoxConstraints(
            maxWidth: 500,
            minHeight: screenHeight * 0.35,
          ),
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildMapArea(),
              buildStationInfo(),
            ],
          ),
        ),
      ],
    );
  }
}