import 'dart:convert';

/// ---------- RESPONSE PARSER ----------
AuditorInProcessListResponse auditorInProcessListResponseFromJson(String str) =>
    AuditorInProcessListResponse.fromJson(json.decode(str));

String auditorInProcessListResponseToJson(
    AuditorInProcessListResponse data) =>
    json.encode(data.toJson());

/// ---------- RESPONSE MODEL ----------
class AuditorInProcessListResponse {
  final bool success;
  final List<InProcessItemAuditor> data;

  AuditorInProcessListResponse({
    required this.success,
    required this.data,
  });

  factory AuditorInProcessListResponse.fromJson(
      Map<String, dynamic> json) {
    return AuditorInProcessListResponse(
      success: json['success'] as bool? ?? false,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => InProcessItemAuditor.fromJson(
          e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'data': data.map((e) => e.toJson()).toList(),
  };
}

/// ---------- ITEM MODEL ----------

class InProcessItemAuditor {
  final int? id;
  final String? docketNumber;
  final String? productName;
  final int? productId;
  final String? assignDate;
  final int? employeeId;
  final String? branchName; // ✅ NEW FIELD

  InProcessItemAuditor({
    this.id,
    this.docketNumber,
    this.productName,
    this.productId,
    this.assignDate,
    this.employeeId,
    this.branchName,
  });

  factory InProcessItemAuditor.fromJson(Map<String, dynamic> json) {
    return InProcessItemAuditor(
      id: json['id'] as int?,
      docketNumber: json['docketNumber'] as String?,
      productName: json['productName'] as String?,
      productId: json['productId'] as int?,
      assignDate: json['assignDate'] as String?,
      employeeId: json['employeeId'] as int?,
      branchName: json['branchName'] as String?, // ✅ mapping
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'docketNumber': docketNumber,
    'productName': productName,
    'productId': productId,
    'assignDate': assignDate,
    'employeeId': employeeId,
    'branchName': branchName,
  };
}
