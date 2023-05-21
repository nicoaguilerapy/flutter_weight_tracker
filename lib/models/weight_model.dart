class Weight {
  final String? id;
  final String name;
  final String date;
  final double value;
  final double reps;

  Weight({
    this.id,
    required this.name,
    required this.date,
    required this.value,
    required this.reps,
  });

  factory Weight.fromJson(Map<String, dynamic> json) {
    return Weight(
      id: json['id'],
      name: json['name'],
      date: json['date'],
      value: json['value'].toDouble(),
      reps: json['reps'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'date': date,
      'value': value,
      'reps': reps,
    };
  }
}
