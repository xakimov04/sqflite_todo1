import 'package:experensies/viewmodels/task_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import 'package:intl/intl.dart';

class TaskDetailView extends StatefulWidget {
  final Task task;

  const TaskDetailView({super.key, required this.task});

  @override
  State<TaskDetailView> createState() => _TaskDetailViewState();
}

class _TaskDetailViewState extends State<TaskDetailView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late String _selectedPriority;
  late String _selectedStatus;
  late TextEditingController _dateController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController =
        TextEditingController(text: widget.task.description);

    const validPriorities = ['High', 'Medium', 'Low'];
    const validStatuses = ['Running', 'Completed'];

    _selectedPriority = validPriorities.contains(widget.task.priority)
        ? widget.task.priority
        : 'Medium';
    _selectedStatus = validStatuses.contains(widget.task.status)
        ? widget.task.status
        : 'Running';

    _dateController = TextEditingController(text: widget.task.date);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff3450A1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 4,
        centerTitle: true,
        title: const Text('Task Detail',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          if (widget.task.id != null)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.white),
              onPressed: () {
                Provider.of<TaskViewModel>(context, listen: false)
                    .deleteTask(widget.task.id!);
                Navigator.pop(context);
              },
            ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Card(
            color: const Color.fromARGB(255, 86, 115, 203),
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    _buildTextField(
                      controller: _titleController,
                      labelText: 'Title',
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter a title' : null,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _descriptionController,
                      labelText: 'Description',
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter a description' : null,
                    ),
                    const SizedBox(height: 16),
                    _buildDropdownButtonFormField(
                      value: _selectedPriority,
                      labelText: 'Priority',
                      items: ['High', 'Medium', 'Low'],
                      onChanged: (value) =>
                          setState(() => _selectedPriority = value!),
                    ),
                    const SizedBox(height: 16),
                    _buildDropdownButtonFormField(
                      value: _selectedStatus,
                      labelText: 'Status',
                      items: ['Running', 'Completed'],
                      onChanged: (value) =>
                          setState(() => _selectedStatus = value!),
                    ),
                    const SizedBox(height: 16),
                    _buildDateField(),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final task = Task(
                            id: widget.task.id,
                            title: _titleController.text,
                            description: _descriptionController.text,
                            priority: _selectedPriority,
                            status: _selectedStatus,
                            date: _dateController.text,
                            category: widget.task.category,
                          );
                          if (task.id == null) {
                            Provider.of<TaskViewModel>(context, listen: false)
                                .addTask(task);
                          } else {
                            Provider.of<TaskViewModel>(context, listen: false)
                                .updateTask(task);
                          }
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 32),
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: labelText,
        filled: true,
        fillColor: Colors.blue[100],
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildDropdownButtonFormField({
    required String value,
    required String labelText,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.blue[100],
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildDateField() {
    return TextFormField(
      controller: _dateController,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.blue[100],
        hintText: 'Date',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        suffixIcon: const Icon(Icons.calendar_today),
      ),
      readOnly: true,
      onTap: () async {
        FocusScope.of(context).requestFocus(FocusNode());
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (selectedDate != null) {
          setState(() {
            _dateController.text =
                DateFormat('yyyy-MM-dd').format(selectedDate);
          });
        }
      },
    );
  }
}
