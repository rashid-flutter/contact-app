import 'package:contact_app/contact_app/controller/contact_providerers.dart';
import 'package:contact_app/contact_app/model/contact_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateContact extends ConsumerWidget {
  final ContactModel contact;

  UpdateContact({super.key, required this.contact});

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _nameController.text = contact.name;
    _phoneController.text = contact.number;
    _emailController.text = contact.email;

    return Scaffold(
      appBar: AppBar(title: const Text('Update Contact')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a phone number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final updatedContact = ContactModel(
                      id: contact.id,
                      name: _nameController.text,
                      number: _phoneController.text,
                      email: _emailController.text,
                    );
                    ref.read(contactsPro.notifier).updateCon(updatedContact);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Update Contact'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
