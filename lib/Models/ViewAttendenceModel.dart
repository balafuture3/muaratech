class ViewAttendenceList {
  final List<ViewAttendenceResponse> details;

  ViewAttendenceList({
    this.details,
  });

  factory ViewAttendenceList.fromJson(
      List<dynamic> parsedJson) {
    List<ViewAttendenceResponse> details =
    new List<ViewAttendenceResponse>();
    details = parsedJson
        .map((i) => ViewAttendenceResponse.fromJson(i))
        .toList();

    return new ViewAttendenceList(details: details);
  }
}


class ViewAttendenceResponse {
  String dOCDATE;
  String tRAVELTYPE;
  String cUSTOMERCODE;
  String cUSTOMERNAME;
  String tSTARTDATE;
  String tSTARTTIME;
  String wSTARTDATE;
  String wSTARTTIME;
  String wENDDATE;
  String wENDTIME;
  String tENDDATE;
  String tENDTIME;

  ViewAttendenceResponse(
      {this.dOCDATE,
        this.tRAVELTYPE,
        this.cUSTOMERCODE,
        this.cUSTOMERNAME,
        this.tSTARTDATE,
        this.tSTARTTIME,
        this.wSTARTDATE,
        this.wSTARTTIME,
        this.wENDDATE,
        this.wENDTIME,
        this.tENDDATE,
        this.tENDTIME});

  ViewAttendenceResponse.fromJson(Map<String, dynamic> json) {
    dOCDATE = json['DOCDATE'];
    tRAVELTYPE = json['TRAVELTYPE'];
    cUSTOMERCODE = json['CUSTOMERCODE'];
    cUSTOMERNAME = json['CUSTOMERNAME'];
    tSTARTDATE = json['T_STARTDATE'];
    tSTARTTIME = json['T_STARTTIME'];
    wSTARTDATE = json['W_STARTDATE'];
    wSTARTTIME = json['W_STARTTIME'];
    wENDDATE = json['W_ENDDATE'];
    wENDTIME = json['W_ENDTIME'];
    tENDDATE = json['T_ENDDATE'];
    tENDTIME = json['T_ENDTIME'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DOCDATE'] = this.dOCDATE;
    data['TRAVELTYPE'] = this.tRAVELTYPE;
    data['CUSTOMERCODE'] = this.cUSTOMERCODE;
    data['CUSTOMERNAME'] = this.cUSTOMERNAME;
    data['T_STARTDATE'] = this.tSTARTDATE;
    data['T_STARTTIME'] = this.tSTARTTIME;
    data['W_STARTDATE'] = this.wSTARTDATE;
    data['W_STARTTIME'] = this.wSTARTTIME;
    data['W_ENDDATE'] = this.wENDDATE;
    data['W_ENDTIME'] = this.wENDTIME;
    data['T_ENDDATE'] = this.tENDDATE;
    data['T_ENDTIME'] = this.tENDTIME;
    return data;
  }
}