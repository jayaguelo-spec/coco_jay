/// Client-side shape of a prenatal record (appointment or check-up).
///
/// Matches the JSON the planned REST API will return; no network call exists
/// yet.
class HealthRecord {
  const HealthRecord({
    required this.id,
    required this.title,
    required this.date,
    required this.note,
  });

  final int id;
  final String title;
  final String date;
  final String note;

  factory HealthRecord.fromJson(Map<String, dynamic> json) => HealthRecord(
    id: json['id'] as int,
    title: json['title'] as String? ?? '',
    date: json['date'] as String? ?? '',
    note: json['note'] as String? ?? '',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'date': date,
    'note': note,
  };
}
