import 'package:flutter/material.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.brightness_6),
            title: const Text('Theme'),
            subtitle: const Text('Light/Dark mode'),
            trailing: DropdownButton<String>(
              value: 'System',
              onChanged: (value) {},
              items: const [
                DropdownMenuItem(
                  value: 'System',
                  child: Text('System'),
                ),
                DropdownMenuItem(
                  value: 'Light',
                  child: Text('Light'),
                ),
                DropdownMenuItem(
                  value: 'Dark',
                  child: Text('Dark'),
                ),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifications'),
            subtitle: const Text('Enable/disable notifications'),
            trailing: Switch(
              value: true,
              onChanged: (value) {},
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Language'),
            subtitle: const Text('Choose app language'),
            trailing: DropdownButton<String>(
              value: 'English',
              onChanged: (value) {},
              items: const [
                DropdownMenuItem(
                  value: 'English',
                  child: Text('English'),
                ),
                DropdownMenuItem(
                  value: 'Spanish',
                  child: Text('Spanish'),
                ),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            subtitle: const Text('App information'),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AboutDialog(
                    applicationName: 'Task Manager',
                    applicationVersion: '1.0.0',
                    applicationIcon: const Icon(
                      Icons.task_alt,
                      size: 50,
                      color: Colors.blue,
                    ),
                    children: const [
                      SizedBox(height: 16),
                      Text(
                        'A simple task management app developed with Flutter following MVVM architecture.',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '© 2023 Task Manager Team',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
} 