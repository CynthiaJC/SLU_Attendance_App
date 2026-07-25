class Intern {
  final String id;
  final String studentId;
  final String name;
  final String email;
  final String phone;
  final String avatarInitials;
  final String department;
  final String role;
  final String supervisor;
  final String status;
  final String dateJoined;
  final int totalSessions;
  final int presentCount;
  final int absentCount;
  final int lateCount;
  final double participationRate;

  const Intern({
    required this.id,
    required this.studentId,
    required this.name,
    required this.email,
    required this.phone,
    required this.avatarInitials,
    required this.department,
    required this.role,
    required this.supervisor,
    required this.status,
    required this.dateJoined,
    required this.totalSessions,
    required this.presentCount,
    required this.absentCount,
    required this.lateCount,
    required this.participationRate,
  });

  factory Intern.fromJson(Map<String, dynamic> json) {
    return Intern(
      id: json['id'] ?? '',
      studentId: json['studentId'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      avatarInitials: json['avatarInitials'] ?? '',
      department: json['department'] ?? '',
      role: json['role'] ?? '',
      supervisor: json['supervisor'] ?? '',
      status: json['status'] ?? 'onTrack',
      dateJoined: json['dateJoined'] ?? '',
      totalSessions: json['totalSessions'] ?? 0,
      presentCount: json['presentCount'] ?? 0,
      absentCount: json['absentCount'] ?? 0,
      lateCount: json['lateCount'] ?? 0,
      participationRate: (json['participationRate'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'studentId': studentId,
        'name': name,
        'email': email,
        'phone': phone,
        'avatarInitials': avatarInitials,
        'department': department,
        'role': role,
        'supervisor': supervisor,
        'status': status,
        'dateJoined': dateJoined,
        'totalSessions': totalSessions,
        'presentCount': presentCount,
        'absentCount': absentCount,
        'lateCount': lateCount,
        'participationRate': participationRate,
      };
}

class Meeting {
  final String id;
  final String title;
  final String type;
  final String department;
  final String coordinator;
  final String coordinatorEmail;
  final String date;
  final String startTime;
  final String endTime;
  final String location;
  final String status;
  final int totalInvited;
  final int presentCount;
  final int absentCount;
  final int lateCount;
  final String description;

  const Meeting({
    required this.id,
    required this.title,
    required this.type,
    required this.department,
    required this.coordinator,
    required this.coordinatorEmail,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.status,
    required this.totalInvited,
    required this.presentCount,
    required this.absentCount,
    required this.lateCount,
    required this.description,
  });

  factory Meeting.fromJson(Map<String, dynamic> json) {
    return Meeting(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      type: json['type'] ?? 'General',
      department: json['department'] ?? 'All',
      coordinator: json['coordinator'] ?? '',
      coordinatorEmail: json['coordinatorEmail'] ?? '',
      date: json['date'] ?? '',
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      location: json['location'] ?? '',
      status: json['status'] ?? 'Scheduled',
      totalInvited: json['totalInvited'] ?? 0,
      presentCount: json['presentCount'] ?? 0,
      absentCount: json['absentCount'] ?? 0,
      lateCount: json['lateCount'] ?? 0,
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'type': type,
        'department': department,
        'coordinator': coordinator,
        'coordinatorEmail': coordinatorEmail,
        'date': date,
        'startTime': startTime,
        'endTime': endTime,
        'location': location,
        'status': status,
        'totalInvited': totalInvited,
        'presentCount': presentCount,
        'absentCount': absentCount,
        'lateCount': lateCount,
        'description': description,
      };
}

class AttendanceRecord {
  final String id;
  final String internId;
  final String internName;
  final String meetingId;
  final String meetingTitle;
  final String date;
  final String timeIn;
  final String timeOut;
  final String status;
  final String checkInMethod;
  final String notes;

  const AttendanceRecord({
    required this.id,
    required this.internId,
    required this.internName,
    required this.meetingId,
    required this.meetingTitle,
    required this.date,
    required this.timeIn,
    required this.timeOut,
    required this.status,
    required this.checkInMethod,
    required this.notes,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      id: json['id'] ?? '',
      internId: json['internId'] ?? '',
      internName: json['internName'] ?? '',
      meetingId: json['meetingId'] ?? '',
      meetingTitle: json['meetingTitle'] ?? '',
      date: json['date'] ?? '',
      timeIn: json['timeIn'] ?? '',
      timeOut: json['timeOut'] ?? '',
      status: json['status'] ?? 'Present',
      checkInMethod: json['checkInMethod'] ?? 'QR Code',
      notes: json['notes'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'internId': internId,
        'internName': internName,
        'meetingId': meetingId,
        'meetingTitle': meetingTitle,
        'date': date,
        'timeIn': timeIn,
        'timeOut': timeOut,
        'status': status,
        'checkInMethod': checkInMethod,
        'notes': notes,
      };
}
