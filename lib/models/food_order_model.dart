class FoodOrderModel {
  int? iBedId;
  String? cBedNo;
  String? cURL;
  String? cWardDesc;

  FoodOrderModel({this.iBedId, this.cBedNo, this.cURL, this.cWardDesc});

  FoodOrderModel.fromJson(Map<String, dynamic> json) {
    iBedId = json['iBed_id'];
    cBedNo = json['cBed_No'];
    cURL = json['cURL'];
    cWardDesc = json['cWard_Desc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['iBed_id'] = this.iBedId;
    data['cBed_No'] = this.cBedNo;
    data['cURL'] = this.cURL;
    data['cWard_Desc'] = this.cWardDesc;
    return data;
  }
}
