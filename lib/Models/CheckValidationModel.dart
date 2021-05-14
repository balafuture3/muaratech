class CheckValidationModel {
  String tYPECODE;
  String tYPENAME;
  String cUSCODE;
  String cUSNAME;
  String sTARTTRAVEL;
  String sTOPTRAVEL;
  String wORKSTART;
  String wORKEND;
  String tYPECODE1;
  String tYPENAME1;
  String cUSCODE1;
  String cUSNAME1;

  CheckValidationModel(
      {this.tYPECODE,
        this.tYPENAME,
        this.cUSCODE,
        this.cUSNAME,
        this.sTARTTRAVEL,
        this.sTOPTRAVEL,
        this.wORKSTART,
        this.wORKEND,
        this.tYPECODE1,
        this.tYPENAME1,
        this.cUSCODE1,
        this.cUSNAME1});

  CheckValidationModel.fromJson(Map<String, dynamic> json) {
    tYPECODE = json['TYPECODE'];
    tYPENAME = json['TYPENAME'];
    cUSCODE = json['CUSCODE'];
    cUSNAME = json['CUSNAME'];
    sTARTTRAVEL = json['STARTTRAVEL'];
    sTOPTRAVEL = json['STOPTRAVEL'];
    wORKSTART = json['WORKSTART'];
    wORKEND = json['WORKEND'];
    tYPECODE1 = json['TYPECODE1'];
    tYPENAME1 = json['TYPENAME1'];
    cUSCODE1 = json['CUSCODE1'];
    cUSNAME1 = json['CUSNAME1'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TYPECODE'] = this.tYPECODE;
    data['TYPENAME'] = this.tYPENAME;
    data['CUSCODE'] = this.cUSCODE;
    data['CUSNAME'] = this.cUSNAME;
    data['STARTTRAVEL'] = this.sTARTTRAVEL;
    data['STOPTRAVEL'] = this.sTOPTRAVEL;
    data['WORKSTART'] = this.wORKSTART;
    data['WORKEND'] = this.wORKEND;
    data['TYPECODE1'] = this.tYPECODE1;
    data['TYPENAME1'] = this.tYPENAME1;
    data['CUSCODE1'] = this.cUSCODE1;
    data['CUSNAME1'] = this.cUSNAME1;
    return data;
  }
}