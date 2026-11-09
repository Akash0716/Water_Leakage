import 'package:flutter/material.dart';
import '../models/complaint.dart';
import '../services/complaint_service.dart';
import '../widgets/summary_card.dart';
import '../widgets/complaint_card.dart';
import 'complaint_details_screen.dart';

/// Home Page / Dashboard displaying overview statistics, quick actions, and recent reports
class HomeScreen extends StatefulWidget {
  final Function(int tabIndex, {ComplaintStatus? filter}) onNavigateToTab;

  const HomeScreen({
    super.key,
    required this.onNavigateToTab,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

  void _openDetails(String complaintId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ComplaintDetailsScreen(complaintId: complaintId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final recentComplaints = _service.getRecentComplaints(4);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1000),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Welcome Hero Section
              _buildHeroBanner(),
              const SizedBox(height: 24),

              // Summary Cards Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Complaint Overview',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => widget.onNavigateToTab(2), // View Complaints tab
                    icon: const Text('View All', style: TextStyle(fontWeight: FontWeight.w600)),
                    label: const Icon(Icons.arrow_forward_rounded, size: 16),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Responsive Summary Metrics Grid
              LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = 4;
                  if (constraints.maxWidth < 600) {
                    crossAxisCount = 1;
                  } else if (constraints.maxWidth < 900) {
                    crossAxisCount = 2;
                  }

                  if (crossAxisCount == 1) {
                    return Column(
                      children: [
                        SummaryCard(
                          title: 'Total Reported',
                          count: _service.totalCount,
                          icon: Icons.assignment_outlined,
                          color: Colors.blue.shade700,
                          backgroundColor: Colors.blue.shade50,
                          onTap: () => widget.onNavigateToTab(2),
                        ),
                        const SizedBox(height: 12),
                        SummaryCard(
                          title: 'Pending Action',
                          count: _service.pendingCount,
                          icon: Icons.hourglass_top_rounded,
                          color: Colors.orange.shade700,
                          backgroundColor: Colors.orange.shade50,
                          onTap: () => widget.onNavigateToTab(2, filter: ComplaintStatus.pending),
                        ),
                        const SizedBox(height: 12),
                        SummaryCard(
                          title: 'In Progress',
                          count: _service.inProgressCount,
                          icon: Icons.engineering_rounded,
                          color: Colors.cyan.shade700,
                          backgroundColor: Colors.cyan.shade50,
                          onTap: () => widget.onNavigateToTab(2, filter: ComplaintStatus.inProgress),
                        ),
                        const SizedBox(height: 12),
                        SummaryCard(
                          title: 'Resolved',
                          count: _service.resolvedCount,
                          icon: Icons.check_circle_outline_rounded,
                          color: Colors.green.shade700,
                          backgroundColor: Colors.green.shade50,
                          onTap: () => widget.onNavigateToTab(2, filter: ComplaintStatus.resolved),
                        ),
                      ],
                    );
                  }

                  return GridView.count(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: crossAxisCount == 4 ? 1.3 : 1.6,
                    children: [
                      SummaryCard(
                        title: 'Total Reported',
                        count: _service.totalCount,
                        icon: Icons.assignment_outlined,
                        color: Colors.blue.shade700,
                        backgroundColor: Colors.blue.shade50,
                        onTap: () => widget.onNavigateToTab(2),
                      ),
                      SummaryCard(
                        title: 'Pending Action',
                        count: _service.pendingCount,
                        icon: Icons.hourglass_top_rounded,
                        color: Colors.orange.shade700,
                        backgroundColor: Colors.orange.shade50,
                        onTap: () => widget.onNavigateToTab(2, filter: ComplaintStatus.pending),
                      ),
                      SummaryCard(
                        title: 'In Progress',
                        count: _service.inProgressCount,
                        icon: Icons.engineering_rounded,
                        color: Colors.cyan.shade700,
                        backgroundColor: Colors.cyan.shade50,
                        onTap: () => widget.onNavigateToTab(2, filter: ComplaintStatus.inProgress),
                      ),
                      SummaryCard(
                        title: 'Resolved Issues',
                        count: _service.resolvedCount,
                        icon: Icons.check_circle_outline_rounded,
                        color: Colors.green.shade700,
                        backgroundColor: Colors.green.shade50,
                        onTap: () => widget.onNavigateToTab(2, filter: ComplaintStatus.resolved),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 28),

              // Quick Action Banner
              _buildQuickActionBanner(),
              const SizedBox(height: 28),

              // Recent Complaints Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Community Reports',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  Text(
                    'Showing ${recentComplaints.length} latest',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              if (recentComplaints.isEmpty)
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade100),
                  ),
                  child: const Center(
                    child: Text('No complaints logged yet. Submit the first report!'),
                  ),
                )
              else
                ...recentComplaints.map(
                  (complaint) => ComplaintCard(
                    complaint: complaint,
                    onViewDetails: () => _openDetails(complaint.id),
                  ),
                ),

              const SizedBox(height: 28),

              // SDG Impact & Water Conservation Section
              _buildSdgImpactSection(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroBanner() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF0284C7),
            Color(0xFF0D9488),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade900.withValues(alpha: 0.18),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.eco_rounded, color: Colors.white, size: 14),
                    SizedBox(width: 6),
                    Text(
                      'UN SDG 6: Clean Water and Sanitation',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'Save Clean Water.\nReport Leakages in Your Locality.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Every drop saved contributes to community health, resource conservation, and a sustainable future. Report pipe breaks, broken taps, or tank overflows in seconds.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 10,
            children: [
              ElevatedButton.icon(
                onPressed: () => widget.onNavigateToTab(1), // Report Leakage tab
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF0284C7),
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 2,
                ),
                icon: const Icon(Icons.add_alert_rounded),
                label: const Text(
                  'Report a Leakage',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
              OutlinedButton.icon(
                onPressed: () => widget.onNavigateToTab(3), // Track Complaint tab
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white70, width: 1.5),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.search_rounded),
                label: const Text(
                  'Track by ID',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionBanner() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 560;

        return Card(
          elevation: 0,
          color: Colors.blue.shade50,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.blue.shade100),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: isNarrow
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade600,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.water_drop_rounded, color: Colors.white, size: 24),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Spotted an untreated water leak?',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Submission takes less than 60 seconds. You will receive an instant Complaint ID.',
                        style: TextStyle(fontSize: 13, color: Color(0xFF475569)),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => widget.onNavigateToTab(1),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade700,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text('Report Now'),
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade600,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.water_drop_rounded, color: Colors.white, size: 28),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Spotted an untreated water leak?',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Submission takes less than 60 seconds. You will receive an instant Complaint ID.',
                              style: TextStyle(fontSize: 13, color: Color(0xFF475569)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () => widget.onNavigateToTab(1),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade700,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Report Now'),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }

  Widget _buildSdgImpactSection() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.teal.shade100),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.eco_outlined, color: Colors.teal.shade700, size: 24),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Why Citizen Leakage Reporting Matters',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Water distribution networks lose up to 35% of treated drinking water through unreported infrastructure leaks before reaching household taps. Early reporting reduces non-revenue water wastage, lowers pumping energy emissions, and ensures uninterrupted sanitation for vulnerable communities.',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF475569),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 12,
              children: [
                _buildSdgFact(
                  icon: Icons.opacity_rounded,
                  title: 'Prevent Wastage',
                  desc: 'A single leaky pipe can waste up to 10,000 liters daily.',
                ),
                _buildSdgFact(
                  icon: Icons.shield_rounded,
                  title: 'Preserve Quality',
                  desc: 'Broken pipes allow soil contaminants to enter potable water.',
                ),
                _buildSdgFact(
                  icon: Icons.groups_rounded,
                  title: 'SDG 6 Goal',
                  desc: 'Supports universal access to clean water and sanitation.',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSdgFact({
    required IconData icon,
    required String title,
    required String desc,
  }) {
    return Container(
      width: 250,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: Colors.teal.shade700),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xFF1E293B),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            desc,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}
