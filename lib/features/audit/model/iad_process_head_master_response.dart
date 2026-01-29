import 'dart:convert';

IadProcessHeadMasterResponse iadProcessHeadMasterResponseFromJson(String str) => IadProcessHeadMasterResponse.fromJson(json.decode(str));

String iadProcessHeadMasterResponseToJson(IadProcessHeadMasterResponse data) => json.encode(data.toJson());

class IadProcessHeadMasterResponse {
    List<HeaderItem> result;

    IadProcessHeadMasterResponse({
        required this.result,
    });

    factory IadProcessHeadMasterResponse.fromJson(Map<String, dynamic> json) => IadProcessHeadMasterResponse(
        result: List<HeaderItem>.from(json["result"].map((x) => HeaderItem.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "result": List<dynamic>.from(result.map((x) => x.toJson())),
    };
}

class HeaderItem {
    int id;
    double productweightage;
    // int docketNumberId;
    String productName;
    String headerName;
    double wightage;
    int sequence;

    HeaderItem({
        required this.id,
        required this.productweightage,
        // required this.docketNumberId,
        required this.productName,
        required this.headerName,
        required this.wightage,
        required this.sequence,
    });

    factory HeaderItem.fromJson(Map<String, dynamic> json) => HeaderItem(
        id: json["id"],
        productweightage: json["productweightage"]?.toDouble(),
        // docketNumberId: json["docketNumberId"],
        productName: json["productName"],
        headerName: json["headerName"],
        wightage: json["wightage"]?.toDouble(),
        sequence: json["sequence"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "productweightage": productweightage,
        // "docketNumberId": docketNumberId,
        "productName": productName,
        "headerName": headerName,
        "wightage": wightage,
        "sequence": sequence,
    };
}
