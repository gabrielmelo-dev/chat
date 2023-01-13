import 'package:chat/models/auth_form_data.dart';
import 'package:chat/widgets/user_image_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key, required this.onSubmit}) : super(key: key);

  final void Function(AuthFormData) onSubmit;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _formData = AuthFormData();

  void _handleImagePicker(File image) {
    _formData.image = image;
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Theme.of(context).errorColor,
      ),
    );
  }

  void _submit() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    if (_formData.image == null && _formData.isSignup) {
      return _showError('Image not selected!!');
    }

    widget.onSubmit(_formData);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (_formData.isSignup)
                UserImagePicker(onImagePick: _handleImagePicker),
              if (_formData.isSignup)
                TextFormField(
                  key: const ValueKey('name'),
                  initialValue: _formData.name,
                  onChanged: (name) => _formData.name = name,
                  validator: (name) {
                    name = name ?? '';
                    if (name.trim().length < 4) {
                      return 'Name must be at least 4 characters.';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Name',
                  ),
                ),
              TextFormField(
                //TODO add regex for email validation
                key: const ValueKey('email'),
                initialValue: _formData.email,
                onChanged: (email) => _formData.email = email,
                validator: (email) {
                  email = email ?? '';
                  if (!email.contains('@')) {
                    return 'Email must be valid.';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
              ),
              TextFormField(
                //TODO add regex for password validation
                key: const ValueKey('password'),
                initialValue: _formData.password,
                onChanged: (password) => _formData.password = password,
                obscureText: true,
                validator: (password) {
                  password = password ?? '';
                  if (password.length < 6) {
                    return 'Password must be at least 6 characters.';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _submit,
                child: Text(_formData.isLogin ? 'Enter' : 'Signup'),
              ),
              TextButton(
                child: Text(_formData.isLogin
                    ? 'Create a new a account'
                    : 'Already have a account'),
                onPressed: () {
                  setState(() {
                    _formData.toggleAuthMode();
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
