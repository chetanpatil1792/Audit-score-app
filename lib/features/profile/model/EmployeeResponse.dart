class AuditorResponse {
  final AuditorProfile? auditor;

  AuditorResponse({this.auditor});

  factory AuditorResponse.fromJson(Map<String, dynamic> json) {
    return AuditorResponse(
      auditor: json['result'] != null
          ? AuditorProfile.fromJson(json['result'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'result': auditor?.toJson(),
    };
  }
}

class AuditorProfile {
  final int? id;
  final String? empCode;
  final String? title;
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? gender;
  final String? dob;
  final String? mobile;
  final String? email;
  final String? address1;
  final String? address2;
  final String? pincode;
  final String? altMobile;
  final String? altEmail;
  final String? country;
  final String? state;
  final String? district;
  final String? taluka;
  final String? village;
  final String? branch;
  final String? department;
  final String? manager1;
  final String? manager2;
  final String? role;
  final int? additionalRole;
  final String? designation;
  final String? grade;
  final int? creatorId;
  final String? createdAt;
  final bool? deleted;
  final int? deletedBy;
  final String? deletedAt;
  final int? updatedBy;
  final String? updatedAt;
  final String? company;
  final int? centerId;
  String? profileImage;

  AuditorProfile({
    this.id,
    this.empCode,
    this.title,
    this.firstName,
    this.middleName,
    this.lastName,
    this.gender,
    this.dob,
    this.mobile,
    this.email,
    this.address1,
    this.address2,
    this.pincode,
    this.altMobile,
    this.altEmail,
    this.country,
    this.state,
    this.district,
    this.taluka,
    this.village,
    this.branch,
    this.department,
    this.manager1,
    this.manager2,
    this.role,
    this.additionalRole,
    this.designation,
    this.grade,
    this.creatorId,
    this.createdAt,
    this.deleted,
    this.deletedBy,
    this.deletedAt,
    this.updatedBy,
    this.updatedAt,
    this.company,
    this.centerId,
    this.profileImage,
  });

  factory AuditorProfile.fromJson(Map<String, dynamic> json) {
    return AuditorProfile(
      id: json['id'],
      empCode: json['employeeID'],
      title: json['employeeTitle'],
      firstName: json['employeeFirstName'],
      middleName: json['employeeMiddleName'],
      lastName: json['employeeLastName'],
      gender: json['employeeGender'],
      dob: json['employeeDOB'],
      mobile: json['employeeMobileNo'],
      email: json['employeeEmailId'],
      address1: json['employeeAddressLine_1'],
      address2: json['employeeAddressLine_2'],
      pincode: json['employeePincode'],
      altMobile: json['employeeAlternateMobileNo'],
      altEmail: json['employeeAlternateEmailId'],
      country: json['countryName'],
      state: json['stateName'],
      district: json['districtName'],
      taluka: json['talukaName'],
      village: json['villageName'],
      branch: json['branchName'],
      department: json['departmentName'],
      manager1: json['reportingManager_1'],
      manager2: json['reportingManager_2'],
      role: json['roleName'],
      additionalRole: json['employeeAdditionalRole'],
      designation: json['designationName'],
      grade: json['gradeCode'],
      creatorId: json['createdBy'],
      createdAt: json['createdOn'],
      deleted: json['isDeleted'],
      deletedBy: json['isDeletedBY'],
      deletedAt: json['isDeletedOn'],
      updatedBy: json['isUpdatedBy'],
      updatedAt: json['isUpdatedOn'],
      company: json['companyName'],
      centerId: json['centerId'],
      profileImage: json['profileImageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employeeID': empCode,
      'employeeTitle': title,
      'employeeFirstName': firstName,
      'employeeMiddleName': middleName,
      'employeeLastName': lastName,
      'employeeGender': gender,
      'employeeDOB': dob,
      'employeeMobileNo': mobile,
      'employeeEmailId': email,
      'employeeAddressLine_1': address1,
      'employeeAddressLine_2': address2,
      'employeePincode': pincode,
      'employeeAlternateMobileNo': altMobile,
      'employeeAlternateEmailId': altEmail,
      'countryName': country,
      'stateName': state,
      'districtName': district,
      'talukaName': taluka,
      'villageName': village,
      'branchName': branch,
      'departmentName': department,
      'reportingManager_1': manager1,
      'reportingManager_2': manager2,
      'roleName': role,
      'employeeAdditionalRole': additionalRole,
      'designationName': designation,
      'gradeCode': grade,
      'createdBy': creatorId,
      'createdOn': createdAt,
      'isDeleted': deleted,
      'isDeletedBY': deletedBy,
      'isDeletedOn': deletedAt,
      'isUpdatedBy': updatedBy,
      'isUpdatedOn': updatedAt,
      'companyName': company,
      'centerId': centerId,
      'profileImageUrl': profileImage
    };
  }
}