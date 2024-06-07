import 'package:experensies/viewmodels/task_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'views/task_list_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaskViewModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'To-Do App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const TaskListView(),
      ),
    );
  }
}
