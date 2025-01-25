import 'package:flutter/material.dart';

class AcceptorScreen extends StatefulWidget {
  const AcceptorScreen({super.key});

  @override
  State<AcceptorScreen> createState() => _AcceptorScreenState();
}

class _AcceptorScreenState extends State<AcceptorScreen> {
  String? selectedBloodGroup;
  DateTime? selectedDate;
  String? selectedLocation;

  // Sample donor data - in a real app, this would come from a database
  final List<Map<String, String>> donors = [
    {
      'name': 'John Doe',
      'bloodGroup': 'O+',
      'location': 'New York',
      'phone': '1234567890',
    },
    {
      'name': 'Jane Smith',
      'bloodGroup': 'A+',
      'location': 'Los Angeles',
      'phone': '0987654321',
    },
  ];

  List<Map<String, String>> get filteredDonors {
    return donors.where((donor) {
      bool matchesBloodGroup = selectedBloodGroup == null ||
          donor['bloodGroup'] == selectedBloodGroup;
      bool matchesLocation = selectedLocation == null ||
          donor['location'] == selectedLocation;
      return matchesBloodGroup && matchesLocation;
    }).toList();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acceptor Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Blood Group Needed',
                border: OutlineInputBorder(),
              ),
              value: selectedBloodGroup,
              items: const [
                DropdownMenuItem(value: 'A+', child: Text('A+')),
                DropdownMenuItem(value: 'A-', child: Text('A-')),
                DropdownMenuItem(value: 'B+', child: Text('B+')),
                DropdownMenuItem(value: 'B-', child: Text('B-')),
                DropdownMenuItem(value: 'AB+', child: Text('AB+')),
                DropdownMenuItem(value: 'AB-', child: Text('AB-')),
                DropdownMenuItem(value: 'O+', child: Text('O+')),
                DropdownMenuItem(value: 'O-', child: Text('O-')),
              ],
              onChanged: (value) {
                setState(() {
                  selectedBloodGroup = value;
                });
              },
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () => _selectDate(context),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Required Date',
                  border: OutlineInputBorder(),
                ),
                child: Text(
                  selectedDate?.toString().split(' ')[0] ?? 'Select Date',
                ),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
              ),
              value: selectedLocation,
              items: const [
                DropdownMenuItem(value: 'New York', child: Text('New York')),
                DropdownMenuItem(value: 'Los Angeles', child: Text('Los Angeles')),
                DropdownMenuItem(value: 'Chicago', child: Text('Chicago')),
              ],
              onChanged: (value) {
                setState(() {
                  selectedLocation = value;
                });
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'Available Donors',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: filteredDonors.length,
                itemBuilder: (context, index) {
                  final donor = filteredDonors[index];
                  return Card(
                    child: ListTile(
                      title: Text(donor['name'] ?? ''),
                      subtitle: Text(
                          '${donor['bloodGroup']} • ${donor['location']}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.phone),
                        onPressed: () {
                          // Implement phone call functionality
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
} 