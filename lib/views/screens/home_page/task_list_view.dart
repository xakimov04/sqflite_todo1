import 'package:experensies/viewmodels/task_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'task_detail_view.dart';
import '../../../models/task.dart';
import '../../widgets/navigation_drawer.dart';

class TaskListView extends StatefulWidget {
  const TaskListView({super.key});

  @override
  State<TaskListView> createState() => _TaskListViewState();
}

class _TaskListViewState extends State<TaskListView> {
  final _advancedDrawerController = AdvancedDrawerController();
  String selectedCategory = 'Business';

  Future<void> _refreshTasks() async {
    await Future.delayed(const Duration(seconds: 1));
    Provider.of<TaskViewModel>(context, listen: false).fetchTasks();
  }

  @override
  void initState() {
    Provider.of<TaskViewModel>(context, listen: false).fetchTasks();
    super.initState();
  }

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
          leading: IconButton(
            icon: ValueListenableBuilder<AdvancedDrawerValue>(
              valueListenable: _advancedDrawerController,
              builder: (_, value, __) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: Icon(
                    value.visible ? Icons.clear : Icons.menu,
                    key: ValueKey<bool>(value.visible),
                    color: const Color(0xff86A3EF),
                  ),
                );
              },
            ),
            onPressed: _handleMenuButtonPressed,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Color(0xff86A3EF)),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(
                Icons.notifications_none_sharp,
                color: Color(0xff86A3EF),
              ),
              onPressed: () {},
            ),
          ],
        ),
        body: Consumer<TaskViewModel>(
          builder: (context, viewModel, child) {
            final tasks = viewModel.tasks
                .where((task) => task.category == selectedCategory)
                .toList();
            return RefreshIndicator(
              onRefresh: _refreshTasks,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: Text(
                      "What`s up, John",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 16, top: 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Categories",
                        style: TextStyle(
                          fontSize: 20,
                          color: Color(0xff86A3EF),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 16, top: 10, bottom: 10),
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
                          const Gap(10),
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
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Today's Tasks",
                        style: TextStyle(
                          fontSize: 20,
                          color: Color(0xff86A3EF),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  tasks.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(top: 80),
                          child: Center(
                            child: Image.asset(
                              "images/not.png",
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : Expanded(
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
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
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
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        color: selectedCategory == title
            ? const Color(0xff041955)
            : const Color(0xff041955).withOpacity(.3),
        elevation: 2,
        child: Container(
          width: 180,
          padding: const EdgeInsets.all(15.0),
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
                minHeight: 5,
                borderRadius: BorderRadius.circular(20),
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
      color: const Color(0xff0A215E),
      shape: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: GestureDetector(
          onTap: () {
            Provider.of<TaskViewModel>(context, listen: false).updateTaskStatus(
                task, task.status == 'Completed' ? 'Running' : 'Completed');
          },
          child: Icon(
            task.status == 'Completed' ? Icons.check_circle : Icons.circle,
            color: task.status == 'Completed' ? Colors.green : Colors.grey,
          ),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            decorationColor: Colors.red,
            decorationThickness: 3,
            decoration: task.status == 'Completed'
                ? TextDecoration.lineThrough
                : TextDecoration.none,
          ),
        ),
        subtitle: Text(
          task.description,
          style: const TextStyle(
            color: Color(0xff86A3EF),
          ),
        ),
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
