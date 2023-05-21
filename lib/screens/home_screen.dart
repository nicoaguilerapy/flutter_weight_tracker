import 'package:flutter/material.dart';
import 'package:gym_examen_final/models/weight_model.dart';
import 'package:gym_examen_final/services/weight_services.dart';
import 'package:gym_examen_final/widgets/card_weight.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeightService weightService = WeightService();
  List<Weight> weights = [];

  @override
  void initState() {
    super.initState();
    weightService.fetchWeights().then((_) {
      setState(() {
        // Actualiza el estado de la lista de pesos
        weights = weightService.weights;
      });
    }).catchError((error) {
      // Maneja cualquier error que ocurra durante la obtención de los datos
      print('Error fetching weights: $error');
    });
  }

  Future<void> fetchWeights() async {
    try {
      await weightService.fetchWeights();
      setState(() {
        // No asignar fetchedWeights ya que fetchWeights() es de tipo Future<void>
      });
    } catch (e) {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weight Tracker'),
      ),
      body: ListView.builder(
        itemCount: weights.length,
        itemBuilder: (context, index) {
          final weight = weights[index];
          return CardWeight(weight: weight);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // Navegar a la pantalla de agregar peso
        },
      ),
    );
  }
}
