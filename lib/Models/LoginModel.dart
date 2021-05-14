class LoginModel {
  int empID;
  String firstName;
  String uMobWhs;
  String uMobHD;
  String homLoc;

  LoginModel(
      {this.empID, this.firstName, this.uMobWhs, this.uMobHD, this.homLoc});

  LoginModel.fromJson(Map<String, dynamic> json) {
    empID = json['empID'];
    firstName = json['firstName'];
    uMobWhs = json['U_MobWhs'];
    uMobHD = json['U_MobHD'];
    homLoc = json['HomLoc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['empID'] = this.empID;
    data['firstName'] = this.firstName;
    data['U_MobWhs'] = this.uMobWhs;
    data['U_MobHD'] = this.uMobHD;
    data['HomLoc'] = this.homLoc;
    return data;
  }
}