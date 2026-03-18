import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  const Item({
    required this.id,
    required this.title,
    required this.text,
    required this.tags,
    this.createdAt,
    this.updatedAt,
    this.hidden = false,
    this.language,
    this.relatedIds = const [],
    this.isNovena = false,
    this.recommendedDate,
    this.metadata = const {},
  });

  final String id;
  final String title;
  final String text;
  final List<String> tags;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool hidden;
  final String? language;
  final List<String> relatedIds;
  final bool isNovena;
  final DateTime? recommendedDate;
  final Map<String, dynamic> metadata;

  factory Item.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    return Item.fromMap(data, fallbackId: doc.id);
  }

  factory Item.fromMap(Map<String, dynamic> map, {String? fallbackId}) {
    DateTime? parseDate(dynamic value) {
      if (value == null) return null;
      if (value is Timestamp) return value.toDate();
      if (value is DateTime) return value;
      if (value is String && value.isNotEmpty) return DateTime.tryParse(value);
      return null;
    }

    return Item(
      id: (map['id'] ?? fallbackId ?? '').toString(),
      title: (map['title'] ?? '').toString(),
      text: (map['text'] ?? '').toString(),
      tags: (map['tags'] as List<dynamic>? ?? const [])
          .map((tag) => tag.toString().trim())
          .where((tag) => tag.isNotEmpty)
          .toSet()
          .toList(),
      createdAt: parseDate(map['createdAt']),
      updatedAt: parseDate(map['updatedAt']),
      hidden: map['hidden'] == true,
      language: map['language']?.toString(),
      relatedIds: (map['translations'] as List<dynamic>? ??
              map['relatedIds'] as List<dynamic>? ??
              const [])
          .map((id) => id.toString())
          .toList(),
      isNovena: map['isNovena'] == true,
      recommendedDate: parseDate(map['recommendedDate']),
      metadata: Map<String, dynamic>.from(map['metadata'] as Map? ?? const {}),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'title': title,
      'text': text,
      'tags': tags,
      'createdAt': createdAt == null ? FieldValue.serverTimestamp() : Timestamp.fromDate(createdAt!),
      'updatedAt': FieldValue.serverTimestamp(),
      'hidden': hidden,
      'language': language,
      'translations': relatedIds,
      'isNovena': isNovena,
      'recommendedDate': recommendedDate == null ? null : Timestamp.fromDate(recommendedDate!),
      'metadata': metadata,
    };
  }

  Map<String, dynamic> toExportJson() {
    return {
      'id': id,
      'title': title,
      'text': text,
      'tags': tags,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'hidden': hidden,
      'language': language,
      'translations': relatedIds,
      'isNovena': isNovena,
      'recommendedDate': recommendedDate?.toIso8601String(),
      'metadata': metadata,
    };
  }

  Item copyWith({
    String? id,
    String? title,
    String? text,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? hidden,
    String? language,
    List<String>? relatedIds,
    bool? isNovena,
    DateTime? recommendedDate,
    Map<String, dynamic>? metadata,
  }) {
    return Item(
      id: id ?? this.id,
      title: title ?? this.title,
      text: text ?? this.text,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      hidden: hidden ?? this.hidden,
      language: language ?? this.language,
      relatedIds: relatedIds ?? this.relatedIds,
      isNovena: isNovena ?? this.isNovena,
      recommendedDate: recommendedDate ?? this.recommendedDate,
      metadata: metadata ?? this.metadata,
    );
  }
}
