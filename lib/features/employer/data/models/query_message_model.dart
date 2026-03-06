import 'package:equatable/equatable.dart';

enum QueryType { lateArrival, unauthorizedAbsence, earlyDeparture, other }
enum QueryStatus { sent, read, responded }

class QueryMessage extends Equatable {
  final String id;
  final String staffId;
  final String staffName;
  final String employerId;
  final QueryType type;
  final String subject;
  final String body;
  final DateTime sentAt;
  final QueryStatus status;
  final String? staffResponse;
  final DateTime? respondedAt;
  final DateTime? relatedDate;

  const QueryMessage({
    required this.id,
    required this.staffId,
    required this.staffName,
    required this.employerId,
    required this.type,
    required this.subject,
    required this.body,
    required this.sentAt,
    required this.status,
    this.staffResponse,
    this.respondedAt,
    this.relatedDate,
  });

  String get typeLabel => switch (type) {
    QueryType.lateArrival        => 'Late Arrival',
    QueryType.unauthorizedAbsence=> 'Unauthorized Absence',
    QueryType.earlyDeparture     => 'Early Departure',
    QueryType.other              => 'Query',
  };

  QueryMessage copyWith({
    QueryStatus? status,
    String? staffResponse,
    DateTime? respondedAt,
  }) {
    return QueryMessage(
      id: id, staffId: staffId, staffName: staffName,
      employerId: employerId, type: type, subject: subject,
      body: body, sentAt: sentAt,
      status: status ?? this.status,
      staffResponse: staffResponse ?? this.staffResponse,
      respondedAt: respondedAt ?? this.respondedAt,
      relatedDate: relatedDate,
    );
  }

  @override
  List<Object?> get props => [id];
}