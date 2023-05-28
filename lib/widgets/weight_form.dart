import 'package:flutter/material.dart';
import 'package:gym_examen_final/models/weight_model.dart';

class WeightForm extends StatefulWidget {
  final Weight? weight;

  WeightForm({this.weight});

  @override
  _WeightFormState createState() => _WeightFormState();
}

class _WeightFormState extends State<WeightForm> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _date;
  late double _value;
  late double _reps;

  @override
  void initState() {
    super.initState();
    if (widget.weight != null) {
      _name = widget.weight!.name;
      _date = widget.weight!.date;
      _value = widget.weight!.value;
      _reps = widget.weight!.reps;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.weight != null ? 'Edit Weight' : 'Create Weight'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: _name,
              decoration: InputDecoration(labelText: 'Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
              onSaved: (value) => _name = value!,
            ),
            TextFormField(
              initialValue: _date,
              decoration: InputDecoration(labelText: 'Date'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a date';
                }
                return null;
              },
              onSaved: (value) => _date = value!,
            ),
            TextFormField(
              initialValue: _value != null ? _value.toString() : '',
              decoration: InputDecoration(labelText: 'Value'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a value';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid value';
                }
                return null;
              },
              onSaved: (value) => _value = double.parse(value!),
            ),
            TextFormField(
              initialValue: _reps != null ? _reps.toString() : '',
              decoration: InputDecoration(labelText: 'Reps'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the number of reps';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number of reps';
                }
                return null;
              },
              onSaved: (value) => _reps = double.parse(value!),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              final newWeight = Weight(
                name: _name,
                date: _date,
                value: _value,
                reps: _reps,
              );
              Navigator.of(context).pop(newWeight);
            }
          },
          child: Text(widget.weight != null ? 'Save' : 'Create'),
        ),
      ],
    );
  }
}
