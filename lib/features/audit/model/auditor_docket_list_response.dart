import 'dart:convert';

AuditorDocketListResponse auditorDocketListResponseFromJson(String str) =>
    AuditorDocketListResponse.fromJson(json.decode(str));

String auditorDocketListResponseToJson(AuditorDocketListResponse data) =>
    json.encode(data.toJson());

class AuditorDocketListResponse {
  final bool success;
  final List<DocketAuditor> data;

  AuditorDocketListResponse({
    required this.success,
    required this.data,
  });

  factory AuditorDocketListResponse.fromJson(Map<String, dynamic> json) {
    return AuditorDocketListResponse(
      success: json['success'] as bool? ?? false,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => DocketAuditor.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'data': data.map((e) => e.toJson()).toList(),
  };
}


class DocketAuditor {
  int? id;
  String? docketNumber;
  String? productName;
  int? productId;
  String? assignDate;
  String? fullAssignDate;
  int? employeeId;
  String? auditStartDate;
  String? auditEndDate;
  String? branchName;

  DocketAuditor({
    this.id,
    this.docketNumber,
    this.productName,
    this.productId,
    this.assignDate,
    this.fullAssignDate,
    this.employeeId,
    this.auditStartDate,
    this.auditEndDate,
    this.branchName,
  });

  factory DocketAuditor.fromJson(Map<String, dynamic> json) {
    return DocketAuditor(
      id: json['id'] as int?,
      docketNumber: json['docketNumber'] as String?,
      productName: json['productName'] as String?,
      productId: json['productId'] as int?,
      assignDate: json['assignDate'] as String?,
      fullAssignDate: json['full_AssignDate'] as String?,
      employeeId: json['employeeId'] as int?,
      auditStartDate: json['auditStartDate'] as String?,
      auditEndDate: json['auditEndDate'] as String?,
      branchName: json['branchName'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'docketNumber': docketNumber,
    'productName': productName,
    'productId': productId,
    'assignDate': assignDate,
    'full_AssignDate': fullAssignDate,
    'employeeId': employeeId,
    'auditStartDate': auditStartDate,
    'auditEndDate': auditEndDate,
    'branchName': branchName,
  };
}
