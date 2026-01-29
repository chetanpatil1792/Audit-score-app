class BranchItem {
  final int id;
  final int branchId;
  final String branchName;

  BranchItem({
    required this.id,
    required this.branchId,
    required this.branchName,
  });

  factory BranchItem.fromJson(Map<String, dynamic> json) {
    return BranchItem(
      id: json['id'] as int,
      branchId: json['branchId'] as int,
      branchName: json['branchName'] as String,
    );
  }

  // Optional: If you need to convert Dart object back to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'branchId': branchId,
      'branchName': branchName,
    };
  }
}


class MasterBranchResponse {
  final List<BranchItem> result;

  MasterBranchResponse({required this.result});

  factory MasterBranchResponse.fromJson(Map<String, dynamic> json) {
    // 'result' key से List<dynamic> निकालें
    final List<dynamic> resultList = json['result'] ?? [];

    // हर dynamic मैप को BranchItem.fromJson() का उपयोग करके Parse करें
    final List<BranchItem> branchItems = resultList
        .map((itemJson) => BranchItem.fromJson(itemJson as Map<String, dynamic>))
        .toList();

    return MasterBranchResponse(
      result: branchItems,
    );
  }

  // Optional: If you need to convert Dart object back to JSON
  Map<String, dynamic> toJson() {
    return {
      'result': result.map((item) => item.toJson()).toList(),
    };
  }
}