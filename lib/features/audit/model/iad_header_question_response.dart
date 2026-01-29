import 'dart:convert';

IadHeaderQuestionResponse iadHeaderQuestionResponseFromJson(String str) => IadHeaderQuestionResponse.fromJson(json.decode(str));

String iadHeaderQuestionResponseToJson(IadHeaderQuestionResponse data) => json.encode(data.toJson());

class IadHeaderQuestionResponse {
    List<QuestionItem> result;

    IadHeaderQuestionResponse({
        required this.result,
    });

    factory IadHeaderQuestionResponse.fromJson(Map<String, dynamic> json) => IadHeaderQuestionResponse(
        result: List<QuestionItem>.from(json["result"].map((x) => QuestionItem.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "result": List<dynamic>.from(result.map((x) => x.toJson())),
    };
}

class QuestionItem {
    int id;
    String headerName;
    String headerQuestion;
    double wightage;
    int sequence;
    int annexureId;
    int isQuestionary;

    String? postapi;
    String? getapi;
    String? parameters;

    QuestionItem({
        required this.id,
        required this.headerName,
        required this.headerQuestion,
        required this.wightage,
        required this.sequence,
        required this.annexureId,
        required this.isQuestionary,

        this.postapi,
        this.getapi,
        this.parameters,
    });

    factory QuestionItem.fromJson(Map<String, dynamic> json) => QuestionItem(
        id: json["id"],
        headerName: json["headerName"],
        headerQuestion: json["headerQuestion"],
        wightage: json["wightage"]?.toDouble(),
        sequence: json["sequence"],
        annexureId: json["annexureId"],
        isQuestionary: json["isQuestionary"],

        // NEW OPTIONAL FIELDS
        postapi: json["postapi"],
        getapi: json["getapi"],
        parameters: json["parameters"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "headerName": headerName,
        "headerQuestion": headerQuestion,
        "wightage": wightage,
        "sequence": sequence,
        "annexureId": annexureId,
        "isQuestionary": isQuestionary,

        "postapi": postapi,
        "getapi": getapi,
        "parameters": parameters,
    };
}
