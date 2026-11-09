import 'package:flutter/material.dart';
import '../models/complaint.dart';
import '../services/complaint_service.dart';
import 'complaint_details_screen.dart';

/// Screen allowing citizens to submit a new water leakage report
class ReportLeakageScreen extends StatefulWidget {
  final Function(int tabIndex)? onNavigateToTab;

  const ReportLeakageScreen({super.key, this.onNavigateToTab});

  @override
  State<ReportLeakageScreen> createState() => _ReportLeakageScreenState();
}

class _ReportLeakageScreenState extends State<ReportLeakageScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();

  final List<String> _leakageTypes = [
    'Pipe Leakage',
    'Broken Public Tap',
    'Overflowing Water Tank',
    'Other',
  ];

  String? _selectedLeakageType = 'Pipe Leakage';
  late DateTime _selectedDate;
  String? _selectedImageTag;

  final List<String> _sampleImageTags = [
    'Pipe burst on main street',
    'Broken public standpost',
    'Rooftop tank overflow',
    'Sidewalk water seepage',
  ];

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    final year = date.year.toString();
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2025),
      lastDate: DateTime.now(),
      helpText: 'Select Date of Leakage Observation',
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submitComplaint() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final service = ComplaintService();
    final newId = service.generateNextId();

    final complaint = Complaint(
      id: newId,
      citizenName: _nameController.text.trim(),
      location: _locationController.text.trim(),
      leakageType: _selectedLeakageType ?? 'Pipe Leakage',
      description: _descriptionController.text.trim(),
      dateReported: _formatDate(_selectedDate),
      status: ComplaintStatus.pending,
      imageTag: _selectedImageTag,
    );

    // Save to shared service
    service.addComplaint(complaint);

    // Show success dialog with options
    _showSuccessDialog(complaint);

    // Clear form fields
    _nameController.clear();
    _locationController.clear();
    _descriptionController.clear();
    setState(() {
      _selectedLeakageType = 'Pipe Leakage';
      _selectedImageTag = null;
      _selectedDate = DateTime.now();
    });
  }

  void _showSuccessDialog(Complaint complaint) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.check_circle_rounded, color: Colors.green.shade600, size: 54),
            ),
            const SizedBox(height: 16),
            const Text(
              'Complaint Registered!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Thank you for helping conserve precious water.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                children: [
                  Text(
                    'YOUR COMPLAINT ID',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: Colors.blue.shade800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  SelectableText(
                    complaint.id,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Save this ID to track your complaint status anytime.',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('Submit Another'),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade700,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ComplaintDetailsScreen(complaintId: complaint.id),
                ),
              );
            },
            icon: const Icon(Icons.visibility_rounded, size: 18),
            label: const Text('View Complaint'),
          ),
        ],
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
              // Header title card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade700, Colors.teal.shade600],
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
                        Icons.report_problem_rounded,
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
                            'Report Water Leakage',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Every drop matters! Fill in the details below to report water wastage in your locality.',
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

              // Form Card
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.blue.shade100),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Complaint Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Fields marked with an asterisk (*) are mandatory.',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        ),
                        const SizedBox(height: 20),

                        // Citizen Full Name
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Full Name *',
                            hintText: 'Enter your name (e.g. Rahul Sharma)',
                            prefixIcon: const Icon(Icons.person_outline),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            filled: true,
                            fillColor: const Color(0xFFF8FAFC),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your full name.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 18),

                        // Location
                        TextFormField(
                          controller: _locationController,
                          decoration: InputDecoration(
                            labelText: 'Leakage Location or Address *',
                            hintText: 'e.g. Near City Hospital Gate 2, MG Road, Sector 5',
                            prefixIcon: const Icon(Icons.location_on_outlined),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            filled: true,
                            fillColor: const Color(0xFFF8FAFC),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please specify the location or address of the leakage.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 18),

                        // Leakage Type & Date Reported in responsive row
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final isWide = constraints.maxWidth > 500;
                            final typeField = DropdownButtonFormField<String>(
                              initialValue: _selectedLeakageType,
                              decoration: InputDecoration(
                                labelText: 'Leakage Type *',
                                prefixIcon: const Icon(Icons.category_outlined),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                filled: true,
                                fillColor: const Color(0xFFF8FAFC),
                              ),
                              items: _leakageTypes.map((type) {
                                return DropdownMenuItem(
                                  value: type,
                                  child: Text(type),
                                );
                              }).toList(),
                              onChanged: (val) {
                                setState(() {
                                  _selectedLeakageType = val;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a leakage type.';
                                }
                                return null;
                              },
                            );

                            final dateField = InkWell(
                              onTap: _selectDate,
                              borderRadius: BorderRadius.circular(10),
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  labelText: 'Date of Reporting',
                                  prefixIcon: const Icon(Icons.calendar_today_outlined),
                                  suffixIcon: const Icon(Icons.arrow_drop_down),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                  filled: true,
                                  fillColor: const Color(0xFFF8FAFC),
                                ),
                                child: Text(
                                  _formatDate(_selectedDate),
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ),
                            );

                            if (isWide) {
                              return Row(
                                children: [
                                  Expanded(child: typeField),
                                  const SizedBox(width: 16),
                                  Expanded(child: dateField),
                                ],
                              );
                            } else {
                              return Column(
                                children: [
                                  typeField,
                                  const SizedBox(height: 18),
                                  dateField,
                                ],
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 18),

                        // Problem Description
                        TextFormField(
                          controller: _descriptionController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            labelText: 'Description of the Problem *',
                            hintText: 'Describe the issue (e.g., Underground pipe cracked, clean water gushing out for 3 hours)',
                            prefixIcon: const Padding(
                              padding: EdgeInsets.only(bottom: 40),
                              child: Icon(Icons.description_outlined),
                            ),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            filled: true,
                            fillColor: const Color(0xFFF8FAFC),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please describe the leakage problem.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 18),

                        // Optional Image Attachment (Simulated photo selector for web friendliness)
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.blue.shade100),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.photo_camera_outlined, size: 20, color: Colors.blue.shade700),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Optional Photo Attachment',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade100,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Text('Optional', style: TextStyle(fontSize: 11)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Select a photo tag to simulate capturing the incident for municipal review:',
                                style: TextStyle(fontSize: 12, color: Colors.black54),
                              ),
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  ChoiceChip(
                                    label: const Text('None'),
                                    selected: _selectedImageTag == null,
                                    onSelected: (val) {
                                      setState(() {
                                        _selectedImageTag = null;
                                      });
                                    },
                                  ),
                                  ..._sampleImageTags.map((tag) {
                                    final isSelected = _selectedImageTag == tag;
                                    return ChoiceChip(
                                      avatar: Icon(
                                        Icons.image,
                                        size: 14,
                                        color: isSelected ? Colors.white : Colors.blue.shade700,
                                      ),
                                      label: Text(tag),
                                      selected: isSelected,
                                      selectedColor: Colors.blue.shade700,
                                      labelStyle: TextStyle(
                                        color: isSelected ? Colors.white : Colors.black87,
                                        fontSize: 12,
                                      ),
                                      onSelected: (val) {
                                        setState(() {
                                          _selectedImageTag = val ? tag : null;
                                        });
                                      },
                                    );
                                  }),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 26),

                        // Action Buttons
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: _submitComplaint,
                                icon: const Icon(Icons.send_rounded),
                                label: const Text(
                                  'Submit Leakage Report',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue.shade700,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Water saving note
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.eco_rounded, color: Colors.green.shade700),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'A small faucet drip wasting 1 drop per second loses over 3,000 gallons of clean water per year. Thank you for reporting!',
                        style: TextStyle(color: Colors.green.shade900, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
