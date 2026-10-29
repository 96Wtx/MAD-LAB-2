import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

// Initialize the Flutter application.
void main() {
  runApp(const StudentInfoApp());
}

// Set up the application theme and main screen.
class StudentInfoApp extends StatelessWidget {
  const StudentInfoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CSS3344 Lab 02',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home: const StudentProfileScreen(),
    );
  }
}

// Manage student information, screen orientation, and picker selections.
class StudentProfileScreen extends StatefulWidget {
  const StudentProfileScreen({super.key});

  @override
  State<StudentProfileScreen> createState() =>
      _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {
  DateTime _selectedDate = DateTime.now();
  String _selectedRole = 'Student';

  final List<String> _roles = [
    'Student',
    'Developer',
    'Designer',
  ];

  // Format the selected date.
  String _formatDate(DateTime date) {
    return '${date.year}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  // 1. Material Date Picker (Base Code).
  Future<void> _selectMaterialDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // 2. Cupertino Date Picker (Base Code).
  void _showCupertinoDatePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 240,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.date,
          initialDateTime: DateTime.now(),
          onDateTimeChanged: (DateTime newDate) {
            setState(() {
              _selectedDate = newDate;
            });
          },
        ),
      ),
    );
  }

  // 3. Material DropdownButton (Base Code).
  Widget _buildMaterialRoleDropdown() {
    return DropdownButton<String>(
      value: _selectedRole,
      isExpanded: true,
      items: _roles.map((String role) {
        return DropdownMenuItem<String>(
          value: role,
          child: Text(role),
        );
      }).toList(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          setState(() {
            _selectedRole = newValue;
          });
        }
      },
    );
  }

  // 4. Cupertino Picker (Wheel) (Base Code).
  void _showCupertinoRolePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 200,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: CupertinoPicker(
          itemExtent: 32,
          onSelectedItemChanged: (int index) {
            setState(() {
              _selectedRole = _roles[index];
            });
          },
          children: _roles.map((role) {
            return Center(child: Text(role));
          }).toList(),
        ),
      ),
    );
  }

  // Reusable button to reduce repeated UI code.
  Widget _pickerButton(
      String label,
      IconData icon,
      VoidCallback onPressed,
      ) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 16),
        label: Align(
          alignment: Alignment.centerLeft,
          child: Text(label),
        ),
        style: OutlinedButton.styleFrom(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ),
          visualDensity: VisualDensity.compact,
          textStyle: const TextStyle(fontSize: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  // Display all four pickers in one compact card.
  Widget _buildPickerSection(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pickers (Lab 2.2)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(height: 16),

            Text(
              'Selected Date: ${_formatDate(_selectedDate)}',
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 3),
            Text(
              'Selected Role: $_selectedRole',
              style: TextStyle(
                fontSize: 12,
                color: Colors.indigo.shade700,
              ),
            ),
            const SizedBox(height: 10),

            // 1. Material Date Picker.
            _pickerButton(
              'Material Date Picker',
              Icons.calendar_month,
                  () => _selectMaterialDate(context),
            ),
            const SizedBox(height: 5),

            // 2. Cupertino Date Picker.
            _pickerButton(
              'Cupertino Date Picker (Modal Sheet)',
              Icons.date_range,
                  () => _showCupertinoDatePicker(context),
            ),
            const SizedBox(height: 10),

            // 3. Material Dropdown.
            const Text(
              'Material Dropdown:',
              style: TextStyle(fontSize: 12),
            ),
            _buildMaterialRoleDropdown(),
            const SizedBox(height: 5),

            // 4. Cupertino Wheel Picker.
            _pickerButton(
              'Cupertino Wheel Picker',
              Icons.tune,
                  () => _showCupertinoRolePicker(context),
            ),
          ],
        ),
      ),
    );
  }

  // Build the main screen and detect screen orientation.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CSS3344 Mobile App Dev - Lab 02'),
        centerTitle: true,
        backgroundColor:
        Theme.of(context).colorScheme.primaryContainer,
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            return _buildPortraitView(context);
          } else {
            return _buildLandscapeView(context);
          }
        },
      ),
    );
  }

  // Arrange the content vertically in portrait mode.
  Widget _buildPortraitView(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const StudentDetailsSection(),
        const SizedBox(height: 12),
        const TitleSection(
          name: 'University of Technology Sarawak',
          location: 'Sibu, Sarawak',
          starCount: 41,
        ),
        const SizedBox(height: 12),
        const ImageSection(
          imagePath:
          'assets/lake-tahoe-california-USLAKES0920-59df9ea26eaf4bbba7620eb604f0af3c.jpg',
        ),
        const SizedBox(height: 12),
        _buildPickerSection(context),
      ],
    );
  }

  // Arrange the content side-by-side in landscape mode.
  Widget _buildLandscapeView(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(
          flex: 1,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(12),
            child: StudentDetailsSection(),
          ),
        ),
        Expanded(
          flex: 1,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                const TitleSection(
                  name: 'University of Technology Sarawak',
                  location: 'Sibu, Sarawak',
                  starCount: 41,
                ),
                const SizedBox(height: 12),
                const ImageSection(
                  imagePath:
                  'assets/lake-tahoe-california-USLAKES0920-59df9ea26eaf4bbba7620eb604f0af3c.jpg',
                ),
                const SizedBox(height: 12),
                _buildPickerSection(context),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Display student information and personal quote.
class StudentDetailsSection extends StatelessWidget {
  const StudentDetailsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.indigo,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white,
              backgroundImage: AssetImage('assets/BCS24020027.jpeg'),
            ),
            const SizedBox(height: 16),
            const Text(
              'WONG YI',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Student ID: BCS24020027',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
            const Divider(height: 28, color: Colors.white54),
            const Text(
              'Personal Life Goal / Quote:',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '"Live in the moment"',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Display university name, location, and star rating.
class TitleSection extends StatelessWidget {
  final String name;
  final String location;
  final int starCount;

  const TitleSection({
    super.key,
    required this.name,
    required this.location,
    required this.starCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  location,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Icon(Icons.star, color: Colors.indigo[400]),
          const SizedBox(width: 4),
          Text('$starCount'),
        ],
      ),
    );
  }
}

// Display the image from the assets folder.
class ImageSection extends StatelessWidget {
  final String imagePath;

  const ImageSection({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Image.asset(
        imagePath,
        width: double.infinity,
        height: 180,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 180,
            alignment: Alignment.center,
            color: Colors.grey.shade200,
            child: const Text(
              'Unable to load image. Check the asset path.',
              textAlign: TextAlign.center,
            ),
          );
        },
      ),
    );
  }
}
