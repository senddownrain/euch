import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/models/item.dart';
import '../../../core/services/firestore_service.dart';
import '../../../core/utils/html_utils.dart';

enum ImportMode { addOnly, overwrite }

final itemsRepositoryProvider = Provider<ItemsRepository>((ref) {
  return ItemsRepository(ref.watch(firestoreProvider));
});

class ItemsRepository {
  ItemsRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(AppConstants.itemsCollection);

  Stream<List<Item>> watchItems() {
    return _collection.snapshots().map(
          (snapshot) => snapshot.docs
              .map(Item.fromFirestore)
              .where((item) => !item.hidden)
              .toList(),
        );
  }

  Stream<Item?> watchItem(String id) {
    return _collection.doc(id).snapshots().map((doc) {
      if (!doc.exists) return null;
      return Item.fromFirestore(doc);
    });
  }

  Future<Item?> getItem(String id) async {
    final doc = await _collection.doc(id).get();
    if (!doc.exists) return null;
    return Item.fromFirestore(doc);
  }

  Future<void> saveItem(Item item) async {
    final doc = _collection.doc(item.id);
    final exists = (await doc.get()).exists;
    final payload = item.toFirestore();
    if (!exists && item.createdAt == null) {
      payload['createdAt'] = FieldValue.serverTimestamp();
    }
    await doc.set(payload, SetOptions(merge: true));
  }

  Future<void> deleteItem(String id) => _collection.doc(id).delete();

  Future<void> prefetchAll() async {
    await _collection.get(const GetOptions(source: Source.serverAndCache));
  }

  Future<File> exportToJson() async {
    final snapshot = await _collection.get();
    final data = snapshot.docs.map((doc) => Item.fromFirestore(doc).toExportJson()).toList();
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/items_export_${DateTime.now().millisecondsSinceEpoch}.json');
    await file.writeAsString(const JsonEncoder.withIndent('  ').convert(data));
    return file;
  }

  Future<List<Item>> parseImportFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['json'],
      withData: true,
    );

    if (result == null || result.files.isEmpty) {
      return const [];
    }

    final file = result.files.single;
    final content = file.bytes != null
        ? utf8.decode(file.bytes!)
        : await File(file.path!).readAsString();
    final decoded = jsonDecode(content);
    if (decoded is! List) {
      throw AppException('Invalid JSON: expected array');
    }

    return decoded
        .whereType<Map>()
        .map((entry) => Map<String, dynamic>.from(entry))
        .where((entry) => entry.containsKey('id'))
        .map((entry) => Item.fromMap({
              ...entry,
              'text': HtmlUtils.sanitize((entry['text'] ?? '').toString()),
            }))
        .toList();
  }

  Future<int> importItems(List<Item> items, ImportMode mode) async {
    if (items.isEmpty) return 0;

    final batch = _firestore.batch();
    int count = 0;

    for (final item in items) {
      final docRef = _collection.doc(item.id);
      if (mode == ImportMode.addOnly) {
        final exists = (await docRef.get()).exists;
        if (exists) continue;
      }
      batch.set(docRef, item.toFirestore(), SetOptions(merge: true));
      count++;
    }

    await batch.commit();
    return count;
  }
}
