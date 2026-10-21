/// A report filed by a user (concern, appointment, or medication issue).
///
/// Client-side shape matching the JSON the planned REST API will return.
class ReportEntry {
  const ReportEntry({
    required this.id,
    required this.reference,
    required this.title,
    required this.category,
    required this.details,
    required this.dateLabel,
  });

  final int id;
  final String reference;
  final String title;
  final String category;
  final String details;
  final String dateLabel;

  factory ReportEntry.fromJson(Map<String, dynamic> json) => ReportEntry(
    id: json['id'] as int,
    reference: json['reference'] as String? ?? '',
    title: json['title'] as String? ?? '',
    category: json['category'] as String? ?? '',
    details: json['details'] as String? ?? '',
    dateLabel: json['date'] as String? ?? '',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'reference': reference,
    'title': title,
    'category': category,
    'details': details,
    'date': dateLabel,
  };
}
