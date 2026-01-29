import 'dart:convert';

// JSON String se Object banane ke liye helper function
ApiResponse apiResponseFromJson(String str) => ApiResponse.fromJson(json.decode(str));

// Object se JSON String banane ke liye helper function
String apiResponseToJson(ApiResponse data) => json.encode(data.toJson());

class ApiResponse {
  bool? success;
  List<EmployeeResult>? result;

  ApiResponse({
    this.success,
    this.result,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) => ApiResponse(
    success: json["success"],
    result: json["result"] == null
        ? []
        : List<EmployeeResult>.from(json["result"].map((x) => EmployeeResult.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": result == null
        ? []
        : List<dynamic>.from(result!.map((x) => x.toJson())),
  };
}

class EmployeeResult {
  int? id;
  int? employeeId;
  String? supervisorName; // Nullable handle kiya gaya hai
  String? docketNumber;
  String? productName;
  int? productId;
  String? assignDate;
  String? branchName;

  EmployeeResult({
    this.id,
    this.employeeId,
    this.supervisorName,
    this.docketNumber,
    this.productName,
    this.productId,
    this.assignDate,
    this.branchName,
  });

  factory EmployeeResult.fromJson(Map<String, dynamic> json) => EmployeeResult(
    id: json["id"],
    employeeId: json["employeeId"],
    supervisorName: json["supervisorName"], // API se null aane par bhi handle ho jayega
    docketNumber: json["docketNumber"],
    productName: json["productName"],
    productId: json["productId"],
    assignDate: json["assignDate"],
    branchName: json["branchName"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "employeeId": employeeId,
    "supervisorName": supervisorName,
    "docketNumber": docketNumber,
    "productName": productName,
    "productId": productId,
    "assignDate": assignDate,
    "branchName": branchName,
  };
}