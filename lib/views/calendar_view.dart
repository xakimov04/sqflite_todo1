import 'package:experensies/viewmodels/task_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CalendarView extends StatelessWidget {
  const CalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const  Text('Calendar View'),
      ),
      body: Consumer<TaskViewModel>(
        builder: (context, viewModel, child) {
          return const Center(
            child: Text('Calendar View under construction'),
          );
        },
      ),
    );
  }
}
