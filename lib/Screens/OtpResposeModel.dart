class ResponseModel {
  int status;
  String message;
  String oTP;

  ResponseModel({this.status, this.message, this.oTP});

  ResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    oTP = json['OTP'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['OTP'] = this.oTP;
    return data;
  }
}