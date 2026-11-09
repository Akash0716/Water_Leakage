import 'package:flutter/material.dart';
import '../models/complaint.dart';
import '../services/complaint_service.dart';
import '../widgets/complaint_card.dart';
import 'complaint_details_screen.dart';

/// Screen displaying all reported complaints with search, filter, and detail views
class ComplaintsScreen extends StatefulWidget {
  final ComplaintStatus? initialStatusFilter;

  const ComplaintsScreen({
    super.key,
    this.initialStatusFilter,
  });

  @override
  State<ComplaintsScreen> createState() => _ComplaintsScreenState();
}

class _ComplaintsScreenState extends State<ComplaintsScreen> {
  final ComplaintService _service = ComplaintService();
  final TextEditingController _searchController = TextEditingController();

  ComplaintStatus? _selectedStatusFilter;

  @override
  void initState() {
    super.initState();
    _selectedStatusFilter = widget.initialStatusFilter;
    _service.addListener(_onServiceUpdate);
  }

  @override
  void didUpdateWidget(covariant ComplaintsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialStatusFilter != oldWidget.initialStatusFilter) {
      setState(() {
        _selectedStatusFilter = widget.initialStatusFilter;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _service.removeListener(_onServiceUpdate);
    super.dispose();
  }

  void _onServiceUpdate() {
    if (mounted) {
      setState(() {});
    }
  }

  void _openDetails(String complaintId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ComplaintDetailsScreen(complaintId: complaintId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredComplaints = _service.filterComplaints(
      query: _searchController.text,
      statusFilter: _selectedStatusFilter,
    );

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header title and count summary
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Reported Leakage Issues',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Total ${_service.totalCount} complaints logged across local municipal zones',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Search bar
              TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Search by Complaint ID (e.g. WLR-1001) or location...',
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {});
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue.shade200),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue.shade100),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
              const SizedBox(height: 12),

              // Status Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    FilterChip(
                      label: Text('All (${_service.totalCount})'),
                      selected: _selectedStatusFilter == null,
                      onSelected: (selected) {
                        setState(() {
                          _selectedStatusFilter = null;
                        });
                      },
                      selectedColor: Colors.blue.shade100,
                      checkmarkColor: Colors.blue.shade900,
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      avatar: Icon(
                        ComplaintStatus.pending.icon,
                        size: 14,
                        color: ComplaintStatus.pending.color,
                      ),
                      label: Text('Pending (${_service.pendingCount})'),
                      selected: _selectedStatusFilter == ComplaintStatus.pending,
                      onSelected: (selected) {
                        setState(() {
                          _selectedStatusFilter =
                              selected ? ComplaintStatus.pending : null;
                        });
                      },
                      selectedColor: ComplaintStatus.pending.backgroundColor,
                      checkmarkColor: ComplaintStatus.pending.color,
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      avatar: Icon(
                        ComplaintStatus.inProgress.icon,
                        size: 14,
                        color: ComplaintStatus.inProgress.color,
                      ),
                      label: Text('In Progress (${_service.inProgressCount})'),
                      selected: _selectedStatusFilter == ComplaintStatus.inProgress,
                      onSelected: (selected) {
                        setState(() {
                          _selectedStatusFilter =
                              selected ? ComplaintStatus.inProgress : null;
                        });
                      },
                      selectedColor: ComplaintStatus.inProgress.backgroundColor,
                      checkmarkColor: ComplaintStatus.inProgress.color,
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      avatar: Icon(
                        ComplaintStatus.resolved.icon,
                        size: 14,
                        color: ComplaintStatus.resolved.color,
                      ),
                      label: Text('Resolved (${_service.resolvedCount})'),
                      selected: _selectedStatusFilter == ComplaintStatus.resolved,
                      onSelected: (selected) {
                        setState(() {
                          _selectedStatusFilter =
                              selected ? ComplaintStatus.resolved : null;
                        });
                      },
                      selectedColor: ComplaintStatus.resolved.backgroundColor,
                      checkmarkColor: ComplaintStatus.resolved.color,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Complaints List
              Expanded(
                child: filteredComplaints.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.water_damage_outlined,
                                size: 54,
                                color: Colors.blue.shade300,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'No complaints match your search',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Try clearing your search query or choosing another status filter.',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 16),
                            OutlinedButton.icon(
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _selectedStatusFilter = null;
                                });
                              },
                              icon: const Icon(Icons.refresh_rounded),
                              label: const Text('Reset Filters'),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredComplaints.length,
                        itemBuilder: (context, index) {
                          final complaint = filteredComplaints[index];
                          return ComplaintCard(
                            complaint: complaint,
                            onViewDetails: () => _openDetails(complaint.id),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

