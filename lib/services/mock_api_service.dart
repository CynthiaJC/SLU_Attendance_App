import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/attendance_models.dart';

class MockApiService {
  static final MockApiService _instance = MockApiService._internal();
  factory MockApiService() => _instance;
  MockApiService._internal();

  Map<String, dynamic>? _cache;

  Future<Map<String, dynamic>> _loadData() async {
    // Simulate network delay so loading states and skeletons are visible
    await Future.delayed(const Duration(milliseconds: 500));
    if (_cache != null) return _cache!;
    final String jsonString = await rootBundle.loadString('assets/sample_data.json');
    _cache = json.decode(jsonString) as Map<String, dynamic>;
    return _cache!;
  }

  /// Get summary stats
  Future<Map<String, dynamic>> getSummary() async {
    final data = await _loadData();
    return data['summary'] as Map<String, dynamic>;
  }

  /// Fetch all interns with optional filters
  Future<List<Intern>> getInterns({
    String? department,
    String? status,
    String? search,
  }) async {
    final data = await _loadData();
    final List<dynamic> rawList = data['interns'] ?? [];
    var list = rawList.map((item) => Intern.fromJson(item as Map<String, dynamic>)).toList();

    if (department != null && department.isNotEmpty && department != 'All') {
      list = list.where((i) => i.department.toLowerCase() == department.toLowerCase()).toList();
    }
    if (status != null && status.isNotEmpty && status != 'All') {
      list = list.where((i) => i.status.toLowerCase() == status.toLowerCase()).toList();
    }
    if (search != null && search.trim().isNotEmpty) {
      final query = search.trim().toLowerCase();
      list = list.where((i) =>
          i.name.toLowerCase().contains(query) ||
          i.studentId.toLowerCase().contains(query) ||
          i.email.toLowerCase().contains(query)).toList();
    }

    return list;
  }

  /// Fetch single intern by ID
  Future<Intern?> getInternById(String id) async {
    final list = await getInterns();
    try {
      return list.firstWhere((i) => i.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Fetch meetings with optional filters
  Future<List<Meeting>> getMeetings({
    String? type,
    String? department,
  }) async {
    final data = await _loadData();
    final List<dynamic> rawList = data['meetings'] ?? [];
    var list = rawList.map((item) => Meeting.fromJson(item as Map<String, dynamic>)).toList();

    if (type != null && type.isNotEmpty && type != 'All') {
      list = list.where((m) => m.type.toLowerCase() == type.toLowerCase()).toList();
    }
    if (department != null && department.isNotEmpty && department != 'All') {
      list = list.where((m) => m.department.toLowerCase() == department.toLowerCase() || m.department == 'All').toList();
    }

    return list;
  }

  /// Fetch attendance records with optional filters
  Future<List<AttendanceRecord>> getAttendanceRecords({
    String? internId,
    String? meetingId,
    String? status,
  }) async {
    final data = await _loadData();
    final List<dynamic> rawList = data['attendanceRecords'] ?? [];
    var list = rawList.map((item) => AttendanceRecord.fromJson(item as Map<String, dynamic>)).toList();

    if (internId != null && internId.isNotEmpty) {
      list = list.where((r) => r.internId == internId).toList();
    }
    if (meetingId != null && meetingId.isNotEmpty) {
      list = list.where((r) => r.meetingId == meetingId).toList();
    }
    if (status != null && status.isNotEmpty && status != 'All') {
      list = list.where((r) => r.status.toLowerCase() == status.toLowerCase()).toList();
    }

    return list;
  }

  /// Compute monthly attendance trend for a given intern.
  /// Returns a list of up to 6 recent months with their attendance rate (0.0–1.0).
  Future<List<({String month, double value})>> getMonthlyTrend(
      String internId) async {
    final records = await getAttendanceRecords(internId: internId);

    // Group records by "YYYY-MM"
    final Map<String, List<AttendanceRecord>> byMonth = {};
    for (final r in records) {
      // date format is "YYYY-MM-DD"
      if (r.date.length >= 7) {
        final key = r.date.substring(0, 7);
        byMonth.putIfAbsent(key, () => []).add(r);
      }
    }

    // Sort months ascending and take last 6
    final sortedKeys = byMonth.keys.toList()..sort();
    final recentKeys = sortedKeys.length > 6
        ? sortedKeys.sublist(sortedKeys.length - 6)
        : sortedKeys;

    const monthAbbr = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];

    return recentKeys.map((key) {
      final monthNum = int.tryParse(key.substring(5, 7)) ?? 0;
      final label = monthNum > 0 && monthNum < 13 ? monthAbbr[monthNum] : key;
      final monthRecords = byMonth[key]!;
      final presentCount =
          monthRecords.where((r) => r.status == 'Present').length;
      final rate = monthRecords.isEmpty
          ? 0.0
          : presentCount / monthRecords.length;
      return (month: label, value: rate.clamp(0.0, 1.0));
    }).toList();
  }

  /// Create a new check-in attendance record in memory
  Future<AttendanceRecord> addAttendanceRecord({
    required String internId,
    required String internName,
    required String meetingId,
    required String meetingTitle,
    required String status,
    required String checkInMethod,
    String notes = '',
  }) async {
    final data = await _loadData();
    final now = DateTime.now();
    final timeStr = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
    final dateStr = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    final newRecord = AttendanceRecord(
      id: 'ATT-${1000 + (data['attendanceRecords'] as List).length + 1}',
      internId: internId,
      internName: internName,
      meetingId: meetingId,
      meetingTitle: meetingTitle,
      date: dateStr,
      timeIn: timeStr,
      timeOut: '--:--',
      status: status,
      checkInMethod: checkInMethod,
      notes: notes,
    );

    (data['attendanceRecords'] as List).add(newRecord.toJson());
    return newRecord;
  }
}
