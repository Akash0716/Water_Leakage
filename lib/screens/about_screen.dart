import 'package:flutter/material.dart';

/// Screen presenting project background, UN SDG 6 alignment, and academic documentation
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 850),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Hero Banner
              Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade800, Colors.teal.shade700],
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.water_drop_rounded, color: Colors.white, size: 36),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'UN SDG 6: Clean Water & Sanitation',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.1,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Water Leakage Reporting App',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'An academic web application bridging the gap between vigilant citizens and municipal water maintenance authorities to detect, log, and resolve water leakages rapidly.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Section 1: Problem Statement
              _buildSectionCard(
                icon: Icons.warning_amber_rounded,
                iconColor: Colors.amber.shade800,
                iconBg: Colors.amber.shade50,
                title: 'Problem Statement',
                child: const Text(
                  'According to global municipal water utility studies, approximately 30% to 45% of treated drinking water is lost before reaching consumers due to invisible underground pipe bursts, broken public taps, and unmonitored storage tank overflows. Conventional reporting systems rely on periodic manual utility inspections, resulting in leaks going undetected for days or weeks.',
                  style: TextStyle(fontSize: 14, height: 1.6, color: Color(0xFF334155)),
                ),
              ),
              const SizedBox(height: 16),

              // Section 2: Project Objectives
              _buildSectionCard(
                icon: Icons.flag_rounded,
                iconColor: Colors.blue.shade700,
                iconBg: Colors.blue.shade50,
                title: 'Project Objectives',
                child: Column(
                  children: [
                    _buildObjectiveItem(
                      '1. Rapid Incident Reporting',
                      'Enable any citizen with a web browser to submit a geo-tagged water leakage complaint in under one minute without authentication barriers.',
                    ),
                    _buildObjectiveItem(
                      '2. Transparent Status Tracking',
                      'Provide an instant tracking portal using unique complaint IDs to monitor resolution progress from Pending to In Progress to Resolved.',
                    ),
                    _buildObjectiveItem(
                      '3. Centralized Civic Awareness',
                      'Display real-time community leakage metrics to educate the public on water wastage and promote collective civic responsibility.',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Section 3: How the Application Works (Workflow)
              _buildSectionCard(
                icon: Icons.alt_route_rounded,
                iconColor: Colors.teal.shade700,
                iconBg: Colors.teal.shade50,
                title: 'System Workflow',
                child: Column(
                  children: [
                    _buildWorkflowStep(
                      step: '01',
                      title: 'Spot & Report Leakage',
                      description: 'Citizen observes a pipe leak, overflowing tank, or broken public tap and submits address details and description.',
                    ),
                    _buildWorkflowStep(
                      step: '02',
                      title: 'Complaint ID Generated',
                      description: 'System automatically issues a unique reference ID (e.g. WLR-1009) and logs the issue in the central registry.',
                    ),
                    _buildWorkflowStep(
                      step: '03',
                      title: 'Assignment & Maintenance',
                      description: 'The maintenance team investigates the site, updates complaint status to "In Progress", and executes repairs.',
                    ),
                    _buildWorkflowStep(
                      step: '04',
                      title: 'Resolution & Metric Sync',
                      description: 'Once repaired, the status changes to "Resolved", updating community dashboard counters in real time.',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Section 4: Connection to UN SDG 6
              _buildSectionCard(
                icon: Icons.public_rounded,
                iconColor: Colors.green.shade700,
                iconBg: Colors.green.shade50,
                title: 'Alignment with UN Sustainable Development Goal 6',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Target 6.1: By 2030, achieve universal and equitable access to safe and affordable drinking water for all.',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Target 6.4: Substantially increase water-use efficiency across all sectors and ensure sustainable withdrawals and supply of freshwater to address water scarcity.',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.blue.shade900),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'By curbing loss from municipal distribution networks, this project directly supports SDG 6 targets by safeguarding treated water and preventing resource depletion.',
                      style: TextStyle(fontSize: 14, height: 1.5, color: Color(0xFF475569)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Section 5: Academic Project Metadata Card
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.indigo.shade200),
                ),
                color: Colors.indigo.shade50.withValues(alpha: 0.4),
                child: Padding(
                  padding: const EdgeInsets.all(22.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.school_rounded, color: Colors.indigo.shade800),
                          const SizedBox(width: 10),
                          Text(
                            'Academic Project Information',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo.shade900,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      const Divider(),
                      const SizedBox(height: 10),
                      _buildInfoRow('Project Title', 'Clean Water & Sanitation: Water Leakage Reporting App'),
                      _buildInfoRow('Frontend Framework', 'Flutter 3 (Dart) for Web'),
                      _buildInfoRow('State Architecture', 'StatefulWidget & ChangeNotifier (In-Memory Session)'),
                      _buildInfoRow('Design System', 'Material Design 3 (Water & Eco Palette)'),
                      _buildInfoRow('Student Name', 'Marella Akash'),
                      _buildInfoRow('Roll / Reg No.', '24PA1A05E6'),
                      _buildInfoRow('Department', 'Computer Science & Engineering'),
                      _buildInfoRow('Institution', 'Vishnu Institute Of Technology'),
                      _buildInfoRow('Academic Year', '2026 - 2027'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildSectionCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required Widget child,
  }) {
    return Card(
      elevation: 1,
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
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: iconColor, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            child,
          ],
        ),
      ),
    );
  }

  static Widget _buildObjectiveItem(String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle_outline, size: 18, color: Colors.blue.shade700),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 14, color: Color(0xFF334155), height: 1.4),
                children: [
                  TextSpan(text: '$title: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: desc),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildWorkflowStep({
    required String step,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.teal.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.teal.shade200),
            ),
            child: Text(
              step,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.teal.shade800,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF64748B),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 160,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: Color(0xFF475569),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
