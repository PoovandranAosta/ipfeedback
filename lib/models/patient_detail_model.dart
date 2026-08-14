class PatientDetailModel {
  int? iIPId;
  int? iPatId;
  String? regNo;
  String? patientName;
  String? room;
  String? doctor;
  String? startDate;
  String? endDate;
  String? mobile;

  PatientDetailModel({
    this.iIPId,
    this.iPatId,
    this.regNo,
    this.patientName,
    this.room,
    this.doctor,
    this.startDate,
    this.endDate,
    this.mobile,
  });

  PatientDetailModel.fromJson(Map<String, dynamic> json) {
    iIPId = json['iIP_id'];
    iPatId = json['iPat_id'];
    regNo = json['RegNo'];
    patientName = json['PatientName'];
    room = json['Room'];
    doctor = json['Doctor'];
    startDate = json['StartDate'];
    endDate = json['endDate'];
    mobile = json['mobile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['iIP_id'] = this.iIPId;
    data['iPat_id'] = this.iPatId;
    data['RegNo'] = this.regNo;
    data['PatientName'] = this.patientName;
    data['Room'] = this.room;
    data['Doctor'] = this.doctor;
    data['StartDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['mobile'] = this.mobile;
    return data;
  }
}
