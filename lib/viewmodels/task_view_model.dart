import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/database_helper.dart';

class TaskViewModel extends ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  Future<void> fetchTasks() async {
    _tasks = await _dbHelper.readAllTasks();
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    await _dbHelper.create(task);
    fetchTasks();
  }

  Future<void> updateTask(Task task) async {
    await _dbHelper.update(task);
    fetchTasks();
  }

  Future<void> deleteTask(int id) async {
    await _dbHelper.delete(id);
    fetchTasks();
  }
}
