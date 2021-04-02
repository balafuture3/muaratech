class LoginModel {
  int empID;
  String firstName;

  LoginModel({this.empID, this.firstName});

  LoginModel.fromJson(Map<String, dynamic> json) {
    empID = json['empID'];
    firstName = json['firstName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['empID'] = this.empID;
    data['firstName'] = this.firstName;
    return data;
  }
}