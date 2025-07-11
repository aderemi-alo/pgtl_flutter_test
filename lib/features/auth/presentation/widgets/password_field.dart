import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final String? errorText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final bool enabled;

  const PasswordField({
    super.key,
    this.labelText,
    this.hintText,
    this.errorText,
    this.controller,
    this.onChanged,
    this.validator,
    this.enabled = true,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      onChanged: widget.onChanged,
      validator: widget.validator,
      enabled: widget.enabled,
      obscureText: _obscureText,
      decoration: InputDecoration(
        labelText: widget.labelText ?? 'Password',
        hintText: widget.hintText ?? 'Enter your password',
        errorText: widget.errorText,
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
      ),
    );
  }
}
