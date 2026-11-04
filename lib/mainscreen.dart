
import 'package:flutter/material.dart';
import 'activity_database.dart';
import 'newactivity.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Map<String, Object?>> activities = [];

  int currentPage = 1;
  int totalPages = 1;

  final int pageSize = 10;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadActivities();
  }

  // Load activities from SQLite.
  Future<void> loadActivities() async {
    setState(() {
      isLoading = true;
    });

    try {
      int count =
          await ActivityDatabase.instance.getActivityCount();

      int pages = count == 0 ? 1 : (count / pageSize).ceil();

      if (currentPage > pages) {
        currentPage = pages;
      }

      List<Map<String, Object?>> data =
          await ActivityDatabase.instance.getActivities(
        limit: pageSize,
        offset: (currentPage - 1) * pageSize,
      );

      if (!mounted) return;

      setState(() {
        activities = data;
        totalPages = pages;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to load activities'),
        ),
      );
    }
  }

  // Open the add activity form.
  Future<void> addActivity() async {
    bool? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NewActivityPage(),
      ),
    );

    if (result == true) {
      currentPage = 1;
      await loadActivities();
    }
  }

  // Open the update activity form.
  Future<void> editActivity(
      Map<String, Object?> activity) async {
    bool? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewActivityPage(
          activity: activity,
        ),
      ),
    );

    if (result == true) {
      await loadActivities();
    }
  }

  // Get icon based on activity type.
  IconData getActivityIcon(String type) {
    if (type == 'Academic') {
      return Icons.book;
    } else if (type == 'Sports') {
      return Icons.sports_basketball;
    } else if (type == 'Club') {
      return Icons.groups;
    } else if (type == 'Volunteer') {
      return Icons.volunteer_activism;
    } else {
      return Icons.event;
    }
  }

  // Get colour based on activity type.
  Color getActivityColor(String type) {
    if (type == 'Academic') {
      return Colors.blue;
    } else if (type == 'Sports') {
      return Colors.deepOrange;
    } else if (type == 'Club') {
      return Colors.purple;
    } else if (type == 'Volunteer') {
      return Colors.green;
    } else {
      return Colors.teal;
    }
  }

  // Display activity details.
  void showDetails(Map<String, Object?> activity) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            activity['activity_name'] as String,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Type: ${activity['activity_type']}'),
              const SizedBox(height: 10),
              Text('Date: ${activity['activity_date']}'),
              const SizedBox(height: 10),
              Text('Notes: ${activity['notes']}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Close'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(dialogContext);
                editActivity(activity);
              },
              icon: const Icon(Icons.edit),
              label: const Text('Edit'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF527DC4),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }

  // Confirm before deleting an activity.
  Future<void> deleteActivity(
      Map<String, Object?> activity) async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Activity'),
          content: const Text(
            'Are you sure you want to delete this activity?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await ActivityDatabase.instance.deleteActivity(
        activity['id'] as int,
      );

      if (!mounted) return;

      await loadActivities();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Activity deleted successfully'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5FC),

      appBar: AppBar(
        title: const Text(
          'Campus Activity Log',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF527DC4),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: isLoading ? null : loadActivities,
            tooltip: 'Refresh',
          ),
        ],
      ),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF527DC4),
              ),
            )
          : Column(
              children: [
                // Welcome header.
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCE8FF),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome, Student!',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF263D69),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Keep track of your campus activities.',
                        style: TextStyle(
                          color: Color(0xFF52688F),
                        ),
                      ),
                    ],
                  ),
                ),

                // Activity heading.
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'My Activities',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${activities.length} activities on this page',
                        style: const TextStyle(
                          color: Colors.blueGrey,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // Activity list or empty message.
                Expanded(
                  child: activities.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.event_note,
                                size: 70,
                                color: Color(0xFF9BB3D8),
                              ),
                              SizedBox(height: 12),
                              Text(
                                'No activities yet!',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Tap Add Activity below to get started.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.blueGrey,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          itemCount: activities.length,
                          itemBuilder: (context, index) {
                            final activity = activities[index];

                            String type =
                                activity['activity_type'] as String;

                            Color activityColor =
                                getActivityColor(type);

                            return Card(
                              color: Colors.white,
                              elevation: 2,
                              margin: const EdgeInsets.only(
                                bottom: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                contentPadding:
                                    const EdgeInsets.all(12),
                                leading: CircleAvatar(
                                  backgroundColor:
                                      activityColor.withOpacity(0.15),
                                  child: Icon(
                                    getActivityIcon(type),
                                    color: activityColor,
                                  ),
                                ),
                                title: Text(
                                  activity['activity_name']
                                      as String,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 5),
                                  child: Text(
                                    '$type • ${activity['activity_date']}',
                                  ),
                                ),
                                trailing: const Icon(
                                  Icons.chevron_right,
                                  color: Colors.blueGrey,
                                ),
                                onTap: () {
                                  showDetails(activity);
                                },
                                onLongPress: () {
                                  deleteActivity(activity);
                                },
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),

      // Pagination and Add Activity button.
      bottomNavigationBar: SafeArea(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(16, 5, 16, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Page navigation.
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: currentPage > 1 && !isLoading
                        ? () {
                            setState(() {
                              currentPage--;
                            });
                            loadActivities();
                          }
                        : null,
                    icon: const Icon(Icons.arrow_back_ios),
                  ),

                  Text(
                    'Page $currentPage of $totalPages',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  IconButton(
                    onPressed:
                        currentPage < totalPages && !isLoading
                            ? () {
                                setState(() {
                                  currentPage++;
                                });
                                loadActivities();
                              }
                            : null,
                    icon: const Icon(Icons.arrow_forward_ios),
                  ),
                ],
              ),

              const SizedBox(height: 5),

              // Add Activity button below pagination.
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: addActivity,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Activity'),
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
        ),
      ),
    );
  }
}
