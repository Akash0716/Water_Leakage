import 'package:flutter/foundation.dart';
import '../models/complaint.dart';

/// Service managing in-memory water leakage complaints data.
/// Uses Flutter's built-in ChangeNotifier for reactive UI updates across screens.
class ComplaintService extends ChangeNotifier {
  // Singleton pattern for simple and reliable shared in-memory state
  static final ComplaintService _instance = ComplaintService._internal();
  factory ComplaintService() => _instance;

  ComplaintService._internal() {
    _complaints = Complaint.getSampleComplaints();
  }

  late List<Complaint> _complaints;
  int _counter = 1009;

  /// Get all complaints (latest first)
  List<Complaint> get complaints => List.unmodifiable(_complaints);

  /// Dashboard count statistics
  int get totalCount => _complaints.length;
  int get pendingCount =>
      _complaints.where((c) => c.status == ComplaintStatus.pending).length;
  int get inProgressCount =>
      _complaints.where((c) => c.status == ComplaintStatus.inProgress).length;
  int get resolvedCount =>
      _complaints.where((c) => c.status == ComplaintStatus.resolved).length;

  /// Generate next unique complaint ID
  String generateNextId() {
    final id = 'WLR-$_counter';
    _counter++;
    return id;
  }

  /// Add a newly reported complaint
  void addComplaint(Complaint complaint) {
    // Add to the beginning of the list so new reports show up first
    _complaints.insert(0, complaint);
    notifyListeners();
  }

  /// Find complaint by ID (case-insensitive)
  Complaint? getComplaintById(String id) {
    final cleanId = id.trim().toUpperCase();
    try {
      return _complaints.firstWhere(
        (c) => c.id.toUpperCase() == cleanId,
      );
    } catch (_) {
      return null;
    }
  }

  /// Update the status of an existing complaint (used in viva demo)
  bool updateStatus(String id, ComplaintStatus newStatus) {
    final complaint = getComplaintById(id);
    if (complaint != null) {
      complaint.status = newStatus;
      notifyListeners();
      return true;
    }
    return false;
  }

  /// Get recent complaints for the dashboard
  List<Complaint> getRecentComplaints([int limit = 4]) {
    if (_complaints.length <= limit) {
      return List.unmodifiable(_complaints);
    }
    return List.unmodifiable(_complaints.take(limit));
  }

  /// Search and filter complaints
  List<Complaint> filterComplaints({
    String query = '',
    ComplaintStatus? statusFilter,
  }) {
    final cleanQuery = query.trim().toLowerCase();

    return _complaints.where((complaint) {
      final matchesQuery = cleanQuery.isEmpty ||
          complaint.id.toLowerCase().contains(cleanQuery) ||
          complaint.location.toLowerCase().contains(cleanQuery) ||
          complaint.citizenName.toLowerCase().contains(cleanQuery) ||
          complaint.leakageType.toLowerCase().contains(cleanQuery);

      final matchesStatus =
          statusFilter == null || complaint.status == statusFilter;

      return matchesQuery && matchesStatus;
    }).toList();
  }
}

