import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/category.dart';
import '../viewmodels/task_list_viewmodel.dart';
import 'tabs/all_tasks_tab.dart';
import 'tabs/pending_tasks_tab.dart';
import 'tabs/completed_tasks_tab.dart';
import 'task_create_view.dart';
import 'category_tasks_view.dart';
import 'settings_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TaskListViewModel _viewModel = TaskListViewModel();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => _viewModel,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Task Manager'),
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(icon: Icon(Icons.list), text: 'All'),
              Tab(icon: Icon(Icons.pending), text: 'Pending'),
              Tab(icon: Icon(Icons.done_all), text: 'Completed'),
            ],
          ),
        ),
        drawer: _buildDrawer(),
        body: TabBarView(
          controller: _tabController,
          children: const [
            AllTasksTab(),
            PendingTasksTab(),
            CompletedTasksTab(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TaskCreateView()),
            ).then((_) => _viewModel.refreshTasks());
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.task_alt, size: 40, color: Colors.blue),
                ),
                SizedBox(height: 10),
                Text(
                  'Task Manager',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
                Text(
                  'Organize your tasks',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
            child: Text(
              'Categories',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          ...Categories.all.map((category) {
            return ListTile(
              leading: Icon(category.icon, color: category.color),
              title: Text(category.name),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryTasksView(category: category),
                  ),
                ).then((_) => _viewModel.refreshTasks());
              },
            );
          }).toList(),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsView()),
              );
            },
          ),
        ],
      ),
    );
  }
} 