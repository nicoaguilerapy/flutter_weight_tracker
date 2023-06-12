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
    weightService.fetchWeights().then((_) {
      setState(() {
        weights = weightService.weights;
      });
    }).catchError((error) {
      print('Error al obtener los pesos');
    });
  }

  Future<void> fetchWeights() async {
    try {
      await weightService.fetchWeights();
      setState(() {});
    } catch (e) {
      print('Error al obtener los pesos');
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
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WeightScreen(weight: weight),
                ),
              );
            },
            child: CardWeight(weight: weight),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WeightScreen(weight: null),
            ),
          );
        },
      ),
    );
  }
}
