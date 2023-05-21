import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:gym_examen_final/models/weight_model.dart';

class WeightService extends ChangeNotifier {
  final String apiUrl =
      'https://flutter-gym-app-10f50-default-rtdb.firebaseio.com/weights.json';

  List<Weight> _weights = [];

  List<Weight> get weights => _weights;

  Future<void> fetchWeights() async {
    final response = await http.get(Uri.parse(apiUrl));
    print(response.body); // Verifica el cuerpo de la respuesta en la consola

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      _weights = data.map((json) => Weight.fromJson(json)).toList();
      notifyListeners();
    } else {
      throw Exception('Failed to fetch weights');
    }
  }

  Future<Weight> createWeight(Weight weight) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(weight.toJson()),
    );
    final List<dynamic> data = jsonDecode(response.body);
    print(data); // Verifica los datos en la consola
    if (response.statusCode == 201) {
      final dynamic data = jsonDecode(response.body);
      final newWeight = Weight.fromJson(data);
      _weights.add(newWeight);
      notifyListeners();
      return newWeight;
    } else {
      throw Exception('Failed to create weight');
    }
  }

  Future<Weight> updateWeight(Weight weight) async {
    final url = '$apiUrl/${weight.id}';
    final response = await http.put(
      Uri.parse(url),
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
      throw Exception('Failed to update weight');
    }
  }

  Future<void> deleteWeight(String id) async {
    final url = '$apiUrl/$id';
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode == 204) {
      _weights.removeWhere((w) => w.id == id);
      notifyListeners();
    } else {
      throw Exception('Failed to delete weight');
    }
  }
}
