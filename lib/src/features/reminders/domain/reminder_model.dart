class Reminder {
  final String id;
  final int intId;
  final String title;
  final DateTime remindAt;
  final bool isActive;

  const Reminder({
    required this.id,
    required this.intId,
    required this.title,
    required this.remindAt,
    this.isActive = true,
  });

  Reminder copyWith({
    String? id,
    int? intId,
    String? title,
    DateTime? remindAt,
    bool? isActive,
  }) {
    return Reminder(
      id: id ?? this.id,
      intId: intId ?? this.intId,
      title: title ?? this.title,
      remindAt: remindAt ?? this.remindAt,
      isActive: isActive ?? this.isActive,
    );
  }
}
