import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/authentication_provider.dart';
import '../screens/my_profile.dart';
import '../utils/utils.dart';
import 'utils/common_widget.dart';

class FieldEditor extends StatefulWidget {
  final String title;
  final String text;
  const FieldEditor({super.key, required this.text, required this.title});

  @override
  State<FieldEditor> createState() => _FieldEditorState();
}

class _FieldEditorState extends State<FieldEditor> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.text;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Edit ${widget.title}'),
          GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.close)),
        ],
      ),
      content: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _controller,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Field cannot be empty';
                  } else if (Utils.toSnakeCase(widget.title) == 'email') {
                    if (!(value.contains('@') && value.contains('.'))) {
                      return 'Invalid email address';
                    }
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: widget.text,
                ),
              ),
              spacingWidget(20, SpaceDirection.vertical),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 15),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await Provider.of<AuthenticationProvider>(context,
                            listen: false)
                        .updateSingleField(
                            Utils.toSnakeCase(widget.title), _controller.text)
                        .then((value) {
                      if (value) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MyProfile(),
                          ),
                        );
                      }
                    });
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
