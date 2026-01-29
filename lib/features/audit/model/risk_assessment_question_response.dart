import 'dart:convert';

RiskAssessmentQuestionResponseNew riskAssessmentQuestionResponseFromJson(String str) =>
    RiskAssessmentQuestionResponseNew.fromJson(json.decode(str));

String riskAssessmentQuestionResponseToJson(RiskAssessmentQuestionResponseNew data) =>
    json.encode(data.toJson());

class RiskAssessmentQuestionResponseNew {
  bool success;
  List<RiskAssessmentQuestionNew> data;

  RiskAssessmentQuestionResponseNew({
    required this.success,
    required this.data,
  });

  factory RiskAssessmentQuestionResponseNew.fromJson(Map<String, dynamic> json) =>
      RiskAssessmentQuestionResponseNew(
        success: json["success"] ?? false,
        data: json["data"] == null
            ? []
            : List<RiskAssessmentQuestionNew>.from(
            json["data"].map((x) => RiskAssessmentQuestionNew.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class RiskAssessmentQuestionNew {
  int id;
  String productName;
  String riskAssessmentQuestion;
  double wightage;
  int sequence;
  String annexure;
  int annexureId;
  bool uploadFile;
  int headerQuestionId;
  String headerQuestion;
  int riskAssessmentQuestionId;
  int productId;
  int docketId;
  String? auditRisk;
  String? auditRating;
  String auditObservation;
  int indexNo;
  String? imagePath;

  RiskAssessmentQuestionNew({
    required this.id,
    required this.productName,
    required this.riskAssessmentQuestion,
    required this.wightage,
    required this.sequence,
    required this.annexure,
    required this.annexureId,
    required this.uploadFile,
    required this.headerQuestionId,
    required this.headerQuestion,
    required this.riskAssessmentQuestionId,
    required this.productId,
    required this.docketId,
    this.auditRisk,
    this.auditRating,
    required this.auditObservation,
    required this.indexNo,
    this.imagePath,
  });

  factory RiskAssessmentQuestionNew.fromJson(Map<String, dynamic> json) =>
      RiskAssessmentQuestionNew(
        id: json["id"] ?? 0,
        productName: json["productName"] ?? "",
        riskAssessmentQuestion: json["riskAssessmentQuestion"] ?? "",
        // Weightage double ho ya int, dono ko handle karne ke liye toDouble()
        wightage: (json["wightage"] != null) ? json["wightage"].toDouble() : 0.0,
        sequence: json["sequence"] ?? 0,
        annexure: json["annexure"] ?? "",
        annexureId: json["annexureId"] ?? 0,
        uploadFile: json["uploadFile"] ?? false,
        headerQuestionId: json["headerQuestionId"] ?? 0,
        headerQuestion: json["headerQuestion"] ?? "",
        riskAssessmentQuestionId: json["riskAssessmentQuestionId"] ?? 0,
        productId: json["productId"] ?? 0,
        docketId: json["docketId"] ?? 0,

        // 🔥 FIXED: API se int (18, 3) aa raha hai aur model String expect kar raha hai.
        // .toString() lagane se type mismatch error (int is not subtype of String) solve ho jayegi.
        auditRisk: json["auditRisk"]?.toString(),
        auditRating: json["auditRating"]?.toString(),

        auditObservation: json["auditObservation"]?.toString() ?? "",
        indexNo: json["indexNo"] ?? 0,
        imagePath: json["imagePath"] ?? "",
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "productName": productName,
    "riskAssessmentQuestion": riskAssessmentQuestion,
    "wightage": wightage,
    "sequence": sequence,
    "annexure": annexure,
    "annexureId": annexureId,
    "uploadFile": uploadFile,
    "headerQuestionId": headerQuestionId,
    "headerQuestion": headerQuestion,
    "riskAssessmentQuestionId": riskAssessmentQuestionId,
    "productId": productId,
    "docketId": docketId,
    "auditRisk": auditRisk,
    "auditRating": auditRating,
    "auditObservation": auditObservation,
    "indexNo": indexNo,
    "imagePath": imagePath,
  };
}