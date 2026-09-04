class BedMasterModel {
  int? iBedId;
  String? column1;

  BedMasterModel({this.iBedId, this.column1});

  BedMasterModel.fromJson(Map<String, dynamic> json) {
    iBedId = json['iBed_id'];
    column1 = json['Column1'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['iBed_id'] = this.iBedId;
    data['Column1'] = this.column1;
    return data;
  }
}
