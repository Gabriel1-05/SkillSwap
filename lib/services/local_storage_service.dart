/// ============================================================
/// LOCAL STORAGE SERVICE — shared_preferences
/// ============================================================
/// Service ini menyediakan operasi CRUD generik menggunakan
/// shared_preferences. Setiap "collection" disimpan sebagai
/// sebuah JSON‑encoded String List di bawah key tertentu.
///
/// Lokasi kode:  lib/services/local_storage_service.dart
/// Teknologi  :  shared_preferences (Flutter)
/// ============================================================
library;

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Service generik untuk operasi CRUD pada local storage.
///
/// Data disimpan dalam shared_preferences sebagai `List<String>`,
/// di mana setiap elemen adalah JSON‑encoded Map dari satu record.
class LocalStorageService {
  LocalStorageService(this._prefs);

  final SharedPreferences _prefs;

  bool hasCollection(String key) => _prefs.containsKey(key);

  String? getString(String key) => _prefs.getString(key);

  Future<void> setString(String key, String value) async {
    final saved = await _prefs.setString(key, value);
    if (!saved) {
      throw StateError('Gagal menyimpan data "$key" ke local storage.');
    }
  }

  Future<void> remove(String key) async {
    final removed = await _prefs.remove(key);
    if (!removed) {
      throw StateError('Gagal menghapus data "$key" dari local storage.');
    }
  }

  // ---------------------
  //  CREATE  — tambah item baru ke collection
  // ---------------------
  /// Menambahkan satu record JSON ke collection [key].
  Future<void> addItem(String key, Map<String, dynamic> item) async {
    final list = List<String>.of(_prefs.getStringList(key) ?? []);
    list.add(jsonEncode(item));
    await _saveCollection(key, list);
  }

  // ---------------------
  //  READ  — baca seluruh collection
  // ---------------------
  /// Mengembalikan semua record dari collection [key].
  List<Map<String, dynamic>> getItems(String key) {
    final list = _prefs.getStringList(key) ?? [];
    return list
        .map((item) => jsonDecode(item) as Map<String, dynamic>)
        .toList();
  }

  // ---------------------
  //  UPDATE  — perbarui item berdasarkan index
  // ---------------------
  /// Mengganti record pada [index] di collection [key].
  Future<void> updateItem(
      String key, int index, Map<String, dynamic> item) async {
    final list = List<String>.of(_prefs.getStringList(key) ?? []);
    RangeError.checkValidIndex(index, list, 'index');
    list[index] = jsonEncode(item);
    await _saveCollection(key, list);
  }

  // ---------------------
  //  DELETE  — hapus item berdasarkan index
  // ---------------------
  /// Menghapus record pada [index] dari collection [key].
  Future<void> deleteItem(String key, int index) async {
    final list = List<String>.of(_prefs.getStringList(key) ?? []);
    RangeError.checkValidIndex(index, list, 'index');
    list.removeAt(index);
    await _saveCollection(key, list);
  }

  // ---------------------
  //  CLEAR  — hapus seluruh collection
  // ---------------------
  /// Menghapus seluruh data pada collection [key].
  Future<void> clearCollection(String key) async {
    await _prefs.remove(key);
  }

  // ---------------------
  //  COUNT  — jumlah item di collection
  // ---------------------
  /// Mengembalikan jumlah record dalam collection [key].
  int getCount(String key) {
    return (_prefs.getStringList(key) ?? []).length;
  }

  Future<void> _saveCollection(String key, List<String> items) async {
    final saved = await _prefs.setStringList(key, items);
    if (!saved) {
      throw StateError('Gagal menyimpan collection "$key" ke local storage.');
    }
  }
}
