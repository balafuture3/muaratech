class CustomerOfficeList {
  final List<CustomerOfficeModel> details;

  CustomerOfficeList({
    this.details,
  });

  factory CustomerOfficeList.fromJson(
      List<dynamic> parsedJson) {
    List<CustomerOfficeModel> details =
    new List<CustomerOfficeModel>();
    details = parsedJson
        .map((i) => CustomerOfficeModel.fromJson(i))
        .toList();

    return new CustomerOfficeList(details: details);
  }
}




class CustomerOfficeModel {
  String cardCode;
  String cardName;

  CustomerOfficeModel({this.cardCode, this.cardName});

  CustomerOfficeModel.fromJson(Map<String, dynamic> json) {
    cardCode = json['CardCode'];
    cardName = json['CardName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CardCode'] = this.cardCode;
    data['CardName'] = this.cardName;
    return data;
  }
}