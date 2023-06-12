import 'package:flutter/material.dart';
import 'package:gym_examen_final/models/weight_model.dart';
import 'package:intl/intl.dart';

class WeightScreen extends StatefulWidget {
  final Weight? weight;

  WeightScreen({this.weight});

  @override
  _WeightScreenState createState() => _WeightScreenState();
}

class _WeightScreenState extends State<WeightScreen> {
  late TextEditingController _nameController;
  late DateTime _selectedDate;
  late TextEditingController _valueController;
  late TextEditingController _repsController;
  final _dateFormatter = DateFormat('dd/MM/yyyy');
  final _dateValidator = _DateValidator(DateFormat('dd/MM/yyyy'));

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.weight?.name);
    _selectedDate =
        _dateFormatter.parse(widget.weight?.date ?? DateTime.now().toString());
    _valueController =
        TextEditingController(text: widget.weight?.value.toString());
    _repsController =
        TextEditingController(text: widget.weight?.reps.toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _valueController.dispose();
    _repsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('REGISTRAR PESO MAXIMO'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'EJERCICIO',
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              readOnly: true,
              controller: TextEditingController(
                text: _dateFormatter.format(_selectedDate),
              ),
              decoration: InputDecoration(
                labelText: 'FECHA',
              ),
              onTap: () {
                _showDatePicker(context);
              },
              validator: _dateValidator.validate,
              keyboardType: TextInputType.datetime,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _valueController,
              decoration: InputDecoration(
                labelText: 'PESO',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _repsController,
              decoration: InputDecoration(
                labelText: 'REPETICIONES',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                final name = _nameController.text;
                final value = double.parse(_valueController.text);
                final reps = double.parse(_repsController.text);
                final dateFormatter = DateFormat('dd/MM/yyyy');
                final formattedDate = dateFormatter.format(_selectedDate);

                final weight = Weight(
                  name: name,
                  date: formattedDate,
                  value: value,
                  reps: reps,
                );

                Navigator.pop(context);
              },
              child: Text('GUARDAR'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }
}

class _DateValidator {
  final DateFormat _dateFormatter;

  _DateValidator(this._dateFormatter);

  String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ingresa una fecha';
    }

    final datePattern = r'^\d{2}/\d{2}/\d{4}$';
    final dateRegex = RegExp(datePattern);
    if (!dateRegex.hasMatch(value)) {
      return 'Ingresar una fecha con este formato DD/MM/YYYY';
    }

    try {
      _dateFormatter.parseStrict(value);
    } catch (_) {
      return 'Ingresar una fecha con este formato DD/MM/YYYY';
    }

    return null;
  }
}
