import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:water_leakage_app/main.dart';
import 'package:water_leakage_app/models/complaint.dart';
import 'package:water_leakage_app/services/complaint_service.dart';

void main() {
  group('ComplaintService Unit Tests', () {
    test('Initial sample complaints are populated correctly', () {
      final service = ComplaintService();
      expect(service.complaints.length, greaterThanOrEqualTo(8));
      expect(service.totalCount, service.complaints.length);
      expect(service.pendingCount, greaterThan(0));
      expect(service.inProgressCount, greaterThan(0));
      expect(service.resolvedCount, greaterThan(0));
    });

    test('Add complaint increments count and adds to beginning', () {
      final service = ComplaintService();
      final initialTotal = service.totalCount;
      final initialPending = service.pendingCount;

      final testComplaint = Complaint(
        id: service.generateNextId(),
        citizenName: 'Test Citizen',
        location: 'Test Street, Sector 1',
        leakageType: 'Pipe Leakage',
        description: 'Water leak test description',
        dateReported: '2026-10-28',
        status: ComplaintStatus.pending,
      );

      service.addComplaint(testComplaint);

      expect(service.totalCount, initialTotal + 1);
      expect(service.pendingCount, initialPending + 1);
      expect(service.complaints.first.id, testComplaint.id);
    });

    test('Filter complaints by search query and status', () {
      final service = ComplaintService();
      final results = service.filterComplaints(query: 'WLR-1001');
      expect(results.length, 1);
      expect(results.first.id, 'WLR-1001');

      final pendingResults = service.filterComplaints(
        statusFilter: ComplaintStatus.pending,
      );
      expect(pendingResults.every((c) => c.status == ComplaintStatus.pending), isTrue);
    });

    test('Update complaint status synchronizes counts correctly', () {
      final service = ComplaintService();
      final complaint = service.getComplaintById('WLR-1002');
      expect(complaint, isNotNull);

      final originalStatus = complaint!.status;
      final originalPending = service.pendingCount;
      final originalResolved = service.resolvedCount;

      // Update to resolved
      final updated = service.updateStatus('WLR-1002', ComplaintStatus.resolved);
      expect(updated, isTrue);

      if (originalStatus == ComplaintStatus.pending) {
        expect(service.pendingCount, originalPending - 1);
        expect(service.resolvedCount, originalResolved + 1);
      }
    });
  });

  group('Widget and UI Flow Tests', () {
    testWidgets('Dashboard renders metrics and navigation works', (tester) async {
      tester.view.physicalSize = const Size(1280, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(const WaterLeakageApp());
      await tester.pumpAndSettle();

      // Check Dashboard metrics
      expect(find.text('Total Reported'), findsOneWidget);
      expect(find.text('Pending Action'), findsOneWidget);
      expect(find.text('In Progress'), findsWidgets);
      expect(find.text('Resolved Issues'), findsOneWidget);

      // Verify SDG 6 Banner
      expect(find.text('Save Clean Water.\nReport Leakages in Your Locality.'), findsOneWidget);

      // Tap on View Complaints in top navigation
      final viewComplaintsFinder = find.widgetWithText(TextButton, 'View Complaints');
      expect(viewComplaintsFinder, findsOneWidget);
      await tester.tap(viewComplaintsFinder);
      await tester.pumpAndSettle();

      // Verify View Complaints page loaded
      expect(find.text('Reported Leakage Issues'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('Track complaint page allows searching by ID', (tester) async {
      tester.view.physicalSize = const Size(1280, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(const WaterLeakageApp());
      await tester.pumpAndSettle();

      // Navigate to Track Complaint
      final trackFinder = find.widgetWithText(TextButton, 'Track Complaint');
      expect(trackFinder, findsOneWidget);
      await tester.tap(trackFinder);
      await tester.pumpAndSettle();

      expect(find.text('Track Complaint Status'), findsOneWidget);

      // Tap quick test chip WLR-1001
      final chipFinder = find.widgetWithText(ActionChip, 'WLR-1001');
      expect(chipFinder, findsOneWidget);
      await tester.tap(chipFinder);
      await tester.pumpAndSettle();

      // Verify complaint details card appeared
      expect(find.text('COMPLAINT FOUND'), findsOneWidget);
      expect(find.text('WLR-1001'), findsWidgets);
    });

    testWidgets('About page displays UN SDG 6 and academic information', (tester) async {
      tester.view.physicalSize = const Size(1280, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(const WaterLeakageApp());
      await tester.pumpAndSettle();

      // Navigate to About
      final aboutFinder = find.widgetWithText(TextButton, 'About Project');
      expect(aboutFinder, findsOneWidget);
      await tester.tap(aboutFinder);
      await tester.pumpAndSettle();

      expect(find.text('UN SDG 6: Clean Water & Sanitation'), findsWidgets);
      expect(find.text('Problem Statement'), findsOneWidget);
      expect(find.text('Project Objectives'), findsOneWidget);
      expect(find.text('System Workflow'), findsOneWidget);
      expect(find.text('Academic Project Information'), findsOneWidget);
    });
  });
}
