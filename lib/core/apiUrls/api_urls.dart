/// API URLs configuration file for Flutter app

class ApiUrls {
  /// 🔹 Base URL
  // static const String baseUrl = "https://android.auditscore.in/api/";
  static const String baseUrl = "https://uat.auditscore.in/api/";
  static const String baseUrl2 = "https://uat.auditscore.in";
  // static const String baseUrl = "https://sakshamgram.auditscore.in/api/";
  // static const String baseUrl2 = "https://sakshamgram.auditscore.in";

  /// 🔹 Auth Endpoints
  static const String login = "${baseUrl}LoginAPI/submitLogin";

  /// 🔹 functions Endpoints
  static const String refreshToken = "${baseUrl}LoginAPI/refresh-token";

  static const String getBranchList = "${baseUrl}AuditAPI/GetBranchMasterNameListDetails";
  static const String docketAuditorList = "${baseUrl}AuditAPI/GetDocketAuditorList";
  static const String inProcessList = "${baseUrl}AuditAPI/GetInprocessAuditList";
  static const String changesList = "${baseUrl}AuditAPI/GetChangeBySupervisorAuditList";
  static const String rescheduleAudit = "${baseUrl}AuditAPI/RescheduleAudit";
  static const String cancelAudit = "${baseUrl}AuditAPI/CancelAudit";
  static const String startAudit = "${baseUrl}AuditApi/StartAudit";
  static const String inProcessListForAuditor = "${baseUrl}AuditAPI/GetInprocessAuditListForAuditor";
  static const String getRiskAssessmentQuestionMasterDetails = "${baseUrl}AuditAPI/GetQuestionListTrackByProdandDoc";
  static const String getRatingMaster = "${baseUrl}AuditAPI/GetRatingList";
  static const String getRiskLevelList = "${baseUrl}AuditAPI/GetRiskLevelList";
  static const String SaveAudit = "${baseUrl}AuditAPI/CurudOpertaionAuditMasterDetails";
  static const String getAnnexureHeaders = "${baseUrl}AuditAPI/GetAnnexureHeaders";
  static const String annexureSave = "${baseUrl}AuditAPI/SaveDynamicAnnexure";

  static const String getCapturedImages = "${baseUrl}AuditAPI/GetCapturedImagesPerQuestion";
  static const String saveAuditImages = "${baseUrl}AuditAPI/SaveImages";
  static const String deleteCapturedImage = "${baseUrl}AuditAPI/DeleteCapturedImage";
  static const String getUserData = "${baseUrl}AuditAPI/";
  static const String getTotalAuditDetails = "${baseUrl}AuditAPI/GetTotalAuditDetails";

}
