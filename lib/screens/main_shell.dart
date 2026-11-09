import 'package:flutter/material.dart';
import '../models/complaint.dart';
import 'home_screen.dart';
import 'report_leakage_screen.dart';
import 'complaints_screen.dart';
import 'track_complaint_screen.dart';
import 'about_screen.dart';

/// Main scaffold shell managing top-level tabs and responsive navigation
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentTabIndex = 0;
  ComplaintStatus? _complaintsFilter;

  final List<String> _tabTitles = [
    'Home',
    'Report Leakage',
    'View Complaints',
    'Track Complaint',
    'About Project',
  ];

  final List<IconData> _tabIcons = [
    Icons.dashboard_rounded,
    Icons.add_alert_rounded,
    Icons.list_alt_rounded,
    Icons.track_changes_rounded,
    Icons.info_outline_rounded,
  ];

  void _navigateToTab(int index, {ComplaintStatus? filter}) {
    setState(() {
      _currentTabIndex = index;
      if (index == 2) {
        _complaintsFilter = filter;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 950;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        toolbarHeight: 65,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 16,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: Colors.blue.shade100,
            height: 1,
          ),
        ),
        title: InkWell(
          onTap: () => _navigateToTab(0),
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade700, Colors.teal.shade500],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.water_drop_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'AquaReport',
                    style: TextStyle(
                      color: Color(0xFF0284C7),
                      fontWeight: FontWeight.bold,
                      fontSize: 19,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: isDesktop
            ? [
                ...List.generate(_tabTitles.length, (index) {
                  final isSelected = _currentTabIndex == index;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3.0),
                    child: TextButton.icon(
                      onPressed: () => _navigateToTab(index),
                      style: TextButton.styleFrom(
                        foregroundColor: isSelected
                            ? Colors.blue.shade800
                            : const Color(0xFF475569),
                        backgroundColor: isSelected
                            ? Colors.blue.shade50
                            : Colors.transparent,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: Icon(
                        _tabIcons[index],
                        size: 16,
                        color: isSelected
                            ? Colors.blue.shade700
                            : Colors.grey.shade600,
                      ),
                      label: Text(
                        _tabTitles[index],
                        style: TextStyle(
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(width: 12),
              ]
            : [
                Builder(
                  builder: (ctx) => IconButton(
                    icon: const Icon(Icons.menu_rounded, size: 26),
                    onPressed: () => Scaffold.of(ctx).openEndDrawer(),
                    tooltip: 'Open Navigation Menu',
                  ),
                ),
                const SizedBox(width: 8),
              ],
      ),
      endDrawer: !isDesktop
          ? Drawer(
              child: SafeArea(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blue.shade800, Colors.teal.shade600],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.water_drop_rounded,
                                color: Colors.white, size: 30),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'AquaReport',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Water Leakage Reporting Portal',
                            style: TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        children: List.generate(_tabTitles.length, (index) {
                          final isSelected = _currentTabIndex == index;
                          return ListTile(
                            leading: Icon(
                              _tabIcons[index],
                              color: isSelected
                                  ? Colors.blue.shade700
                                  : Colors.grey.shade700,
                            ),
                            title: Text(
                              _tabTitles[index],
                              style: TextStyle(
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isSelected
                                    ? Colors.blue.shade800
                                    : Colors.black87,
                              ),
                            ),
                            selected: isSelected,
                            selectedTileColor: Colors.blue.shade50,
                            onTap: () {
                              Navigator.of(context).pop();
                              _navigateToTab(index);
                            },
                          );
                        }),
                      ),
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'College Academic Project • UN SDG 6',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
      body: _buildCurrentTab(),
      bottomNavigationBar: !isDesktop
          ? NavigationBar(
              selectedIndex: _currentTabIndex,
              onDestinationSelected: _navigateToTab,
              destinations: List.generate(_tabTitles.length, (index) {
                return NavigationDestination(
                  icon: Icon(_tabIcons[index]),
                  label: _tabTitles[index],
                );
              }),
            )
          : null,
    );
  }

  Widget _buildCurrentTab() {
    switch (_currentTabIndex) {
      case 0:
        return HomeScreen(onNavigateToTab: _navigateToTab);
      case 1:
        return ReportLeakageScreen(onNavigateToTab: _navigateToTab);
      case 2:
        return ComplaintsScreen(initialStatusFilter: _complaintsFilter);
      case 3:
        return const TrackComplaintScreen();
      case 4:
        return const AboutScreen();
      default:
        return HomeScreen(onNavigateToTab: _navigateToTab);
    }
  }
}
