import 'package:flutter/material.dart';
import '../models/complaint.dart';
import '../services/complaint_service.dart';
import '../widgets/status_badge.dart';
import 'complaint_details_screen.dart';

/// Screen allowing citizens to track the real-time status of their reported complaint by ID
class TrackComplaintScreen extends StatefulWidget {
  final String? initialComplaintId;

  const TrackComplaintScreen({super.key, this.initialComplaintId});

  @override
  State<TrackComplaintScreen> createState() => _TrackComplaintScreenState();
}

class _TrackComplaintScreenState extends State<TrackComplaintScreen> {
  final ComplaintService _service = ComplaintService();
  final TextEditingController _idController = TextEditingController();

  Complaint? _foundComplaint;
  bool _hasSearched = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _service.addListener(_onServiceUpdate);
    if (widget.initialComplaintId != null && widget.initialComplaintId!.isNotEmpty) {
      _idController.text = widget.initialComplaintId!;
      _trackComplaint();
    }
  }

  @override
  void dispose() {
    _idController.dispose();
    _service.removeListener(_onServiceUpdate);
    super.dispose();
  }

  void _onServiceUpdate() {
    if (mounted && _foundComplaint != null) {
      // Re-fetch in case status was changed
      setState(() {
        _foundComplaint = _service.getComplaintById(_foundComplaint!.id);
      });
    }
  }

  void _trackComplaint([String? queryId]) {
    final searchId = (queryId ?? _idController.text).trim();

    if (searchId.isEmpty) {
      setState(() {
        _hasSearched = true;
        _errorMessage = 'Please enter a Complaint ID to track.';
        _foundComplaint = null;
      });
      return;
    }

    final complaint = _service.getComplaintById(searchId);

    setState(() {
      _hasSearched = true;
      if (complaint != null) {
        _foundComplaint = complaint;
        _errorMessage = null;
      } else {
        _foundComplaint = null;
        _errorMessage =
            'No complaint found with ID "$searchId". Please check the ID (e.g. WLR-1001) and try again.';
      }
    });
  }

  void _openFullDetails(String complaintId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ComplaintDetailsScreen(complaintId: complaintId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade800, Colors.indigo.shade700],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.shade900.withValues(alpha: 0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.track_changes_rounded,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                    const SizedBox(width: 18),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Track Complaint Status',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Enter your unique Complaint ID (e.g. WLR-1001) to view real-time resolution progress.',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Search Box Card
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.blue.shade100),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(22.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Enter Complaint Reference ID',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _idController,
                              textCapitalization: TextCapitalization.characters,
                              decoration: InputDecoration(
                                hintText: 'e.g. WLR-1001',
                                prefixIcon: const Icon(Icons.qr_code_rounded),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                filled: true,
                                fillColor: const Color(0xFFF8FAFC),
                              ),
                              onSubmitted: (_) => _trackComplaint(),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            onPressed: () => _trackComplaint(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade700,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 22,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            icon: const Icon(Icons.search_rounded),
                            label: const Text(
                              'Track',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Quick test chips for demonstration
                      const Text(
                        'Quick demo tests (click to inspect sample complaints):',
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: {
                          'WLR-1001',
                          'WLR-1002',
                          'WLR-1003',
                          'WLR-1004',
                          if (_service.complaints.isNotEmpty &&
                              _service.complaints.first.id != 'WLR-1001')
                            _service.complaints.first.id,
                        }.map((sampleId) {
                          return ActionChip(
                            avatar: const Icon(Icons.touch_app, size: 14),
                            label: Text(sampleId),
                            onPressed: () {
                              _idController.text = sampleId;
                              _trackComplaint(sampleId);
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Search Result / Error message
              if (_hasSearched) ...[
                if (_errorMessage != null)
                  Card(
                    color: Colors.red.shade50,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: BorderSide(color: Colors.red.shade200),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline_rounded,
                              color: Colors.red.shade700, size: 36),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Complaint Not Found',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red.shade900,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _errorMessage!,
                                  style: TextStyle(
                                    color: Colors.red.shade800,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else if (_foundComplaint != null)
                  _buildComplaintResultCard(_foundComplaint!),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildComplaintResultCard(Complaint complaint) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.blue.shade200),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status and ID row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'COMPLAINT FOUND',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade700,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      complaint.id,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
                StatusBadge(status: complaint.status, isLarge: true),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 16),

            // Key info items
            _buildResultItem(Icons.water_drop, 'Leakage Type', complaint.leakageType),
            const SizedBox(height: 12),
            _buildResultItem(Icons.location_on, 'Location', complaint.location),
            const SizedBox(height: 12),
            _buildResultItem(Icons.calendar_today, 'Date Reported', complaint.dateReported),
            const SizedBox(height: 12),
            _buildResultItem(Icons.person, 'Citizen Name', complaint.citizenName),
            const SizedBox(height: 12),
            _buildResultItem(Icons.description, 'Description', complaint.description),
            const SizedBox(height: 24),

            // Action Button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _openFullDetails(complaint.id),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.open_in_new_rounded, size: 18),
                  label: const Text(
                    'Open Full Details & Demo Controls',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultItem(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.blue.shade700),
        const SizedBox(width: 10),
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 13,
              color: Color(0xFF1E293B),
            ),
          ),
        ),
      ],
    );
  }
}
