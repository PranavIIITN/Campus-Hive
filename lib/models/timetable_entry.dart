class TimetableEntry {
  final String id;
  final String dayOfWeek;
  final String startTime;
  final String endTime;
  final String subject;
  final String room;

  TimetableEntry({
    required this.id,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.subject,
    required this.room,
  });
}
