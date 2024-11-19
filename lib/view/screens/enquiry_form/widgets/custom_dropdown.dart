import 'package:flutter/material.dart';

class CustomDropdownField extends StatelessWidget {
  final String label;
  final IconData icon;
  final List<String> items;
  final String? value;
  final Function(String?) onChanged;
  final String? Function(String?)? validator;

  const CustomDropdownField({
    super.key,
    required this.label,
    required this.icon,
    required this.items,
    this.value,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    // Ensure value exists in items list
    final currentValue = items.contains(value) ? value : null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 8),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: Colors.blue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              floatingLabelBehavior: FloatingLabelBehavior.never,
            ),
            value: currentValue,
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: onChanged,
            validator: validator,
            isExpanded: true,
            hint: Text(label),
          ),
        ],
      ),
    );
  }
}
