import 'package:flutter/material.dart';
import 'package:gym_examen_final/models/weight_model.dart';
import 'package:gym_examen_final/services/weight_services.dart';
import 'package:gym_examen_final/widgets/widgets.dart';
import 'package:gym_examen_final/screens/screens.dart';

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
    fetchWeights();
  }

  Future<void> fetchWeights() async {
    try {
      await weightService.fetchWeights();
      setState(() {
        weights = weightService.weights;
      });
    } catch (e) {
      print('Error al obtener los pesos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weight Tracker'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              fetchWeights();
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: weights.length,
        itemBuilder: (context, index) {
          final weight = weights[index];
          return InkWell(
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WeightScreen(weight: weight),
                ),
              );
              if (result == true) {
                fetchWeights();
              }
            },
            child: CardWeight(weight: weight),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WeightScreen(weight: null),
            ),
          );
          if (result == true) {
            fetchWeights();
          }
        },
      ),
    );
  }
}
