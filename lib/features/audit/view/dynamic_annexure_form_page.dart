import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/appcolors.dart';
import '../controller/AnnexureViewController.dart';

class DynamicAnnexureFormPage extends StatefulWidget {
  final List<dynamic> formFields;

  const DynamicAnnexureFormPage({super.key, required this.formFields});

  @override
  State<DynamicAnnexureFormPage> createState() => _DynamicAnnexureFormPageState();
}

class _DynamicAnnexureFormPageState extends State<DynamicAnnexureFormPage> {

  final controller = Get.find<AnnexureViewController>();


  final _formKey = GlobalKey<FormState>();
  late Map<String, dynamic> _formData;
  late Map<String, TextEditingController> _textControllers;

  @override
  void initState() {
    super.initState();
    _formData = {};
    _textControllers = {};
    for (var field in widget.formFields) {
      final key = field['annexureHeader'] as String;
      if (field['annexureType'] == 'Text') {
        _textControllers[key] = TextEditingController();
      }
    }
  }

  @override
  void dispose() {
    _textControllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, String fieldName) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _formData[fieldName] is DateTime ? _formData[fieldName] : DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _formData[fieldName]) {
      setState(() {
        _formData[fieldName] = picked;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      _textControllers.forEach((key, controller) {
        _formData[key] = controller.text;
      });
      
      final Map<String, dynamic> submissionData = {};
      _formData.forEach((key, value) {
        if (value is DateTime) {
          submissionData[key] = DateFormat('yyyy-MM-dd').format(value);
        } else {
          submissionData[key] = value;
        }
    });
      controller.setAnnexureData(submissionData);



    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Annexure Details', style: TextStyle(color: Colors.white)),
        backgroundColor: primaryDarkBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: widget.formFields.length,
          itemBuilder: (context, index) {
            final field = widget.formFields[index];

            final fieldType = field['annexureType']?.toString() ?? '';
            final fieldLabel = field['annexureHeader']?.toString() ?? '';


            if (fieldType == 'Date') {
              return _buildDatePickerField(fieldLabel);
            }
            if (fieldType == 'Text') {
              return _buildTextField(fieldLabel);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _submitForm,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Submit',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: _textControllers[label],
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.grey.shade100,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }


  Widget _buildDatePickerField(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        onTap: () => _selectDate(context, label),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: Colors.grey.shade100,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                _formData[label] != null
                    ? DateFormat('dd/MM/yyyy').format(_formData[label])
                    : 'Select a date',
                style: TextStyle(
                  color: _formData[label] != null ? Colors.black : Colors.grey[600],
                ),
              ),
              const Icon(Icons.calendar_today, color: primaryDarkBlue),
            ],
          ),
        ),
      ),
    );
  }

}
