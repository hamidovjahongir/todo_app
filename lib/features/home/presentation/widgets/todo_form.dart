import 'package:flutter/material.dart';

class TodoForm extends StatefulWidget {
  final String? initialTitle;
  final String? initialDescription;
  final Function(String title, String description) onSubmit;

  const TodoForm({
    super.key,
    this.initialTitle,
    this.initialDescription,
    required this.onSubmit,
  });

  @override
  State<TodoForm> createState() => _TodoFormState();
}

class _TodoFormState extends State<TodoForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle ?? '');
    _descriptionController = TextEditingController(text: widget.initialDescription ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmit(
        _titleController.text.trim(),
        _descriptionController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialTitle != null;
    
    return AlertDialog(
      title: Text(
        isEditing ? 'Vazifani tahrirlash' : 'Vazifa qoshish',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),

      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'Enter todo name',
                  labelText: 'Todo name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Todo nomini kiriting';
                  }
                  if (value.trim().length < 3) {
                    return 'Sarlavha kamida 3 ta belgidan iborat bolishi kk';
                  }
                  return null;
                },
              ),
               
               SizedBox(height: 16), 
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Tasnif ',
                  hintText: 'Vazifa haqida batafsil malumot',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
              ),
              SizedBox(height: 8),
              
            ],
          ),
        ),
      ),
      actions: [
        
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Bekor qilish'),
        ),
        ElevatedButton(
          onPressed: _handleSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(isEditing ? 'Saqlash' : 'Qoshish'),
        ),
      ],
    );
  }
}