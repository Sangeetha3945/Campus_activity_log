# Campus Activity Log

**Name:** Sangeetha A/P Selvakumar        
**Matric Number:** 309864      
**Assignment:** Assignment 1         
**Application Name:** Campus Activity Log

## 1. Application Purpose

Campus Activity Log helps university students record, organise, view, update and manage their campus activities in one place. Students can keep track of activities such as academic programmes, sports, club activities and volunteering programmes and other activities.

The application uses Flutter and Dart for mobile application development and SQLite for local data storage.

## 2. Application Features

The application provides the following features:
- Splash Screen: Displays the application name and introduction for approximately 3 seconds before navigating to the home screen.
- View Activities: Displays saved campus activities in organised cards.
- Add Activity: Allows users to record a new campus activity.
- Activity Categories: Provides five categories: Academic, Sports, Club, Volunteer and Other.
- Form Validation: Checks required information before saving an activity.
- Save Confirmation: Displays a confirmation dialog before inserting a new activity.
- Activity Details: Allows users to view the complete information of a selected activity.
- Update Activity: Allows users to edit and update existing activity information.
- Delete Activity: Provides a confirmation dialog before deleting an activity.
- Refresh: Reloads the activity list from the SQLite database.
- Pagination: Displays a maximum of 10 activities per page, with Previous and Next navigation buttons.

## 3. Record Fields

The application contains four main record fields:

| Field | Description | Requirement |
|---|---|---|
| Activity Name | Name of the campus activity | Required |
| Activity Type | Category of the activity | Required |
| Activity Date | Date of the activity | Required |
| Notes | Additional information about the activity | Optional |

**Available Activity Types:**
- Academic
- Sports
- Club
- Volunteer
- Other

The application includes form validation to ensure that all required information is entered before saving an activity.

## 4. Database Structure

The application uses SQLite as its local database through the `sqflite` Flutter package.

**Database Name:** `campus_activity.db`

**Table Name:** `activities`

### Table Structure

| Column Name | Data Type | Description |
|---|---|---|
| id | INTEGER | Primary key with auto-increment |
| activity_name | TEXT | Name of the activity |
| activity_type | TEXT | Category of the activity |
| activity_date | TEXT | Date of the activity |
| notes | TEXT | Additional activity notes |
| created_at | TEXT | Date and time the record was created |

### Database Operations

The application supports the following database operations:

- **Create:** Creates the activities table when the database is first opened.
- **Insert:** Saves new activity records.
- **Read:** Retrieves and displays saved activities.
- **Update:** Modifies existing activity records.
- **Delete:** Removes selected activity records.

The application also implements pagination, displaying a maximum of 10 activity records per page.

## 5. Setup Instructions

### Requirements

- Flutter SDK
- Dart SDK
- Visual Studio Code or Android Studio
- Android Emulator or physical Android device

### Installation Steps

**Step 1: Clone the GitHub Repository**

```bash
git clone https://github.com/Sangeetha3945/Campus_activity_log.git
```

**Step 2: Navigate to the Project Folder**

```bash
cd Campus_activity_log
```

**Step 3: Install the Required Dependencies**

```bash
flutter pub get
```

**Step 4: Check Connected Devices**

```bash
flutter devices
```

**Step 5: Run the Application**

```bash
flutter run
```

The application will run on the selected Android emulator or connected device.

## 6. Main Application Flow

The application follows these steps:

1. **Launch Application:** The application starts and displays the splash screen.
2. **Main Screen:** After approximately 3 seconds, users are directed to the main screen.
3. **View Activities:** Users can view their saved campus activities.
4. **Add Activity:** Users click the Add Activity button to open the activity form.
5. **Enter Information:** Users enter the activity name, select the activity type and date, and optionally provide notes.
6. **Validation:** The application checks that all required fields are completed.
7. **Save Activity:** Users confirm the save operation, and the activity is stored in the SQLite database.
8. **View Details:** Users can select an activity to view its complete information.
9. **Update Activity:** Users can edit and update existing activity records.
10. **Delete Activity:** Users can long-press an activity and confirm before deleting it.
11. **Pagination:** Users can navigate through activity records using the Previous and Next buttons.
12. **Refresh:** Users can refresh the activity list to reload the saved records.

## 6. Asset and Code Credits

The following technologies, packages and resources were used in developing this application:

- **Flutter:** Used as the mobile application development framework.
- **Dart:** Used as the programming language.
- **SQLite:** Used for local database storage.
- **sqflite:** Used to perform SQLite database operations.
- **path:** Used to manage database file paths.
- **Material Design Widgets and Icons:** Used to design the application's user interface.
