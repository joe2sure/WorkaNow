import 'package:equatable/equatable.dart';

class DepartmentModel extends Equatable {
  final String id;
  final String name;
  final String? description;
  final String companyId;
  final DateTime createdAt;
  final int staffCount;

  const DepartmentModel({
    required this.id,
    required this.name,
    this.description,
    required this.companyId,
    required this.createdAt,
    this.staffCount = 0,
  });

  DepartmentModel copyWith({int? staffCount}) {
    return DepartmentModel(
      id: id, name: name, description: description,
      companyId: companyId, createdAt: createdAt,
      staffCount: staffCount ?? this.staffCount,
    );
  }

  @override
  List<Object?> get props => [id];
}