class DashboardPatientModel {
  int? iipid;
  String? iPNo;
  String? regno;
  String? bedno;
  String? wardname;
  int? wifiFlag;

  DashboardPatientModel({
    this.iipid,
    this.iPNo,
    this.regno,
    this.bedno,
    this.wardname,
    this.wifiFlag
  });

  DashboardPatientModel.fromJson(Map<String, dynamic> json) {
    iipid = json['iipid'];
    iPNo = json['IPNo'];
    regno = json['Regno'];
    bedno = json['Bedno'];
    wardname = json['Wardname'];
    wifiFlag = json['WifiFlag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['iipid'] = this.iipid;
    data['IPNo'] = this.iPNo;
    data['Regno'] = this.regno;
    data['Bedno'] = this.bedno;
    data['Wardname'] = this.wardname;
    data['WifiFlag'] = this.wifiFlag;
    return data;
  }
}
