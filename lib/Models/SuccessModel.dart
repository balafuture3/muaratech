class SuccessResponse {
  String sTATUS;
  String sTATUSMSG;

  SuccessResponse({this.sTATUS, this.sTATUSMSG});

  SuccessResponse.fromJson(Map<String, dynamic> json) {
    sTATUS = json['STATUS'];
    sTATUSMSG = json['STATUSMSG'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['STATUS'] = this.sTATUS;
    data['STATUSMSG'] = this.sTATUSMSG;
    return data;
  }
}