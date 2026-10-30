import 'package:flutter/material.dart';
import '../controllers/settings_controller.dart';
import '../services/database_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = SettingsController.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings & Preferences'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // APPEARANCE SECTION
          _buildSectionHeader(context, 'Appearance'),
          ValueListenableBuilder<ThemeMode>(
            valueListenable: controller.themeModeNotifier,
            builder: (context, currentMode, child) {
              return Card(
                child: Column(
                  children: [
                    RadioListTile<ThemeMode>(
                      title: const Text('System Default'),
                      value: ThemeMode.system,
                      groupValue: currentMode,
                      onChanged: (mode) => controller.updateThemeMode(mode!),
                    ),
                    RadioListTile<ThemeMode>(
                      title: const Text('Light Mode'),
                      value: ThemeMode.light,
                      groupValue: currentMode,
                      onChanged: (mode) => controller.updateThemeMode(mode!),
                    ),
                    RadioListTile<ThemeMode>(
                      title: const Text('Dark Mode'),
                      value: ThemeMode.dark,
                      groupValue: currentMode,
                      onChanged: (mode) => controller.updateThemeMode(mode!),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 24),

          // DATA MANAGEMENT SECTION
          _buildSectionHeader(context, 'Data Management'),
          Card(
            child: ListTile(
              leading: const Icon(Icons.delete_forever, color: Colors.redAccent),
              title: const Text('Clear Quiz History'),
              subtitle: const Text('Permanently remove past score records'),
              onTap: () => _confirmClearHistory(context),
            ),
          ),
          const SizedBox(height: 24),

          // ABOUT SECTION
          _buildSectionHeader(context, 'About Quizora'),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quizora v1.2.0',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'A production-grade college quiz platform built with Flutter, Dart, and SQLite for GDGoC.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  void _confirmClearHistory(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear History?'),
        content: const Text(
          'Are you sure you want to delete all saved quiz results? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () async {
              final db = await DatabaseService.instance.database;
              await db.delete('quiz_history');
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Quiz history cleared successfully.')),
                );
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}