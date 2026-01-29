// block_audit_response.dart (or equivalent file)

class BlockAuditDetail {
  final int id;
  final String docketNumber;
  final String branchName;
  final String auditorName;
  final String auditStartDate;
  final String auditEndDate;
  final String auditStartMonth;
  final int auditStartYear;
  final String employeeEmailId;

  BlockAuditDetail({
    required this.id,
    required this.docketNumber,
    required this.branchName,
    required this.auditorName,
    required this.auditStartDate,
    required this.auditEndDate,
    required this.auditStartMonth,
    required this.auditStartYear,
    required this.employeeEmailId,
  });

  factory BlockAuditDetail.fromJson(Map<String, dynamic> json) => BlockAuditDetail(
    id: json["id"],
    docketNumber: json["docketNumber"] ?? 'N/A',
    branchName: json["branchName"] ?? 'N/A',
    auditorName: json["auditorName"] ?? 'N/A',
    auditStartDate: json["auditStartDate"] ?? 'N/A',
    auditEndDate: json["auditEndDate"] ?? 'N/A',
    auditStartMonth: json["auditStartMonth"] ?? 'N/A',
    auditStartYear: json["auditStartYear"] ?? 0,
    employeeEmailId: json["employeeEmailId"] ?? 'N/A',
  );
}