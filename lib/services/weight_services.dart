import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:gym_examen_final/models/weight_model.dart';

class WeightService extends ChangeNotifier {
  final String apiUrl =
      'https://flutter-gym-app-10f50-default-rtdb.firebaseio.com';

  List<Weight> _weights = [];
  List<Weight> get weights => _weights;

  Future<void> fetchWeights() async {
    final response = await http.get(Uri.parse(apiUrl + '/weights.json'));
    print(response.body);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final updatedWeights = data.entries.map((entry) {
        final weightData = entry.value as Map<String, dynamic>;
        final weightId = entry.key;
        weightData['id'] = weightId;
        return Weight.fromJson(weightData);
      }).toList();
      _weights = updatedWeights;
      notifyListeners();
    } else {
      throw Exception('Error al obtener los pesos');
    }
  }

  Future<Weight> createOrUpdateWeight(Weight weight) async {
    if (weight.id == null || weight.id == '') {
      return createWeight(weight);
    } else {
      return updateWeight(weight);
    }
  }

  Future<Weight> createWeight(Weight weight) async {
    print('CREAR WEIGHT');
    final response = await http.post(
      Uri.parse(apiUrl + '/weights.json'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(weight.toJson()),
    );

    if (response.statusCode == 200) {
      weight.id = jsonDecode(response.body)['name'];
      _weights.add(weight);
      notifyListeners();
      return weight;
    } else {
      throw Exception('Error al crear el peso');
    }
  }

  Future<Weight> updateWeight(Weight weight) async {
    print('UPDATE WEIGHT');
    print(weight.toJson());
    final url = Uri.parse(apiUrl + '/weights/${weight.id}.json');

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(weight.toJson()),
    );
    if (response.statusCode == 200) {
      final dynamic data = jsonDecode(response.body);
      final updatedWeight = Weight.fromJson(data);
      final index = _weights.indexWhere((w) => w.id == updatedWeight.id);
      if (index != -1) {
        _weights[index] = updatedWeight;
        notifyListeners();
      }
      return updatedWeight;
    } else {
      throw Exception('Error al actualizar el peso');
    }
  }

  Future<void> deleteWeight(String id) async {
    print('DELETE WEIGHT');
    print(id);
    final url = Uri.parse(apiUrl + '/weights/$id.json');
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      _weights.removeWhere((weight) => weight.id == id);
      notifyListeners();
    } else {
      throw Exception('Error al eliminar el peso');
    }
  }
}
