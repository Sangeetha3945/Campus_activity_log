
import 'package:flutter/material.dart';
import 'activity_database.dart';

class NewActivityPage extends StatefulWidget {
  final Map<String, Object?>? activity;

  const NewActivityPage({super.key, this.activity});

  @override
  State<NewActivityPage> createState() => _NewActivityPageState();
}

class _NewActivityPageState extends State<NewActivityPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController =
      TextEditingController();

  final TextEditingController notesController =
      TextEditingController();

  String? selectedType;
  DateTime? selectedDate;

  final List<String> activityTypes = [
    'Academic',
    'Sports',
    'Club',
    'Volunteer',
    'Other',
  ];

  bool get isEditing => widget.activity != null;

  @override
  void initState() {
    super.initState();

    // Load existing information when editing.
    if (isEditing) {
      nameController.text =
          widget.activity!['activity_name'] as String;

      notesController.text =
          widget.activity!['notes'] as String;

      selectedType =
          widget.activity!['activity_type'] as String;

      String date =
          widget.activity!['activity_date'] as String;

      List<String> dateParts = date.split('/');

      if (dateParts.length == 3) {
        selectedDate = DateTime(
          int.parse(dateParts[2]),
          int.parse(dateParts[1]),
          int.parse(dateParts[0]),
        );
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    notesController.dispose();
    super.dispose();
  }

  // Select activity date.
  Future<void> chooseDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  // Reset form fields.
  void resetForm() {
    nameController.clear();
    notesController.clear();

    setState(() {
      selectedType = null;
      selectedDate = null;
    });

    _formKey.currentState!.reset();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Form has been reset'),
      ),
    );
  }

  // Save a new activity or update an existing activity.
  Future<void> saveActivity() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an activity date'),
        ),
      );
      return;
    }

    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          isEditing ? 'Confirm Update' : 'Confirm Save',
        ),
        content: Text(
          isEditing
              ? 'Are you sure you want to update this activity?'
              : 'Are you sure you want to save this activity?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: Text(isEditing ? 'Update' : 'Save'),
          ),
        ],
      ),
    );

    if (confirm != true) {
      return;
    }

    String formattedDate =
        '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}';

    try {
      if (isEditing) {
        await ActivityDatabase.instance.updateActivity(
          id: widget.activity!['id'] as int,
          activityName: nameController.text.trim(),
          activityType: selectedType!,
          activityDate: formattedDate,
          notes: notesController.text.trim(),
        );
      } else {
        await ActivityDatabase.instance.insertActivity(
          activityName: nameController.text.trim(),
          activityType: selectedType!,
          activityDate: formattedDate,
          notes: notesController.text.trim(),
        );
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEditing
                ? 'Activity updated successfully!'
                : 'Activity saved successfully!',
          ),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEditing
                ? 'Unable to update activity'
                : 'Unable to save activity',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5FC),
      appBar: AppBar(
        title: Text(
          isEditing ? 'Update Activity' : 'Add New Activity',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF527DC4),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Activity Name *',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: 'Enter activity name',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.event),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter activity name';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              const Text(
                'Activity Type *',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              DropdownButtonFormField<String>(
                value: selectedType,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.category),
                ),
                hint: const Text('Select activity type'),
                items: activityTypes.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedType = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select activity type';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              const Text(
                'Activity Date *',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              InkWell(
                onTap: chooseDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.calendar_month),
                  ),
                  child: Text(
                    selectedDate == null
                        ? 'Select activity date'
                        : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Notes (Optional)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              TextFormField(
                controller: notesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Enter additional notes',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),

              const SizedBox(height: 30),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: resetForm,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reset'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: saveActivity,
                      icon: Icon(
                        isEditing ? Icons.edit : Icons.save,
                      ),
                      label: Text(
                        isEditing ? 'Update' : 'Save',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF527DC4),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
