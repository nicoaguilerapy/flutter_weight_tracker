import 'package:flutter/material.dart';
import 'package:gym_examen_final/screens/screens.dart';
import 'package:provider/provider.dart';
import 'package:gym_examen_final/providers/weight_form_provider.dart';

void main() {
  runApp(WeightTrackerApp());
}

class WeightTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WeightFormProvider()),
      ],
      child: MaterialApp(
        title: 'Weight Tracker',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomeScreen(),
      ),
    );
  }
}
