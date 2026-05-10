// lib/models/crowdedness_level.dart
//
// Maps the raw color string from the API to a display label + colour.
// API returns: "GREEN" | "YELLOW" | "RED"
// Endpoint:    GET /api/v1/neareststation/crowding/{lat}/{lng}?stationName=xxx
// Response:    { "status": "success", "data": { "color": "YELLOW" } }

import 'package:flutter/material.dart';

enum CrowdednessLevel {
  low     (label: 'Not Crowded', color: Color(0xFF22C55E)),  // API → "GREEN"
  moderate(label: 'Moderate',    color: Color(0xFFF59E0B)),  // API → "YELLOW"
  high    (label: 'Crowded',     color: Color(0xFFEF4444));  // API → "RED"

  const CrowdednessLevel({required this.label, required this.color});

  final String label;
  final Color  color;

  // Maps the raw uppercase color string from the API to an enum value.
  // Unknown values default to moderate so the UI never crashes.
  static CrowdednessLevel fromApi(String? raw) {
    switch (raw?.toUpperCase().trim()) {
      case 'GREEN' : return CrowdednessLevel.low;
      case 'YELLOW': return CrowdednessLevel.moderate;
      case 'RED'   : return CrowdednessLevel.high;
      default      : return CrowdednessLevel.moderate;
    }
  }
}