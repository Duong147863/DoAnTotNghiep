class WorkHours {
  final String dayOfWeek;
  final DateTime date;
  final int hoursWorked;

  WorkHours({
    required this.dayOfWeek,
    required this.date,
    required this.hoursWorked,
  });

  factory WorkHours.fromJson(Map<String, dynamic> json) {
    return WorkHours(
      dayOfWeek: json['day_of_week'],
      date: DateTime.parse(json['date']),
      hoursWorked: json['hours_worked'],
    );
  }
}
