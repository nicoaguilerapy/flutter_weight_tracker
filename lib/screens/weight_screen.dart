import 'package:flutter/material.dart';
import 'package:gym_examen_final/models/weight_model.dart';
import 'package:gym_examen_final/services/weight_services.dart';
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
  String weightId = '';

  @override
  void initState() {
    super.initState();
    print("------------------\nPeso a modificar:");
    print(widget.weight?.toJson());
    print("------------------");
    _nameController = TextEditingController(text: widget.weight?.name);
    _selectedDate = DateFormat('dd/MM/yyyy').parse(
        widget.weight?.date.split(' ')[0] ??
            DateFormat('dd/MM/yyyy').format(DateTime.now()));
    _valueController =
        TextEditingController(text: widget.weight?.value.toString());
    _repsController =
        TextEditingController(text: widget.weight?.reps.toString());
    weightId = widget.weight?.id ?? weightId;
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
        title: Text(widget.weight != null
            ? 'MODIFICAR PESO MÁXIMO'
            : 'REGISTRAR PESO MÁXIMO'),
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

                Weight weight = Weight(
                  id: weightId,
                  name: name,
                  date: formattedDate,
                  value: value,
                  reps: reps,
                );
                print('------------------');
                print(weight.toJson());
                print('------------------');
                WeightService weightService = WeightService();
                weightService.createOrUpdateWeight(weight);
                weightService.fetchWeights();
                Navigator.pop(context, true);
              },
              child: Text('GUARDAR'),
            ),
            SizedBox(height: 8),
            if (widget.weight != null)
              ElevatedButton.icon(
                onPressed: () async {
                  final confirmDelete = await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Confirmar eliminación'),
                      content: Text(
                          '¿Estás seguro de que deseas eliminar este peso?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                          child: Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () {
                            WeightService weightService = WeightService();
                            weightService.deleteWeight(weightId);
                            weightService.fetchWeights();
                            Navigator.pop(context, true);
                          },
                          child: Text('ELIMINAR'),
                        ),
                      ],
                    ),
                  );

                  if (confirmDelete == true) {
                    Navigator.pop(context, true);
                  }
                },
                icon: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
                label: Text(
                  'ELIMINAR',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                ),
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
