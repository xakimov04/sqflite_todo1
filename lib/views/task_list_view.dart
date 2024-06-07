import 'package:experensies/viewmodels/task_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'task_detail_view.dart';
import '../models/task.dart';
import 'navigation_drawer.dart';

class TaskListView extends StatefulWidget {
  const TaskListView({super.key});

  @override
  State<TaskListView> createState() => _TaskListViewState();
}

class _TaskListViewState extends State<TaskListView> {
  final _advancedDrawerController = AdvancedDrawerController();
  String selectedCategory = 'Business';

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      backdropColor: const Color(0xff041955),
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: false,
      disabledGestures: false,
      childDecoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(50)),
      ),
      drawer: const CustomDrawer(),
      child: Scaffold(
        backgroundColor: const Color(0xff3450A1),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text("What's up, Joy!", style: TextStyle(color: Colors.black)),
          leading: IconButton(
            icon: ValueListenableBuilder<AdvancedDrawerValue>(
              valueListenable: _advancedDrawerController,
              builder: (_, value, __) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: Icon(
                    value.visible ? Icons.clear : Icons.menu,
                    key: ValueKey<bool>(value.visible),
                    color: Colors.black,
                  ),
                );
              },
            ),
            onPressed: _handleMenuButtonPressed,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.black),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.black),
              onPressed: () {},
            ),
          ],
        ),
        body: Consumer<TaskViewModel>(
          builder: (context, viewModel, child) {
            final tasks = viewModel.tasks
                .where((task) => task.category == selectedCategory)
                .toList();
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildCategoryCard(
                        context,
                        'Business',
                        viewModel.tasks
                            .where((task) => task.category == 'Business')
                            .length,
                        Colors.purpleAccent,
                        Icons.work,
                      ),
                      _buildCategoryCard(
                        context,
                        'Personal',
                        viewModel.tasks
                            .where((task) => task.category == 'Personal')
                            .length,
                        Colors.blueAccent,
                        Icons.person,
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Today's Tasks",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: AnimationLimiter(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 375),
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: TaskListItem(task: task),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFF1E1E99),
          child: const Icon(Icons.add, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TaskDetailView(
                  task: Task(
                    title: '',
                    description: '',
                    priority: 'Medium',
                    status: 'Pending',
                    date: '',
                    category: selectedCategory,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _handleMenuButtonPressed() {
    _advancedDrawerController.showDrawer();
  }

  Widget _buildCategoryCard(
    BuildContext context,
    String title,
    int taskCount,
    Color color,
    IconData icon,
  ) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = title;
        });
      },
      child: Card(
        color:
            selectedCategory == title ? color.withOpacity(0.1) : Colors.white,
        elevation: 2,
        child: Container(
          width: 150,
          // height: 100,
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color),
              const SizedBox(height: 10),
              Text(
                '$taskCount tasks',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              LinearProgressIndicator(
                value: taskCount / 50,
                color: color,
                backgroundColor: color.withOpacity(0.2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TaskListItem extends StatelessWidget {
  final Task task;

  const TaskListItem({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(
          task.status == 'Completed' ? Icons.check_circle : Icons.circle,
          color: task.status == 'Completed' ? Colors.green : Colors.grey,
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.status == 'Completed'
                ? TextDecoration.lineThrough
                : TextDecoration.none,
          ),
        ),
        subtitle: Text(task.description),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskDetailView(task: task),
            ),
          );
        },
      ),
    );
  }
}
