import 'package:flutter/material.dart';
import 'package:gym_examen_final/models/weight_model.dart';

class WeightFormProvider extends ChangeNotifier {
  Weight _newWeight = Weight(name: '', date: '', value: 0.0, reps: 0.0);

  Weight get newWeight => _newWeight;

  set newWeight(Weight weight) {
    _newWeight = weight;
    notifyListeners();
  }

  void resetForm() {
    _newWeight = Weight(name: '', date: '', value: 0.0, reps: 0.0);
  }
}
