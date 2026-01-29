class BranchResponse {
  final bool success;
  final List<Branch> data;

  BranchResponse({
    required this.success,
    required this.data,
  });

  factory BranchResponse.fromJson(Map<String, dynamic> json) {
    return BranchResponse(
      success: json['success'] as bool? ?? false,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Branch.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'data': data.map((e) => e.toJson()).toList(),
  };
}

class Branch {
  final int? id;
  final int? branchId;
  final String? branchName;

  Branch({this.id,this.branchId, this.branchName});

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      id: json['id'] as int?,
      branchId: json['branchId'] as int?,
      branchName: json['branchName'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'branchId': branchId,
        'branchName': branchName,
      };
}
