import 'package:flutter/material.dart';

/// Status of a water leakage complaint
enum ComplaintStatus {
  pending,
  inProgress,
  resolved;

  String get displayName {
    switch (this) {
      case ComplaintStatus.pending:
        return 'Pending';
      case ComplaintStatus.inProgress:
        return 'In Progress';
      case ComplaintStatus.resolved:
        return 'Resolved';
    }
  }

  Color get color {
    switch (this) {
      case ComplaintStatus.pending:
        return Colors.orange.shade700;
      case ComplaintStatus.inProgress:
        return Colors.blue.shade700;
      case ComplaintStatus.resolved:
        return Colors.green.shade700;
    }
  }

  Color get backgroundColor {
    switch (this) {
      case ComplaintStatus.pending:
        return Colors.orange.shade50;
      case ComplaintStatus.inProgress:
        return Colors.blue.shade50;
      case ComplaintStatus.resolved:
        return Colors.green.shade50;
    }
  }

  IconData get icon {
    switch (this) {
      case ComplaintStatus.pending:
        return Icons.hourglass_top_rounded;
      case ComplaintStatus.inProgress:
        return Icons.engineering_rounded;
      case ComplaintStatus.resolved:
        return Icons.check_circle_rounded;
    }
  }
}

/// Model class representing a reported water leakage complaint
class Complaint {
  final String id;
  final String citizenName;
  final String location;
  final String leakageType;
  final String description;
  final String dateReported;
  ComplaintStatus status;
  final String? imageTag;

  Complaint({
    required this.id,
    required this.citizenName,
    required this.location,
    required this.leakageType,
    required this.description,
    required this.dateReported,
    this.status = ComplaintStatus.pending,
    this.imageTag,
  });

  /// Factory helper for creating initial sample complaints
  static List<Complaint> getSampleComplaints() {
    return [
      Complaint(
        id: 'WLR-1001',
        citizenName: 'Rahul Sharma',
        location: 'Sector 14 Market, Near State Bank ATM',
        leakageType: 'Pipe Leakage',
        description: 'Underground main supply pipe cracked. Continuous clean drinking water flowing onto the road since morning.',
        dateReported: '2026-10-24',
        status: ComplaintStatus.inProgress,
        imageTag: 'Road pipe burst',
      ),
      Complaint(
        id: 'WLR-1002',
        citizenName: 'Priya Patel',
        location: 'Gandhi Nagar Community Park, Gate 2',
        leakageType: 'Broken Public Tap',
        description: 'Public drinking water tap handle broken and jammed open. Water flowing non-stop into drain.',
        dateReported: '2026-10-25',
        status: ComplaintStatus.pending,
        imageTag: 'Public tap broken',
      ),
      Complaint(
        id: 'WLR-1003',
        citizenName: 'Amit Verma',
        location: 'Civil Lines Housing Board, Building C',
        leakageType: 'Overflowing Water Tank',
        description: 'Rooftop municipal water reservoir float valve is malfunctioning, causing heavy water overflow for 2 hours.',
        dateReported: '2026-10-25',
        status: ComplaintStatus.resolved,
        imageTag: 'Overhead tank overflow',
      ),
      Complaint(
        id: 'WLR-1004',
        citizenName: 'Sneha Kulkarni',
        location: 'Bus Stand Junction, Crossroad 4',
        leakageType: 'Pipe Leakage',
        description: 'Roadside water line damaged during road repair work. Large pool of water forming and blocking pedestrian walkway.',
        dateReported: '2026-10-26',
        status: ComplaintStatus.inProgress,
        imageTag: 'Road pipeline breach',
      ),
      Complaint(
        id: 'WLR-1005',
        citizenName: 'Mohammed Zaid',
        location: 'Railway Colony, Near Primary School',
        leakageType: 'Broken Public Tap',
        description: 'Municipal water standpost is leaking from the base connector. Muddy water pooling near school entrance.',
        dateReported: '2026-10-26',
        status: ComplaintStatus.pending,
        imageTag: 'Standpost leak',
      ),
      Complaint(
        id: 'WLR-1006',
        citizenName: 'Ananya Roy',
        location: 'Model Town, Park View Apartments, Street 7',
        leakageType: 'Other',
        description: 'Fire hydrant valve leaking water pressurized stream along the sidewalk.',
        dateReported: '2026-10-27',
        status: ComplaintStatus.resolved,
        imageTag: 'Hydrant leak',
      ),
      Complaint(
        id: 'WLR-1007',
        citizenName: 'Karthik Subramanian',
        location: 'Nehru Nagar, Near Municipal Ward Office',
        leakageType: 'Pipe Leakage',
        description: 'High pressure leakage from water supply joint. Water spraying up to 2 feet in the air.',
        dateReported: '2026-10-27',
        status: ComplaintStatus.pending,
        imageTag: 'High pressure pipe leak',
      ),
      Complaint(
        id: 'WLR-1008',
        citizenName: 'Sunita Mehra',
        location: 'Subhash Marg, Opposite Government Dispensary',
        leakageType: 'Overflowing Water Tank',
        description: 'Dispensary water storage tank continuously overflowing since 6 AM. Clean water being wasted.',
        dateReported: '2026-10-28',
        status: ComplaintStatus.pending,
        imageTag: 'Tank overflow',
      ),
    ];
  }
}

