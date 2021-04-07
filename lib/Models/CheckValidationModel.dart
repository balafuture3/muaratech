class CheckValidationModel {
  int cREATEDBY;
  int dOCNO;
  String tSTARTLATLANG;
  String tENDLATLANG;
  String wSTARTLATLANG;
  String wENDLATLANG;
  String tRAVELTYPE;
  String cUSTOMERCODE;
  String cUSTOMERNAME;
  String tRAVELSTART;
  String tRAVELEND;
  String wSTARTCUSPLACE;
  String wENDCUSPLACE;
  String wORKSTARTCUSCODE;
  String wORKSTARTCUSNAME;
  String wSTARTTYPE;

  CheckValidationModel(
      {this.cREATEDBY,
        this.dOCNO,
        this.tSTARTLATLANG,
        this.tENDLATLANG,
        this.wSTARTLATLANG,
        this.wENDLATLANG,
        this.tRAVELTYPE,
        this.cUSTOMERCODE,
        this.cUSTOMERNAME,
        this.tRAVELSTART,
        this.tRAVELEND,
        this.wSTARTCUSPLACE,
        this.wENDCUSPLACE,
        this.wORKSTARTCUSCODE,
        this.wORKSTARTCUSNAME,
        this.wSTARTTYPE});

  CheckValidationModel.fromJson(Map<String, dynamic> json) {
    cREATEDBY = json['CREATEDBY'];
    dOCNO = json['DOCNO'];
    tSTARTLATLANG = json['TSTARTLATLANG'];
    tENDLATLANG = json['TENDLATLANG'];
    wSTARTLATLANG = json['WSTARTLATLANG'];
    wENDLATLANG = json['WENDLATLANG'];
    tRAVELTYPE = json['TRAVELTYPE'];
    cUSTOMERCODE = json['CUSTOMERCODE'];
    cUSTOMERNAME = json['CUSTOMERNAME'];
    tRAVELSTART = json['TRAVELSTART'];
    tRAVELEND = json['TRAVELEND'];
    wSTARTCUSPLACE = json['W_STARTCUSPLACE'];
    wENDCUSPLACE = json['W_ENDCUSPLACE'];
    wORKSTARTCUSCODE = json['WORKSTARTCUSCODE'];
    wORKSTARTCUSNAME = json['WORKSTARTCUSNAME'];
    wSTARTTYPE = json['WSTARTTYPE'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CREATEDBY'] = this.cREATEDBY;
    data['DOCNO'] = this.dOCNO;
    data['TSTARTLATLANG'] = this.tSTARTLATLANG;
    data['TENDLATLANG'] = this.tENDLATLANG;
    data['WSTARTLATLANG'] = this.wSTARTLATLANG;
    data['WENDLATLANG'] = this.wENDLATLANG;
    data['TRAVELTYPE'] = this.tRAVELTYPE;
    data['CUSTOMERCODE'] = this.cUSTOMERCODE;
    data['CUSTOMERNAME'] = this.cUSTOMERNAME;
    data['TRAVELSTART'] = this.tRAVELSTART;
    data['TRAVELEND'] = this.tRAVELEND;
    data['W_STARTCUSPLACE'] = this.wSTARTCUSPLACE;
    data['W_ENDCUSPLACE'] = this.wENDCUSPLACE;
    data['WORKSTARTCUSCODE'] = this.wORKSTARTCUSCODE;
    data['WORKSTARTCUSNAME'] = this.wORKSTARTCUSNAME;
    data['WSTARTTYPE'] = this.wSTARTTYPE;
    return data;
  }
}