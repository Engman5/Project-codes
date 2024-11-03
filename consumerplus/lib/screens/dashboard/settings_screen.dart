import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/fade_route.dart';
import '../onboarding_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  // State variables for unit preferences
  String _selectedUnit = 'kWh'; // Default energy unit

  // State variables for permission statuses
  Map<Permission, PermissionStatus> _statuses = {};

  @override
  void initState() {
    super.initState();
    _loadUnitPreference();
    _checkPermissions();
  }

  // Load the saved energy unit preference
  _loadUnitPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedUnit = prefs.getString('energy_unit') ?? 'kWh';
    });
  }

  // Save the energy unit preference
  _saveUnitPreference(String unit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('energy_unit', unit);
  }

  // Check current permission statuses
  _checkPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      Permission.location,
      Permission.camera, // Example permissions
    ].request();
    setState(() {
      _statuses = statuses;
    });
  }

  // Open the app settings for managing permissions
  _openAppSettings() async {
    bool opened = await openAppSettings();
    if (!opened) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Unable to open app settings'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          // Unit Preferences Section
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Unit Preferences',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            title: const Text('Kilowatt-hours (kWh)'),
            leading: Radio<String>(
              value: 'kWh',
              groupValue: _selectedUnit,
              onChanged: (String? value) {
                setState(() {
                  _selectedUnit = value!;
                  _saveUnitPreference(_selectedUnit);
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Watt-hours (Wh)'),
            leading: Radio<String>(
              value: 'Wh',
              groupValue: _selectedUnit,
              onChanged: (String? value) {
                setState(() {
                  _selectedUnit = value!;
                  _saveUnitPreference(_selectedUnit);
                });
              },
            ),
          ),

          // App Permissions Section
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'App Permissions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            title: const Text('Storage Permission'),
            subtitle: Text(_statuses[Permission.storage]?.isGranted == true
                ? 'Granted'
                : 'Denied'),
          ),
          ListTile(
            title: const Text('Location Permission'),
            subtitle: Text(_statuses[Permission.location]?.isGranted == true
                ? 'Granted'
                : 'Denied'),
          ),
          ListTile(
            title: const Text('Camera Permission'),
            subtitle: Text(_statuses[Permission.camera]?.isGranted == true
                ? 'Granted'
                : 'Denied'),
          ),
          ElevatedButton(
            onPressed: _openAppSettings,
            child: const Text('Manage Permissions in App Settings'),
          ),

          // About the App Section
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'About the App',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Electricity Consumption Estimator\n\n'
              'This app helps users estimate the electricity consumption of various appliances. '
              'Users can input the power rating of their appliances and the number of hours they are used per day. '
              'The app calculates the energy consumption in kilowatt-hours (kWh) and provides an estimated monthly bill based on the current electricity tariffs.\n\n'
              'Key Features:\n'
              '- Add appliances and track their energy consumption.\n'
              '- Switch between Residential and Non-Residential consumer types.\n'
              '- Analyze energy usage through graphical analysis.\n'
              '- Dark and light mode support.\n'
              '- Firebase integration for authentication and real-time data storage.\n\n'
              'This app is designed to help users manage their electricity usage more efficiently, reducing costs and promoting energy-saving habits.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                FadeRoute(page: const OnboardingScreen()),
              );
            },
            child: const Text('Check Out Features'),
          ),
        ],
      ),
    );
  }
}
