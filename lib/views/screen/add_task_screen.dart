import 'package:flutter/material.dart';
import 'package:nloffice_hrm/models/tasks_model.dart';
import 'package:nloffice_hrm/view_models/task_view_model.dart';
import 'package:nloffice_hrm/views/custom_widgets/base_page.dart';
import 'package:nloffice_hrm/views/custom_widgets/custom_text_form_field.dart';
import 'package:provider/provider.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _taskNameControler = TextEditingController();
  final _taskContentController = TextEditingController();
  void _submit() {
    if (_formKey.currentState!.validate()) {
      final newTask = Tasks(
        taskName: _taskNameControler.text,
        taskContent: _taskContentController.text,
        taskStatus: 0
      );
      Provider.of<TaskViewModel>(context, listen: false)
          .createNewTask(newTask)
          .then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Task added successfully!')),
        );
        Navigator.pop(context);
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add Task: $error')),
        );
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return BasePage(
      showAppBar: true,
      appBar: AppBar(
        title: Text('Thêm Task'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: CustomTextFormField(
                  textEditingController: _taskNameControler,
                  labelText: 'Task Name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'please_enter_task_name';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: CustomTextFormField(
                  textEditingController: _taskContentController,
                  labelText: 'task content',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'please_enter_task_content';
                    }
                    return null;
                  },
                ),
              ),
              ElevatedButton(
                onPressed: _submit,
                child: Text('add_new_task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}