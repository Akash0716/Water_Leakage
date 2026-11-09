import 'package:flutter/material.dart';
import '../models/complaint.dart';
import '../services/complaint_service.dart';
import '../widgets/status_badge.dart';

/// Screen displaying comprehensive details and status tracking for a complaint
class ComplaintDetailsScreen extends StatefulWidget {
  final String complaintId;

  const ComplaintDetailsScreen({
    super.key,
    required this.complaintId,
  });

  @override
  State<ComplaintDetailsScreen> createState() => _ComplaintDetailsScreenState();
}

class _ComplaintDetailsScreenState extends State<ComplaintDetailsScreen> {
  final ComplaintService _service = ComplaintService();

  @override
  void initState() {
    super.initState();
    _service.addListener(_onServiceUpdate);
  }

  @override
  void dispose() {
    _service.removeListener(_onServiceUpdate);
    super.dispose();
  }

  void _onServiceUpdate() {
    if (mounted) {
      setState(() {});
    }
  }

  void _changeStatus(ComplaintStatus newStatus) {
    final success = _service.updateStatus(widget.complaintId, newStatus);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Complaint status updated to "${newStatus.displayName}". Dashboard metrics updated!',
          ),
          backgroundColor: newStatus.color,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final complaint = _service.getComplaintById(widget.complaintId);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text('Complaint Details (${widget.complaintId})'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: complaint == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off_rounded, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'Complaint "${widget.complaintId}" not found.',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Back to Complaints'),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header card with ID, status, and reporting date
                      Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(color: Colors.blue.shade100),
                        ),
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'COMPLAINT REFERENCE',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue.shade600,
                                          letterSpacing: 1.1,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        complaint.id,
                                        style: const TextStyle(
                                          fontSize: 26,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF0F172A),
                                        ),
                                      ),
                                    ],
                                  ),
                                  StatusBadge(status: complaint.status, isLarge: true),
                                ],
                              ),
                              const SizedBox(height: 16),
                              const Divider(),
                              const SizedBox(height: 12),
                              // Visual Progress Stepper
                              _buildStatusStepper(complaint.status),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Information Card
                      Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(color: Colors.blue.shade100),
                        ),
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Incident Information',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                              const SizedBox(height: 20),

                              _buildDetailRow(
                                icon: Icons.water_drop_rounded,
                                label: 'Leakage Type',
                                value: complaint.leakageType,
                              ),
                              const SizedBox(height: 16),

                              _buildDetailRow(
                                icon: Icons.location_on_rounded,
                                label: 'Location / Address',
                                value: complaint.location,
                              ),
                              const SizedBox(height: 16),

                              _buildDetailRow(
                                icon: Icons.person_rounded,
                                label: 'Reported By',
                                value: complaint.citizenName,
                              ),
                              const SizedBox(height: 16),

                              _buildDetailRow(
                                icon: Icons.calendar_today_rounded,
                                label: 'Date Reported',
                                value: complaint.dateReported,
                              ),
                              const SizedBox(height: 16),

                              _buildDetailRow(
                                icon: Icons.description_rounded,
                                label: 'Description',
                                value: complaint.description,
                                isMultiline: true,
                              ),

                              if (complaint.imageTag != null) ...[
                                const SizedBox(height: 16),
                                _buildDetailRow(
                                  icon: Icons.photo_camera_rounded,
                                  label: 'Photo Attachment',
                                  value: '${complaint.imageTag} (Attached)',
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Academic Demonstration Controls Card
                      Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(color: Colors.indigo.shade100),
                        ),
                        color: Colors.indigo.shade50.withValues(alpha: 0.5),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.school_rounded, color: Colors.indigo.shade700, size: 22),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Academic Demo: Update Status',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.indigo.shade900,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Use these buttons during your viva / project presentation to demonstrate how changing complaint status immediately synchronizes across the app and updates dashboard metrics.',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade700,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: ComplaintStatus.values.map((status) {
                                  final isCurrent = complaint.status == status;
                                  return ElevatedButton.icon(
                                    onPressed: isCurrent ? null : () => _changeStatus(status),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: isCurrent ? status.color : Colors.white,
                                      foregroundColor: isCurrent ? Colors.white : status.color,
                                      elevation: isCurrent ? 2 : 0,
                                      side: BorderSide(
                                        color: status.color,
                                        width: isCurrent ? 0 : 1.5,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    icon: Icon(status.icon, size: 16),
                                    label: Text(
                                      isCurrent ? 'Current: ${status.displayName}' : 'Mark as ${status.displayName}',
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Bottom action buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          OutlinedButton.icon(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.arrow_back),
                            label: const Text('Back'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Verification details saved locally for this session.'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            },
                            icon: const Icon(Icons.done_all_rounded),
                            label: const Text('Confirmed Details'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade700,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    bool isMultiline = false,
  }) {
    return Row(
      crossAxisAlignment:
          isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: Colors.blue.shade700),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusStepper(ComplaintStatus currentStatus) {
    final steps = [
      {'title': 'Reported', 'status': ComplaintStatus.pending},
      {'title': 'In Progress', 'status': ComplaintStatus.inProgress},
      {'title': 'Resolved', 'status': ComplaintStatus.resolved},
    ];

    int currentIdx = currentStatus == ComplaintStatus.pending
        ? 0
        : currentStatus == ComplaintStatus.inProgress
            ? 1
            : 2;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: List.generate(steps.length * 2 - 1, (index) {
          if (index.isOdd) {
            // Connector line
            final stepBefore = index ~/ 2;
            final isPassed = currentIdx > stepBefore;
            return Expanded(
              child: Container(
                height: 3,
                color: isPassed ? Colors.green.shade600 : Colors.grey.shade300,
              ),
            );
          } else {
            // Step node
            final stepIdx = index ~/ 2;
            final isCompleted = currentIdx >= stepIdx;
            final isCurrent = currentIdx == stepIdx;

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: isCompleted
                      ? (isCurrent && currentStatus != ComplaintStatus.resolved
                          ? currentStatus.color
                          : Colors.green.shade600)
                      : Colors.grey.shade300,
                  child: Icon(
                    isCompleted ? Icons.check : Icons.circle,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  steps[stepIdx]['title'] as String,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isCompleted ? FontWeight.bold : FontWeight.normal,
                    color: isCompleted ? Colors.blueGrey.shade900 : Colors.grey.shade500,
                  ),
                ),
              ],
            );
          }
        }),
      ),
    );
  }
}
