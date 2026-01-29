import 'dart:convert';

InProcessListResponse inProcessListResponseFromJson(String str) =>
    InProcessListResponse.fromJson(json.decode(str));

String inProcessListResponseToJson(InProcessListResponse data) =>
    json.encode(data.toJson());

class InProcessListResponse {
    final bool success;
    final List<InProcessItem> data;

    InProcessListResponse({
        required this.success,
        required this.data,
    });

    factory InProcessListResponse.fromJson(Map<String, dynamic> json) {
        return InProcessListResponse(
            success: json['success'] as bool? ?? false,
            data: (json['data'] as List<dynamic>?)
                ?.map((e) => InProcessItem.fromJson(e as Map<String, dynamic>))
                .toList() ??
                [],
        );
    }

    Map<String, dynamic> toJson() => {
        'success': success,
        'data': data.map((e) => e.toJson()).toList(),
    };
}


class InProcessItem {
    final int? id;
    final String? docketNumber;
    final String? productName;
    final int? productId;
    final String? assignDate; // already "January"
    final int? employeeId;
    // final String? branchName;

    InProcessItem({
        this.id,
        this.docketNumber,
        this.productName,
        this.productId,
        this.assignDate,
        this.employeeId,
        // this.branchName,
    });

    factory InProcessItem.fromJson(Map<String, dynamic> json) {
        return InProcessItem(
            id: json['id'] as int?,
            docketNumber: json['docketNumber'] as String?,
            productName: json['productName'] as String?,
            productId: json['productId'] as int?,
            assignDate: json['assignDate'] as String?,
            employeeId: json['employeeId'] as int?,
            // branchName: json['branchName'] as String?,
        );
    }

    Map<String, dynamic> toJson() => {
        'id': id,
        'docketNumber': docketNumber,
        'productName': productName,
        'productId': productId,
        'assignDate': assignDate,
        'employeeId': employeeId,
        // 'branchName': branchName,
    };
}
