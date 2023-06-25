class Weight {
  String? id;
  String _name;
  String _date;
  double _value;
  double _reps;

  Weight({
    this.id,
    required String name,
    required String date,
    required double value,
    required double reps,
  })  : _name = name,
        _date = date,
        _value = value,
        _reps = reps;

  factory Weight.fromJson(Map<String, dynamic> json) {
    return Weight(
      id: json['id'],
      name: json['name'],
      date: json['date'],
      value: json['value'].toDouble(),
      reps: json['reps'].toDouble(),
    );
  }

  String get name => _name;
  String get date => _date;
  double get value => _value;
  double get reps => _reps;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': _name,
      'date': _date,
      'value': _value,
      'reps': _reps,
    };
  }

  Weight withId(String id) {
    return Weight(
      id: id,
      name: this.name,
      date: this.date,
      value: this.value,
      reps: this.reps,
    );
  }
}
